/**
 * Database access functions for users, posts, and reports in the GrinNet system.
 * 
 * This module provides a wrapper around PostgreSQL queries using the pg library.
 * Used by routes in app.js and test cases in test.js.
 * 
 * @module functions
 */

const { Pool } = require('pg');
const config = require('./config');
const fs = require('fs');
const path = require('path');
const UPLOAD_DIR = path.join(__dirname, 'uploads');

const pool = new Pool({
  user: process.env.DB_USER || config.DB_USER,
  host: process.env.DB_HOST || config.DB_HOST,
  database: process.env.DB_DATABASE || config.DB_DATABASE,
  password: process.env.DB_PASSWORD || config.DB_PASSWORD,
  port: process.env.DB_PORT ? parseInt(process.env.DB_PORT) : config.DB_PORT,
});

/** Executes a SQL query using the connection pool. */
async function query(text, params) {
  const res = await pool.query(text, params);
  return res;
}

/* ======================== User-related functions ======================== */

async function createUser(username, bioText = '', profilePicture = '') {
  const status = 'nothing';
  const insertQuery = `
    INSERT INTO users (username, bio_text, profile_picture, status)
    VALUES ($1, $2, $3, $4)
    RETURNING *;
  `;
  const result = await query(insertQuery, [username, bioText, profilePicture, status]);
  return result.rows[0];
}

async function banUser(userId) {
  const updateQuery = `UPDATE users SET status = 'banned' WHERE id = $1 RETURNING *;`;
  const result = await query(updateQuery, [userId]);
  return result.rows[0];
}

async function warnUser(userId) {
  const updateQuery = `UPDATE users SET status = 'warned' WHERE id = $1 RETURNING *;`;
  const result = await query(updateQuery, [userId]);
  return result.rows[0];
}

async function changeBio(userId, newBio) {
  const updateQuery = `UPDATE users SET bio_text = $1 WHERE id = $2 RETURNING *;`;
  const result = await query(updateQuery, [newBio, userId]);
  return result.rows[0];
}

async function changeProfilePicture(userId, newProfilePicture) {
  const updateQuery = `UPDATE users SET profile_picture = $1 WHERE id = $2 RETURNING *;`;
  const result = await query(updateQuery, [newProfilePicture, userId]);
  return result.rows[0];
}

async function deleteUser(userId) {
  await query(`DELETE FROM reports WHERE reported_user = $1 OR reporter_user = $1;`, [userId]);
  await query(`DELETE FROM posts WHERE creator = $1;`, [userId]);
  const deleteQuery = `DELETE FROM users WHERE id = $1 RETURNING *;`;
  const result = await query(deleteQuery, [userId]);
  return result.rows[0];
}

/* ======================== Post-related functions ======================== */

async function createPost(creator, postText, postImage = '', postTags = [], eventDate = null) {
  const terminationDate = eventDate ? new Date(new Date(eventDate).getTime() + 24 * 60 * 60 * 1000) : null;

  const insertQuery = `
    INSERT INTO posts (creator, post_text, post_image, post_tags, event_date, date_of_termination)
    VALUES ($1, $2, $3, $4, $5, $6)
    RETURNING *;
  `;
  const result = await query(insertQuery, [creator, postText, postImage, postTags, eventDate, terminationDate]);
  return result.rows[0];
}

async function terminatePost(postId) {
  const updateQuery = `
    UPDATE posts
    SET date_of_termination = CURRENT_TIMESTAMP
    WHERE post_id = $1
    RETURNING *;
  `;
  const result = await query(updateQuery, [postId]);
  return result.rows[0];
}

async function deletePost(postId) {
  const checkQuery = `
    SELECT p.date_of_termination, COUNT(r.report_id) AS report_count
    FROM posts p
    LEFT JOIN reports r ON p.post_id = r.post_id
    WHERE p.post_id = $1
    GROUP BY p.date_of_termination;
  `;
  const result = await query(checkQuery, [postId]);
  if (result.rows.length === 0) throw new Error("Post not found.");
  const { date_of_termination, report_count } = result.rows[0];
  if (!date_of_termination) throw new Error("Post must be terminated before deletion.");
  if (parseInt(report_count) > 0) throw new Error("Post has reports and cannot be deleted.");
  const deleteQuery = `DELETE FROM posts WHERE post_id = $1 RETURNING *;`;
  const deleteResult = await query(deleteQuery, [postId]);
  return deleteResult.rows[0];
}

async function getAllPosts() {
  const selectQuery = `
    SELECT 
      to_char(p.date_created, 'YYYY-MM-DD') AS creation_date,
      to_char(p.date_created, 'HH24:MI:SS') AS creation_time,
      p.post_text,
      p.post_image,
      p.post_tags,
      u.profile_picture,
      u.username
    FROM posts p 
    JOIN users u ON p.creator = u.id
    WHERE p.date_of_termination IS NULL OR p.date_of_termination > CURRENT_TIMESTAMP
    ORDER BY p.date_created DESC;
  `;
  const result = await query(selectQuery);
  return result.rows;
}

async function clearDatabase() {
  await pool.query('DELETE FROM reports');
  await pool.query('DELETE FROM posts');
  await pool.query('DELETE FROM users');
  fs.readdirSync(UPLOAD_DIR).forEach(file => {
    try {
      fs.unlinkSync(path.join(UPLOAD_DIR, file));
    } catch (err) {
      console.error("Error deleting:", file, err.message);
    }
  });
}

/* ======================== Report-related functions ======================== */

async function reportPost(reportedUser, complaintText, postId, reporterUser) {
  const insertQuery = `
    INSERT INTO reports (reported_user, complaint_text, post_id, reporter_user)
    VALUES ($1, $2, $3, $4)
    RETURNING *;
  `;
  const result = await query(insertQuery, [reportedUser, complaintText, postId, reporterUser]);
  const updateReportsQuery = `
    UPDATE users
    SET num_of_reports = num_of_reports + 1, status = 'reported'
    WHERE id = $1
    RETURNING *;
  `;
  await query(updateReportsQuery, [reportedUser]);
  return result.rows[0];
}

async function dismissReport(reportId) {
  const deleteQuery = `DELETE FROM reports WHERE report_id = $1 RETURNING *;`;
  const result = await query(deleteQuery, [reportId]);
  return result.rows[0];
}

module.exports = {
  createUser,
  banUser,
  warnUser,
  changeBio,
  changeProfilePicture,
  deleteUser,
  createPost,
  terminatePost,
  deletePost,
  getAllPosts,
  clearDatabase,
  reportPost,
  dismissReport
};