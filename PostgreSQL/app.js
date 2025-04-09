const express = require('express');
const app = express();

// Parse incoming JSON bodies
app.use(express.json());

// Import configuration for magic numbers
const config = require('./config');
const port = process.env.PORT || config.PORT;

// Import functions from the database module
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
  reportPost,
  dismissReport
} = require('./functions.js');

/* ========================
   User-related Endpoints
   ======================== */

// Create a new user
app.post('/users', async (req, res) => {
  try {
    const { username, bioText, profilePicture } = req.body;
    const user = await createUser(username, bioText, profilePicture);
    res.status(201).json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Ban a user
app.put('/users/:id/ban', async (req, res) => {
  try {
    const user = await banUser(req.params.id);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Warn a user
app.put('/users/:id/warn', async (req, res) => {
  try {
    const user = await warnUser(req.params.id);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Change bio text for a user
app.put('/users/:id/bio', async (req, res) => {
  try {
    const { newBio } = req.body;
    const user = await changeBio(req.params.id, newBio);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Change profile picture for a user
app.put('/users/:id/profile-picture', async (req, res) => {
  try {
    const { newProfilePicture } = req.body;
    const user = await changeProfilePicture(req.params.id, newProfilePicture);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Delete a user
app.delete('/users/:id', async (req, res) => {
  try {
    const user = await deleteUser(req.params.id);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/* ========================
   Post-related Endpoints
   ======================== */

// Create a new post
app.post('/posts', async (req, res) => {
  try {
    const { creator, postText, postImage, postTags } = req.body;
    const post = await createPost(creator, postText, postImage, postTags);
    res.status(201).json(post);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Terminate a post
app.put('/posts/:id/terminate', async (req, res) => {
  try {
    const post = await terminatePost(req.params.id);
    res.json(post);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Delete a post
app.delete('/posts/:id', async (req, res) => {
  try {
    const post = await deletePost(req.params.id);
    res.json(post);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Refresh posts
app.get('/posts', async (req, res) => {
  try {
    const posts = await require('./functions.js').getAllPosts();
    res.json(posts);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/* ========================
   Report-related Endpoints
   ======================== */

// Report a post
app.post('/reports', async (req, res) => {
  try {
    const { reportedUser, complaintText, postId, reporterUser } = req.body;
    const report = await reportPost(reportedUser, complaintText, postId, reporterUser);
    res.status(201).json(report);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Dismiss a report
app.delete('/reports/:id', async (req, res) => {
  try {
    const report = await dismissReport(req.params.id);
    res.json(report);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/* ========================
   Start the Server
   ======================== */

// if you want to start up the server manually, uncomment this and use it. 
// app.listen(port, () => {
//   console.log(`Server running on port ${port}`);
// });

if (require.main === module) {
  app.listen(port, () => {
    console.log(`Server running on port ${port}`);
  });
}

module.exports = app;
