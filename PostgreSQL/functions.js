const { Pool } = require('pg');
const crypto = require('crypto');

// Updated pool configuration
const pool = new Pool({
  user: process.env.DB_USER || 'postgres',
  host: process.env.DB_HOST || '132.161.166.56',
  database: process.env.DB_DATABASE || 'GrinNetDev',
  password: process.env.DB_PASSWORD || 'csc324AdminDropTheClass!',
  port: process.env.DB_PORT ? parseInt(process.env.DB_PORT) : 5432,
});

// Helper function to execute a query
async function query(text, params) {
  const res = await pool.query(text, params);
  return res;
}

// Helper function to generate a random salt
function generateSalt() {
  return crypto.randomBytes(16).toString('hex');
}

// Helper function to hash a password using pbkdf2
function hashPassword(password, salt) {
  return crypto.pbkdf2Sync(password, salt, 1000, 64, 'sha512').toString('hex');
}

/* ========================
   User-related functions
   ======================== */

// Create a new user
async function createUser(username, password, bioText = '', profilePicture = '') {
  const salt = generateSalt();
  const hashedPassword = hashPassword(password, salt);
  // We'll set an initial status as the SQL CHECK requires one of the allowed values.
  const status = 'nothing';
  const insertQuery = `
    INSERT INTO users (username, bio_text, profile_picture, salt_for_password, hashed_password, status)
    VALUES ($1, $2, $3, $4, $5, $6)
    RETURNING *
  `;
  const values = [username, bioText, profilePicture, salt, hashedPassword, status];
  const result = await query(insertQuery, values);
  return result.rows[0];
}

// Ban a user by updating their status
async function banUser(userId) {
  const updateQuery = `
    UPDATE users
    SET status = 'banned'
    WHERE id = $1
    RETURNING *
  `;
  const result = await query(updateQuery, [userId]);
  return result.rows[0];
}

// Warn a user by updating their status
async function warnUser(userId) {
  const updateQuery = `
    UPDATE users
    SET status = 'warned'
    WHERE id = $1
    RETURNING *
  `;
  const result = await query(updateQuery, [userId]);
  return result.rows[0];
}

// Change the bio text for a user
async function changeBio(userId, newBio) {
  const updateQuery = `
    UPDATE users
    SET bio_text = $1
    WHERE id = $2
    RETURNING *
  `;
  const result = await query(updateQuery, [newBio, userId]);
  return result.rows[0];
}

// Change the profile picture for a user
async function changeProfilePicture(userId, newProfilePicture) {
  const updateQuery = `
    UPDATE users
    SET profile_picture = $1
    WHERE id = $2
    RETURNING *
  `;
  const result = await query(updateQuery, [newProfilePicture, userId]);
  return result.rows[0];
}

// Change the password for a user (generates a new salt and hash)
async function changePassword(userId, newPassword) {
  const salt = generateSalt();
  const hashedPassword = hashPassword(newPassword, salt);
  const updateQuery = `
    UPDATE users
    SET salt_for_password = $1, hashed_password = $2
    WHERE id = $3
    RETURNING *
  `;
  const result = await query(updateQuery, [salt, hashedPassword, userId]);
  return result.rows[0];
}

// Check if a provided password is correct for a given username
async function checkPassword(username, password) {
  const selectQuery = `
    SELECT salt_for_password, hashed_password
    FROM users
    WHERE username = $1
  `;
  const result = await query(selectQuery, [username]);
  if (result.rows.length === 0) {
    throw new Error("User not found");
  }
  const { salt_for_password, hashed_password } = result.rows[0];
  const attemptedHash = hashPassword(password, salt_for_password);
  return attemptedHash === hashed_password;
}

// Delete a user (and optionally clean up related posts and reports)
async function deleteUser(userId) {
  // Remove any reports made by or against the user
  await query(`DELETE FROM reports WHERE reported_user = $1 OR reporter_user = $1`, [userId]);
  // Remove all posts created by the user
  await query(`DELETE FROM posts WHERE creator = $1`, [userId]);
  // Delete the user record
  const deleteQuery = `
    DELETE FROM users
    WHERE id = $1
    RETURNING *
  `;
  const result = await query(deleteQuery, [userId]);
  return result.rows[0];
}

/* ========================
   Post-related functions
   ======================== */

// Create a new post
async function createPost(creator, postText, postImage = '', postTags = []) {
  const insertQuery = `
    INSERT INTO posts (creator, post_text, post_image, post_tags)
    VALUES ($1, $2, $3, $4)
    RETURNING *
  `;
  const result = await query(insertQuery, [creator, postText, postImage, postTags]);
  return result.rows[0];
}

// Terminate a post (set its termination date to now). This will make the post disappear from public view, but not delete. This happens if somebody reports a post.
async function terminatePost(postId) {
  const updateQuery = `
    UPDATE posts
    SET date_of_termination = CURRENT_TIMESTAMP
    WHERE post_id = $1
    RETURNING *
  `;
  const result = await query(updateQuery, [postId]);
  return result.rows[0];
}

// Delete a post if it has been terminated and has no reports
async function deletePost(postId) {
  // Check if the post has been terminated and has no reports
  const checkQuery = `
    SELECT p.date_of_termination, COUNT(r.report_id) AS report_count
    FROM posts p
    LEFT JOIN reports r ON p.post_id = r.post_id
    WHERE p.post_id = $1
    GROUP BY p.date_of_termination
  `;
  
  const result = await query(checkQuery, [postId]);

  if (result.rows.length === 0) {
    throw new Error("Post not found.");
  }

  const { date_of_termination, report_count } = result.rows[0];

  if (!date_of_termination) {
    throw new Error("Post must be terminated before deletion.");
  }

  if (parseInt(report_count) > 0) {
    throw new Error("Post has reports and cannot be deleted.");
  }

  // Delete the post
  const deleteQuery = `
    DELETE FROM posts
    WHERE post_id = $1
    RETURNING *
  `;
  const deleteResult = await query(deleteQuery, [postId]);
  
  return deleteResult.rows[0];
}



/* ========================
   Report-related functions
   ======================== */

// Report a post and update the reported user's report count and status
async function reportPost(reportedUser, complaintText, postId, reporterUser) {
  const insertQuery = `
    INSERT INTO reports (reported_user, complaint_text, post_id, reporter_user)
    VALUES ($1, $2, $3, $4)
    RETURNING *
  `;
  const result = await query(insertQuery, [reportedUser, complaintText, postId, reporterUser]);
  
  // Increment the user's report count and mark their status as "reported"
  const updateReportsQuery = `
    UPDATE users
    SET num_of_reports = num_of_reports + 1, status = 'reported'
    WHERE id = $1
    RETURNING *
  `;
  await query(updateReportsQuery, [reportedUser]);
  
  return result.rows[0];
}

// Dismiss a report (deleting it from the reports table)
async function dismissReport(reportId) {
  const deleteQuery = `
    DELETE FROM reports
    WHERE report_id = $1
    RETURNING *
  `;
  const result = await query(deleteQuery, [reportId]);
  return result.rows[0];
}

module.exports = {
  createUser,
  banUser,
  warnUser,
  changeBio,
  changeProfilePicture,
  changePassword,
  checkPassword,
  createPost,
  terminatePost,
  deletePost,
  reportPost,
  dismissReport,
  deleteUser
};
