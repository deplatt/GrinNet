/**
 * GrinNet Backend Express Server
 *
 * This server handles API routes for user accounts, posts, and reports,
 * interacting with a PostgreSQL database for persistent storage.
 * It includes endpoints for creating, modifying, and deleting users/posts,
 * managing reports, and retrieving post data.
 *
 * @routes
 * POST   /users                  Create a new user
 * PUT    /users/:id/ban          Ban a user
 * PUT    /users/:id/warn         Warn a user
 * PUT    /users/:id/bio          Update a user's bio
 * PUT    /users/:id/profile-picture Update a user's profile picture
 * DELETE /users/:id              Delete a user
 *
 * POST   /posts                  Create a new post
 * PUT    /posts/:id/terminate    Mark a post as terminated
 * DELETE /posts/:id              Delete a post
 * GET    /posts                  Fetch all active posts
 * POST   /clear                  Clear the entire database
 *
 * POST   /reports                Submit a report on a post
 * DELETE /reports/:id            Dismiss a report
 */

// ========== Configurable Logging Setup ==========
const fs = require('fs');
const path = require('path');
const logToFile = false; // Toggle to `true` to enable logging to a file
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

const express = require('express');
const cors = require('cors');
const app = express();
const config = require('./config');

// Middleware
app.use(cors());
app.use(express.json());

// Database function imports
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
  reportPost,
  dismissReport
} = require('./functions');

/* ======================== User Routes ======================== */

// Create a new user
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

// Ban a user by ID
app.put('/users/:id/ban', async (req, res) => {
  try {
    const user = await banUser(req.params.id);
    logger(`User banned: ID ${req.params.id}`);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Warn a user by ID
app.put('/users/:id/warn', async (req, res) => {
  try {
    const user = await warnUser(req.params.id);
    logger(`User warned: ID ${req.params.id}`);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Update a user's bio
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

// Update a user's profile picture
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

// Delete a user
app.delete('/users/:id', async (req, res) => {
  try {
    const user = await deleteUser(req.params.id);
    logger(`User deleted: ID ${req.params.id}`);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/* ======================== Post Routes ======================== */

// Create a new post
app.post('/posts', async (req, res) => {
  try {
    const { creator, postText, postImage, postTags, eventDate } = req.body;
    if (!creator || !postText || !Array.isArray(postTags)) {
      return res.status(400).json({ error: 'Missing required fields' });
    }
    const post = await createPost(creator, postText, postImage, postTags, eventDate);
    logger(`Post created by user ID ${creator}`);
    res.status(201).json(post);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Terminate a post
app.put('/posts/:id/terminate', async (req, res) => {
  try {
    const post = await terminatePost(req.params.id);
    logger(`Post terminated: ID ${req.params.id}`);
    res.json(post);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Delete a post
app.delete('/posts/:id', async (req, res) => {
  try {
    const post = await deletePost(req.params.id);
    logger(`Post deleted: ID ${req.params.id}`);
    res.json(post);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get all posts
app.get('/posts', async (req, res) => {
  try {
    const posts = await getAllPosts();
    logger(`Fetched all posts`);
    res.json(posts);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Clear the entire database
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

// Submit a report
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

// Dismiss a report
app.delete('/reports/:id', async (req, res) => {
  try {
    const report = await dismissReport(req.params.id);
    logger(`Report dismissed: ID ${req.params.id}`);
    res.json(report);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/* ======================== Server Startup ======================== */

if (require.main === module) {
  app.listen(config.PORT, () => {
    logger(`GrinNet backend server running on port ${config.PORT}`);
  });
}

module.exports = app;
