/**
 * GrinNet Backend Express Server
 *
 * This server handles API routes for user accounts, posts, and reports,
 * interacting with a PostgreSQL database for persistent storage.
 * 
 * @routes
 * POST   /users                    Create a new user
 * PUT    /users/:id/ban            Ban a user
 * PUT    /users/:id/warn           Warn a user
 * PUT    /users/:id/bio            Update a user's bio
 * PUT    /users/:id/profile-picture Update a user's profile picture
 * DELETE /users/:id                Delete a user
 * GET    /users                    Retrieve a user by username
 * 
 * POST   /posts                    Create a new post
 * PUT    /posts/:id/terminate      Terminate a post
 * DELETE /posts/:id                Delete a post
 * GET    /posts                    Retrieve all active posts
 * POST   /clear                    Clear the entire database
 * 
 * POST   /reports                  Submit a report
 * DELETE /reports/:id              Dismiss a report
 */

const fs = require('fs');
const path = require('path');
const express = require('express');
const cors = require('cors');
const config = require('./config');
const cron = require('node-cron');
const app = express();
const {
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
  dismissReport
} = require('./functions');

// ========== Logging Setup ==========
const logToFile = false;
const logFilePath = path.join(__dirname, 'express_server.log');

function logger(message) {
  const logEntry = `[${new Date().toISOString()}] ${message}`;
  if (logToFile) {
    fs.appendFileSync(logFilePath, logEntry + '\n');
  } else {
    console.log(logEntry);
  }
}
// =================================================

app.use(cors());
app.use(express.json());

/* ======================== User Routes ======================== */

/**
 * Create a new user
 * 
 * @route POST /users
 * @body {string} username - Username of the user
 * @body {string} bioText - Biography text
 * @body {string} profilePicture - Profile picture path
 */
app.post('/users', async (req, res) => {
  try {
    const { username, bioText, profilePicture } = req.body;
    const user = await createUser(username, bioText, profilePicture);
    logger(`User created: ${username}`);
    res.status(201).json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * Ban a user
 * 
 * @route PUT /users/:id/ban
 */
app.put('/users/:id/ban', async (req, res) => {
  try {
    const user = await banUser(req.params.id);
    logger(`User banned: ID ${req.params.id}`);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * Warn a user
 * 
 * @route PUT /users/:id/warn
 */
app.put('/users/:id/warn', async (req, res) => {
  try {
    const user = await warnUser(req.params.id);
    logger(`User warned: ID ${req.params.id}`);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * Update a user's biography
 * 
 * @route PUT /users/:id/bio
 * @body {string} newBio - New biography text
 */
app.put('/users/:id/bio', async (req, res) => {
  try {
    const { newBio } = req.body;
    const user = await changeBio(req.params.id, newBio);
    logger(`Bio changed for user ID ${req.params.id}`);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * Update a user's profile picture
 * 
 * @route PUT /users/:id/profile-picture
 * @body {string} newProfilePicture - New profile picture path
 */
app.put('/users/:id/profile-picture', async (req, res) => {
  try {
    const { newProfilePicture } = req.body;
    const user = await changeProfilePicture(req.params.id, newProfilePicture);
    logger(`Profile picture updated for user ID ${req.params.id}`);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * Delete a user
 * 
 * @route DELETE /users/:id
 */
app.delete('/users/:id', async (req, res) => {
  try {
    const user = await deleteUser(req.params.id);
    logger(`User deleted: ID ${req.params.id}`);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * Retrieve a user by username
 * 
 * @route GET /users
 * @query {string} username - Username to lookup
 */
app.get('/users', async (req, res) => {
  try {
    const username = req.query.username;
    if (!username) {
      return res.status(400).json({ error: 'Username required' });
    }
    const result = await query('SELECT * FROM users WHERE username = $1', [username]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/* ======================== Post Routes ======================== */

/**
 * Create a new post
 * 
 * @route POST /posts
 * @body {number} creator - User ID who created the post
 * @body {string} postText - Text content of the post
 * @body {string} postImage - Path to the post image
 * @body {Array<string>} postTags - List of tags
 * @body {string} eventDate - Event date in ISO format
 */
app.post('/posts', async (req, res) => {
  try {
    const { creator, postText, postImage, postTags, eventDate } = req.body;
    logger(`[POST /posts] Received: creator=${creator}, postText=${postText ? postText.length : 'null'} chars, postImage=${postImage}, postTags=${JSON.stringify(postTags)}, eventDate=${eventDate}`);
    
    if (!creator || !postText || !Array.isArray(postTags)) {
      logger('[POST /posts] Missing required fields!');
      return res.status(400).json({ error: 'Missing required fields' });
    }
    
    const post = await createPost(creator, postText, postImage, postTags, eventDate);
    logger(`[POST /posts] Post created by user ID ${creator}`);
    res.status(201).json(post);
  } catch (error) {
    logger(`[POST /posts] Error: ${error.message}`);
    res.status(500).json({ error: error.message });
  }
});

/**
 * Terminate a post
 * 
 * @route PUT /posts/:id/terminate
 */
app.put('/posts/:id/terminate', async (req, res) => {
  try {
    const post = await terminatePost(req.params.id);
    logger(`Post terminated: ID ${req.params.id}`);
    res.json(post);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * Delete a post
 * 
 * @route DELETE /posts/:id
 */
app.delete('/posts/:id', async (req, res) => {
  try {
    const post = await deletePost(req.params.id);
    logger(`Post deleted: ID ${req.params.id}`);
    res.json(post);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * Retrieve all active posts
 * 
 * @route GET /posts
 */
app.get('/posts', async (req, res) => {
  try {
    const posts = await getAllPosts();
    logger(`Fetched all posts`);
    res.json(posts);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * Clear the entire database
 * 
 * @route POST /clear
 */
app.post('/clear', async (req, res) => {
  try {
    await clearDatabase();
    logger(`Database cleared`);
    res.status(200).json({ message: 'Database cleared.' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/* ======================== Report Routes ======================== */

/**
 * Submit a report against a post
 * 
 * @route POST /reports
 * @body {number} reportedUser - User being reported
 * @body {string} complaintText - Complaint text
 * @body {number} postId - ID of the reported post
 * @body {number} reporterUser - User who reports
 */
app.post('/reports', async (req, res) => {
  try {
    const { reportedUser, complaintText, postId, reporterUser } = req.body;
    const report = await reportPost(reportedUser, complaintText, postId, reporterUser);
    logger(`Report submitted on post ID ${postId} by user ID ${reporterUser}`);
    res.status(201).json(report);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * Dismiss a report
 * 
 * @route DELETE /reports/:id
 */
app.delete('/reports/:id', async (req, res) => {
  try {
    const report = await dismissReport(req.params.id);
    logger(`Report dismissed: ID ${req.params.id}`);
    res.json(report);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/* ======================== Server Startup/Maintenance ======================== */

// Run every day at midnight. Cleans up expired posts.
cron.schedule('0 0 * * *', async () => {
  logger('[CRON] Running cleanupExpiredPosts...');
  try {
    await cleanupExpiredPosts();
    logger('[CRON] Cleanup completed.');
  } catch (err) {
    logger('[CRON] Cleanup failed: ' + err.message);
  }
});

/**
 * Start the GrinNet backend server
 *
 * @listen config.PORT
 */
if (require.main === module) {
  app.listen(config.PORT, () => {
    logger(`GrinNet backend server running on port ${config.PORT}`);
  });
}

module.exports = app;
