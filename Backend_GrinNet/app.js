/**
 * Express server entry point for the GrinNet backend.
 * Handles user, post, and report-related endpoints with PostgreSQL support.
 * 
 * Routes:
 * - /users
 * - /posts
 * - /reports
 * 
 * Dependencies: Express, CORS, PostgreSQL pool functions.
 * 
 * @module app
 */

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

app.post('/users', async (req, res) => {
  try {
    const { username, bioText, profilePicture } = req.body;
    const user = await createUser(username, bioText, profilePicture);
    res.status(201).json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.put('/users/:id/ban', async (req, res) => {
  try {
    const user = await banUser(req.params.id);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.put('/users/:id/warn', async (req, res) => {
  try {
    const user = await warnUser(req.params.id);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.put('/users/:id/bio', async (req, res) => {
  try {
    const { newBio } = req.body;
    const user = await changeBio(req.params.id, newBio);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.put('/users/:id/profile-picture', async (req, res) => {
  try {
    const { newProfilePicture } = req.body;
    const user = await changeProfilePicture(req.params.id, newProfilePicture);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.delete('/users/:id', async (req, res) => {
  try {
    const user = await deleteUser(req.params.id);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/* ======================== Post Routes ======================== */

app.post('/posts', async (req, res) => {
  try {
    const { creator, postText, postImage, postTags, eventDate } = req.body;
    if (!creator || !postText || !Array.isArray(postTags)) {
      return res.status(400).json({ error: 'Missing required fields' });
    }
    const post = await createPost(creator, postText, postImage, postTags, eventDate);
    res.status(201).json(post);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.put('/posts/:id/terminate', async (req, res) => {
  try {
    const post = await terminatePost(req.params.id);
    res.json(post);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.delete('/posts/:id', async (req, res) => {
  try {
    const post = await deletePost(req.params.id);
    res.json(post);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/posts', async (req, res) => {
  try {
    const posts = await getAllPosts();
    res.json(posts);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/clear', async (req, res) => {
  try {
    await clearDatabase();
    res.status(200).json({ message: 'Database cleared.' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/* ======================== Report Routes ======================== */

app.post('/reports', async (req, res) => {
  try {
    const { reportedUser, complaintText, postId, reporterUser } = req.body;
    const report = await reportPost(reportedUser, complaintText, postId, reporterUser);
    res.status(201).json(report);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.delete('/reports/:id', async (req, res) => {
  try {
    const report = await dismissReport(req.params.id);
    res.json(report);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/* ======================== Server ======================== */

if (require.main === module) {
  app.listen(config.PORT, () => {
    console.log(`[INFO] GrinNet backend server running on port ${config.PORT}`);
  });
}

module.exports = app;