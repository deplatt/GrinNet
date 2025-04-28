/**
 * GrinNet Data Population Script
 *
 * This script populates the GrinNet app with initial users, posts, and reports for testing purposes.
 * It uploads images to the local image server, creates users with those images,
 * creates posts associated with users, and submits a sample report.
 *
 * @module populate_data
 */

const axios = require('axios');
const FormData = require('form-data');
const fs = require('fs');
const path = require('path');

// Configurable constants
const IMAGE_UPLOAD_API = 'http://localhost:4000/upload';
const BASE_API = 'http://localhost:3000';
const TEST_IMAGE_DIR = path.join(__dirname, 'test_assets');
const UPLOAD_PATH_PREFIX = 'uploads/';

// Predefined test users
const USERS = [
  { username: 'alice', bio: 'Music lover', profilePicture: 'profile1.jpg' },
  { username: 'bob', bio: 'Foodie', profilePicture: 'profile2.jpg' },
  { username: 'charlie', bio: 'Event host', profilePicture: 'profile3.jpg' }
];

// Predefined test posts
const POSTS = [
  {
    postText: 'Karaoke night ........',
    postImage: 'event1.jpg',
    postTags: ['music', 'social'],
    eventDate: new Date(Date.now() + 3 * 86400000) // 3 days from now
  },
  {
    postText: 'I made all this food. Just for you..',
    postImage: 'event2.jpg',
    postTags: ['food', 'culture'],
    eventDate: new Date(Date.now() + 5 * 86400000) // 5 days from now
  }
];

/**
 * Upload an image to the Image Upload Server
 *
 * @param {string} filename - The filename to upload from test_assets
 * @returns {Promise<string>} The stored filename on the server
 */
async function uploadImage(filename) {
  const filePath = path.join(TEST_IMAGE_DIR, filename);
  const form = new FormData();
  form.append('image', fs.createReadStream(filePath));

  const response = await axios.post(IMAGE_UPLOAD_API, form, {
    headers: form.getHeaders()
  });

  return response.data.filename;
}

/**
 * Main function to populate the database
 *
 * Uploads images, creates users, posts, and submits a sample report.
 */
async function main() {
  try {
    console.log('[Clearing old data]');
    await axios.post(`${BASE_API}/clear`);

    const createdUsers = [];

    // Create users
    for (const user of USERS) {
      const profilePicFilename = await uploadImage(user.profilePicture);

      const response = await axios.post(`${BASE_API}/users`, {
        username: user.username,
        bioText: user.bio,
        profilePicture: UPLOAD_PATH_PREFIX + profilePicFilename
      });

      console.log(`[User Created] ${user.username}`);
      createdUsers.push(response.data);
    }

    const createdPostIds = [];

    // Create posts
    for (let i = 0; i < POSTS.length; i++) {
      const post = POSTS[i];
      const postImageFilename = await uploadImage(post.postImage);

      const response = await axios.post(`${BASE_API}/posts`, {
        creator: createdUsers[i].id,
        postText: post.postText,
        postImage: UPLOAD_PATH_PREFIX + postImageFilename,
        postTags: post.postTags,
        eventDate: post.eventDate.toISOString()
      });

      console.log(`[Post Created] ${post.postText}`);
      createdPostIds.push(response.data.post_id);
    }

    // Submit one report
    await axios.post(`${BASE_API}/reports`, {
      reportedUser: createdUsers[0].id,
      complaintText: 'Spammy post',
      postId: createdPostIds[0],
      reporterUser: createdUsers[2].id
    });

    console.log(`[Report Submitted]`);
  } catch (err) {
    console.error('Error populating data:', err.response?.data || err.message);
  }
}

// Execute script
main();
