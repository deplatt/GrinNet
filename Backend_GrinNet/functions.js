/**
 * GrinNet Database Access Functions
 *
 * Provides PostgreSQL database operations for users, posts, and reports.
 * Supports account management, post creation and termination, image clearing,
 * and report handling. Used by backend Express API routes and integration tests.
 *
 * @module functions
 */

const { Pool } = require('pg');
const config = require('./config');
const fs = require('fs');
const path = require('path');

const UPLOAD_DIR = path.join(__dirname, 'uploads');

// Initialize PostgreSQL connection pool
const pool = new Pool({
  user: process.env.DB_USER || config.DB_USER,
  host: process.env.DB_HOST || config.DB_HOST,
  database: process.env.DB_DATABASE || config.DB_DATABASE,
  password: process.env.DB_PASSWORD || config.DB_PASSWORD,
  port: process.env.DB_PORT ? parseInt(process.env.DB_PORT) : config.DB_PORT,
});

/**
 * Executes a SQL query on the database.
 *
 * @param {string} text - SQL query string
 * @param {Array} [params] - Query parameters
 * @returns {Promise<object>} Query result
 */
async function query(text, params) {
  const res = await pool.query(text, params);
  return res;
}

/* ======================== User Functions ======================== */

/**
 * Creates a new user with a username, bio text, and profile picture.
 *
 * @param {string} username - Username of the new user
 * @param {string} [bioText=''] - Optional biography text
 * @param {string} [profilePicture=''] - Optional profile picture path
 * @returns {Promise<object>} Created user record
 */
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

/**
 * Bans a user by setting their status to 'banned'.
 *
 * @param {number} userId - User ID to ban
 * @returns {Promise<object>} Updated user record
 */
async function banUser(userId) {
  const updateQuery = `UPDATE users SET status = 'banned' WHERE id = $1 RETURNING *;`;
  const result = await query(updateQuery, [userId]);
  return result.rows[0];
}

/**
 * Warns a user by setting their status to 'warned'.
 *
 * @param {number} userId - User ID to warn
 * @returns {Promise<object>} Updated user record
 */
async function warnUser(userId) {
  const updateQuery = `UPDATE users SET status = 'warned' WHERE id = $1 RETURNING *;`;
  const result = await query(updateQuery, [userId]);
  return result.rows[0];
}

/**
 * Changes a user's biography text.
 *
 * @param {number} userId - User ID to update
 * @param {string} newBio - New biography text
 * @returns {Promise<object>} Updated user record
 */
async function changeBio(userId, newBio) {
  const updateQuery = `UPDATE users SET bio_text = $1 WHERE id = $2 RETURNING *;`;
  const result = await query(updateQuery, [newBio, userId]);
  return result.rows[0];
}

/**
 * Updates a user's profile picture.
 *
 * @param {number} userId - User ID to update
 * @param {string} newProfilePicture - New profile picture path
 * @returns {Promise<object>} Updated user record
 */
async function changeProfilePicture(userId, newProfilePicture) {
  const updateQuery = `UPDATE users SET profile_picture = $1 WHERE id = $2 RETURNING *;`;
  const result = await query(updateQuery, [newProfilePicture, userId]);
  return result.rows[0];
}

/**
 * Deletes a user and their associated posts and reports.
 *
 * @param {number} userId - User ID to delete
 * @returns {Promise<object>} Deleted user record
 */
async function deleteUser(userId) {
  await query(`DELETE FROM reports WHERE reported_user = $1 OR reporter_user = $1;`, [userId]);
  await query(`DELETE FROM posts WHERE creator = $1;`, [userId]);
  const deleteQuery = `DELETE FROM users WHERE id = $1 RETURNING *;`;
  const result = await query(deleteQuery, [userId]);
  return result.rows[0];
}

/* ======================== Post Functions ======================== */

/**
 * Creates a new post with optional image, tags, and event date.
 *
 * @param {number} creator - User ID of post creator
 * @param {string} postText - Post content
 * @param {string} [postImage=''] - Optional image path
 * @param {Array<string>} [postTags=[]] - Array of tags
 * @param {Date|null} [eventDate=null] - Event date, if applicable
 * @returns {Promise<object>} Created post record
 */
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

/**
 * Terminates a post by setting its termination timestamp.
 *
 * @param {number} postId - Post ID to terminate
 * @returns {Promise<object>} Updated post record
 */
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

/**
 * Deletes a post if it is terminated and has no reports.
 *
 * @param {number} postId - Post ID to delete
 * @returns {Promise<object>} Deleted post record
 * @throws {Error} If the post is not terminated or has reports
 */
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

/**
 * Fetches all active and non-expired posts.
 *
 * @returns {Promise<Array>} Array of post objects
 */
async function getAllPosts() {
  const selectQuery = `
    SELECT 
      to_char(p.date_created, 'YYYY-MM-DD') AS creation_date,
      to_char(p.date_created, 'HH24:MI:SS') AS creation_time,
      p.post_text,
      p.post_image,
      p.post_tags,
      u.profile_picture,
      u.username,
      p.creator,
      p.post_id
    FROM posts p 
    JOIN users u ON p.creator = u.id
    WHERE (p.date_of_termination IS NULL OR p.date_of_termination > CURRENT_TIMESTAMP)
      AND (p.event_date IS NULL OR p.event_date + interval '1 day' > CURRENT_TIMESTAMP)
    ORDER BY p.date_created DESC;
  `;
  const result = await query(selectQuery);
  return result.rows;
}

/**
 * Clears all users, posts, and reports from the database.
 * Also deletes all uploaded images.
 *
 * @returns {Promise<void>}
 */
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

/**
 * Deletes all posts whose event_date + 1 day has passed,
 * only if they are terminated and have no reports.
 */
async function cleanupExpiredPosts() {
  const expiredQuery = `
    SELECT p.post_id
    FROM posts p
    LEFT JOIN reports r ON p.post_id = r.post_id
    WHERE p.event_date IS NOT NULL
      AND p.event_date + interval '1 day' < CURRENT_TIMESTAMP
      AND p.date_of_termination IS NOT NULL
    GROUP BY p.post_id, p.date_of_termination
    HAVING COUNT(r.report_id) = 0;
  `;
  const result = await query(expiredQuery);

  for (const row of result.rows) {
    try {
      await deletePost(row.post_id);
    } catch (err) {
      console.error(`Failed to delete post ${row.post_id}:`, err.message);
    }
  }
}

/* ======================== Report Functions ======================== */

/**
 * Submits a report for a user/post and increments the reported user's report count.
 *
 * @param {number} reportedUser - ID of the user being reported
 * @param {string} complaintText - Complaint details
 * @param {number} postId - ID of the post involved
 * @param {number} reporterUser - ID of the user submitting the report
 * @returns {Promise<object>} Created report record
 */
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

/**
 * Dismisses (deletes) a report by report ID.
 *
 * @param {number} reportId - Report ID to dismiss
 * @returns {Promise<object>} Deleted report record
 */
async function dismissReport(reportId) {
  const deleteQuery = `DELETE FROM reports WHERE report_id = $1 RETURNING *;`;
  const result = await query(deleteQuery, [reportId]);
  return result.rows[0];
}

/* ======================== Exports ======================== */

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
  cleanupExpiredPosts,
  reportPost,
  dismissReport,
  query
};
