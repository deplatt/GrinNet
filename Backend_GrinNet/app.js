const express = require('express');
const cors = require('cors');
const app = express();

// Enables CORS
app.use(cors());

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

// User-related Endpoints

// Create a new user
app.post('/users', async (req, res) => {
  console.log("[INFO] Running createUser function. Request received to create user with username:", req.body.username);
  try {
    const { username, bioText, profilePicture } = req.body;
    const user = await createUser(username, bioText, profilePicture);
    res.status(201).json(user);
  } catch (error) {
    console.error("[ERROR] Error in createUser:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// Ban a user
app.put('/users/:id/ban', async (req, res) => {
  console.log("[INFO] Running banUser function for user id:", req.params.id);
  try {
    const user = await banUser(req.params.id);
    res.json(user);
  } catch (error) {
    console.error("[ERROR] Error in banUser:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// Warn a user
app.put('/users/:id/warn', async (req, res) => {
  console.log("[INFO] Running warnUser function for user id:", req.params.id);
  try {
    const user = await warnUser(req.params.id);
    res.json(user);
  } catch (error) {
    console.error("[ERROR] Error in warnUser:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// Change bio text for a user
app.put('/users/:id/bio', async (req, res) => {
  console.log("[INFO] Running changeBio function for user id:", req.params.id);
  try {
    const { newBio } = req.body;
    const user = await changeBio(req.params.id, newBio);
    res.json(user);
  } catch (error) {
    console.error("[ERROR] Error in changeBio:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// Change profile picture for a user
app.put('/users/:id/profile-picture', async (req, res) => {
  console.log("[INFO] Running changeProfilePicture function for user id:", req.params.id);
  try {
    const { newProfilePicture } = req.body;
    const user = await changeProfilePicture(req.params.id, newProfilePicture);
    res.json(user);
  } catch (error) {
    console.error("[ERROR] Error in changeProfilePicture:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// Delete a user
app.delete('/users/:id', async (req, res) => {
  console.log("[INFO] Running deleteUser function for user id:", req.params.id);
  try {
    const user = await deleteUser(req.params.id);
    res.json(user);
  } catch (error) {
    console.error("[ERROR] Error in deleteUser:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// Post-related Endpoints

// Create a new post
app.post('/posts', async (req, res) => {
  console.log("[INFO] Running createPost function. Request received from creator id:", req.body.creator);
  try {
    const { creator, postText, postImage, postTags } = req.body;
    
    // Validation to ensure required fields are present
    if (creator === undefined || !postText || !Array.isArray(postTags)) {
      console.error("[ERROR] Validation failed in createPost. Missing required fields.");
      return res.status(400).json({ error: "Missing required fields" });
    }
    
    const post = await createPost(creator, postText, postImage, postTags);
    res.status(201).json(post);
  } catch (error) {
    console.error("[ERROR] Error in createPost:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// Terminate a post
app.put('/posts/:id/terminate', async (req, res) => {
  console.log("[INFO] Running terminatePost function for post id:", req.params.id);
  try {
    const post = await terminatePost(req.params.id);
    res.json(post);
  } catch (error) {
    console.error("[ERROR] Error in terminatePost:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// Delete a post
app.delete('/posts/:id', async (req, res) => {
  console.log("[INFO] Running deletePost function for post id:", req.params.id);
  try {
    const post = await deletePost(req.params.id);
    res.json(post);
  } catch (error) {
    console.error("[ERROR] Error in deletePost:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// Refresh posts
app.get('/posts', async (req, res) => {
  console.log("[INFO] Running getAllPosts function.");
  try {
    const posts = await getAllPosts();
    res.json(posts);
  } catch (error) {
    console.error("[ERROR] Error in getAllPosts:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// Report-related Endpoints

// Report a post
app.post('/reports', async (req, res) => {
  console.log("[INFO] Running reportPost function. Request received for post id:", req.body.postId);
  try {
    const { reportedUser, complaintText, postId, reporterUser } = req.body;
    const report = await reportPost(reportedUser, complaintText, postId, reporterUser);
    res.status(201).json(report);
  } catch (error) {
    console.error("[ERROR] Error in reportPost:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// Dismiss a report
app.delete('/reports/:id', async (req, res) => {
  console.log("[INFO] Running dismissReport function for report id:", req.params.id);
  try {
    const report = await dismissReport(req.params.id);
    res.json(report);
  } catch (error) {
    console.error("[ERROR] Error in dismissReport:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// Start the Server

if (require.main === module) {
  app.listen(port, () => {
    console.log(`Server running on port ${port}`);
  });
}

module.exports = app;