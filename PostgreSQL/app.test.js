// app.test.js
const request = require('supertest');
const { expect } = require('chai');
const app = require('./app');
const db = require('./functions.js'); 

db.clearDatabase();

describe('API Endpoints', function() {
  let userId, postId, reportId, reporterId;

  // Testing all endpoints related to users
  describe('User Endpoints', function() {
    it('should create a new user', async function() {
      // Test that a POST to /users creates a new user with provided properties
      const res = await request(app)
        .post('/users')
        .send({ username: 'apiTester', bioText: 'Hello API', profilePicture: 'pic.jpg' })
        .expect(201);
      // Verify the response contains a user id and that the username matches the input
      expect(res.body).to.have.property('id');
      expect(res.body.username).to.equal('apiTester');
      userId = res.body.id;
    });

    it('should ban a user', async function() {
      // Test that a user can be banned: first create a user, then ban them
      const createRes = await request(app)
        .post('/users')
        .send({ username: 'banUser', bioText: '', profilePicture: '' })
        .expect(201);
      const id = createRes.body.id;
      const res = await request(app)
        .put(`/users/${id}/ban`)
        .expect(200);
      // Verify that the response indicates the user status has been updated to "banned"
      expect(res.body.status).to.equal('banned');
    });

    it('should warn a user', async function() {
      // Test that a user can be warned: create a user and then send a warning request for that user
      const createRes = await request(app)
        .post('/users')
        .send({ username: 'warnUser', bioText: '', profilePicture: '' })
        .expect(201);
      const id = createRes.body.id;
      const res = await request(app)
        .put(`/users/${id}/warn`)
        .expect(200);
      // Verify that the response indicates the user status has been updated to "warned"
      expect(res.body.status).to.equal('warned');
    });

    it('should change bio', async function() {
      // Test that a user's bio can be updated: create a user with an old bio, then update it
      const createRes = await request(app)
        .post('/users')
        .send({ username: 'bioUser', bioText: 'Old Bio', profilePicture: '' })
        .expect(201);
      const id = createRes.body.id;
      const res = await request(app)
        .put(`/users/${id}/bio`)
        .send({ newBio: 'New Bio' })
        .expect(200);
      // Verify that the bio_text in the response equals the new bio text
      expect(res.body.bio_text).to.equal('New Bio');
    });

    it('should change profile picture', async function() {
      // Test that a user's profile picture can be updated: create a user with an old profile picture, then update it
      const createRes = await request(app)
        .post('/users')
        .send({ username: 'picUser', bioText: '', profilePicture: 'old.jpg' })
        .expect(201);
      const id = createRes.body.id;
      const res = await request(app)
        .put(`/users/${id}/profile-picture`)
        .send({ newProfilePicture: 'new.jpg' })
        .expect(200);
      // Verify the response now reflects the new profile picture
      expect(res.body.profile_picture).to.equal('new.jpg');
    });

    it('should delete a user', async function() {
      // Test the deletion of a user: create a user first, then delete that user
      const createRes = await request(app)
        .post('/users')
        .send({ username: 'delUser', bioText: '', profilePicture: '' })
        .expect(201);
      const id = createRes.body.id;
      const res = await request(app)
        .delete(`/users/${id}`)
        .expect(200);
      // Verify that the deleted user's id in the response matches the created user's id
      expect(res.body.id).to.equal(id);
    });
  });

  // Testing all endpoints related to posts
  describe('Post Endpoints', function() {
    before(async function() {
      // Setup: Create a user to be associated with the posts that will be created in the tests
      const res = await request(app)
        .post('/users')
        .send({ username: 'postUser', bioText: '', profilePicture: '' })
        .expect(201);
      userId = res.body.id;
    });
    after(async function() {
      // Cleanup: Delete the test user if it exists
      if (userId) {
        await request(app).delete(`/users/${userId}`);
      }
    });

    it('should create a post', async function() {
      // Test creating a new post associated with a user with required fields
      const res = await request(app)
        .post('/posts')
        .send({
          creator: userId,
          postText: 'Test post',
          postImage: '',
          postTags: ['misc', 'sports']
        })
        .expect(201);
      // Verify that the response contains a post_id
      expect(res.body).to.have.property('post_id');
      postId = res.body.post_id;
    });

    it('should terminate a post', async function() {
      // Test the termination process: create a post and then mark it as terminated
      const createRes = await request(app)
        .post('/posts')
        .send({
          creator: userId,
          postText: 'Post to terminate',
          postImage: '',
          postTags: ['misc']
        })
        .expect(201);
      const pid = createRes.body.post_id;
      const termRes = await request(app)
        .put(`/posts/${pid}/terminate`)
        .expect(200);
      // Verify that the termination date is set (indicating the post is terminated)
      expect(termRes.body.date_of_termination).to.not.be.null;
    });

    it('should delete a terminated post with no reports', async function() {
      // Test that a terminated post that does not have any associated reports can be deleted
      const createRes = await request(app)
        .post('/posts')
        .send({
          creator: userId,
          postText: 'Post to delete',
          postImage: '',
          postTags: ['misc']
        })
        .expect(201);
      const pid = createRes.body.post_id;
      // First, terminate the post
      await request(app).put(`/posts/${pid}/terminate`).expect(200);
      // Then, delete the terminated post and verify the post_id in the response
      const delRes = await request(app).delete(`/posts/${pid}`).expect(200);
      expect(delRes.body.post_id).to.equal(pid);
    });

    it('should not delete a post that has reports', async function() {
      // Test that a post which has been reported cannot be deleted
      // Step 1: Create a post
      const createRes = await request(app)
        .post('/posts')
        .send({
          creator: userId,
          postText: 'Post with report',
          postImage: '',
          postTags: ['misc']
        })
        .expect(201);
      const pid = createRes.body.post_id;

      // Step 2: Create a reporter user who will report the post
      const repRes = await request(app)
        .post('/users')
        .send({ username: 'reporter', bioText: '', profilePicture: '' })
        .expect(201);
      reporterId = repRes.body.id;

      // Step 3: Submit a report against the post
      await request(app)
        .post('/reports')
        .send({
          reportedUser: userId,
          complaintText: 'Inappropriate content',
          postId: pid,
          reporterUser: reporterId
        })
        .expect(201);

      // Step 4: Terminate the post
      await request(app)
        .put(`/posts/${pid}/terminate`)
        .expect(200);

      // Step 5: Attempt to delete the post, which should fail
      const delRes = await request(app)
        .delete(`/posts/${pid}`)
        .expect(500);
      // Verify that the error message indicates the post cannot be deleted due to reports
      expect(delRes.body.error).to.include('Post has reports and cannot be deleted.');
    });

    describe('Get All Posts Endpoint', function() {
      let userId;
      let activePost1, activePost2, terminatedPost;

      // Setup a user before running tests for posts
      before(async function() {
        const res = await request(app)
          .post('/users')
          .send({ username: 'activeUser', bioText: '', profilePicture: 'activePic.jpg' })
          .expect(201);
        userId = res.body.id;
      });

      // Clean up the test user after all tests complete
      after(async function() {
        if (userId) {
          await request(app)
            .delete(`/users/${userId}`)
            .expect(200);
        }
      });

      // Before each test, create two active posts and one that will be terminated
      beforeEach(async function() {
        // Create first active post
        let res = await request(app)
          .post('/posts')
          .send({
            creator: userId,
            postText: 'Active post 1',
            postImage: 'image1.jpg',
            postTags: ['sports', 'misc']
          })
          .expect(201);
        activePost1 = res.body.post_id;

        // Create second active post
        res = await request(app)
          .post('/posts')
          .send({
            creator: userId,
            postText: 'Active post 2',
            postImage: 'image2.jpg',
            postTags: ['music', 'social']
          })
          .expect(201);
        activePost2 = res.body.post_id;

        // Create a post that will be terminated
        res = await request(app)
          .post('/posts')
          .send({
            creator: userId,
            postText: 'Terminated post',
            postImage: 'image3.jpg',
            postTags: ['misc']
          })
          .expect(201);
        terminatedPost = res.body.post_id;

        // Terminate the third post to remove it from active posts list
        await request(app)
          .put(`/posts/${terminatedPost}/terminate`)
          .expect(200);
      });

      // After each test, clean up any created posts.
      afterEach(async function() {
        // Terminate and delete active posts (the delete endpoint only works on terminated posts)
        if (activePost1) {
          await request(app).put(`/posts/${activePost1}/terminate`).expect(200);
          await request(app).delete(`/posts/${activePost1}`).expect(200);
        }
        if (activePost2) {
          await request(app).put(`/posts/${activePost2}/terminate`).expect(200);
          await request(app).delete(`/posts/${activePost2}`).expect(200);
        }
        if (terminatedPost) {
          // The terminated post is already terminated, so delete it
          await request(app).delete(`/posts/${terminatedPost}`).expect(200);
        }
      });

      it('should return an array of active posts with the correct properties', async function() {
        const res = await request(app)
          .get('/posts')
          .expect(200);
        // Verify the response is an array
        expect(res.body).to.be.an('array');

        // The terminated post should not appear in the active posts
        const terminatedPosts = res.body.filter(post => post.post_text === 'Terminated post');
        expect(terminatedPosts).to.have.lengthOf(0);

        // Ensure each active post has the required properties
        res.body.forEach(post => {
          expect(post).to.have.property('creation_date');
          expect(post).to.have.property('creation_time');
          expect(post).to.have.property('post_text');
          expect(post).to.have.property('post_image');
          expect(post).to.have.property('post_tags');
          expect(post).to.have.property('profile_picture');
        });
      });

      it('should only return active posts (skipping terminated ones)', async function() {
        const res = await request(app)
          .get('/posts')
          .expect(200);
        // Active posts created in this test have texts "Active post 1" and "Active post 2".
        // Neither of these should be in a terminated state.
        const activePosts = res.body.filter(post =>
          post.post_text === 'Active post 1' || post.post_text === 'Active post 2'
        );
        expect(activePosts.length).to.equal(2);
      });

      it('should return posts in descending order by creation datetime', async function() {
        const res = await request(app)
          .get('/posts')
          .expect(200);
        if (res.body.length >= 2) {
          // Convert the returned creation_date and creation_time into JavaScript Date objects
          const firstPostDate = new Date(`${res.body[0].creation_date}T${res.body[0].creation_time}`);
          const secondPostDate = new Date(`${res.body[1].creation_date}T${res.body[1].creation_time}`);
          // The first post should be at least as recent as the second post
          expect(firstPostDate.getTime()).to.be.at.least(secondPostDate.getTime());
        }
      });
    });

  });

  // Testing all endpoints related to reports
  describe('Report Endpoints', function() {
    before(async function() {
      // Setup: Create a reported user, a reporter user, and a post that will be reported
      let res = await request(app)
        .post('/users')
        .send({ username: 'reportedUser', bioText: '', profilePicture: '' })
        .expect(201);
      userId = res.body.id;
      res = await request(app)
        .post('/users')
        .send({ username: 'reporterUser', bioText: '', profilePicture: '' })
        .expect(201);
      reporterId = res.body.id;
      res = await request(app)
        .post('/posts')
        .send({ creator: userId, postText: 'Offensive post', postImage: '', postTags: ['misc'] })
        .expect(201);
      postId = res.body.post_id;
    });
    after(async function() {
      // Cleanup all test data: delete the created post and both users
      if (postId) await request(app).delete(`/posts/${postId}`);
      if (userId) await request(app).delete(`/users/${userId}`);
      if (reporterId) await request(app).delete(`/users/${reporterId}`);
    });

    it('should report a post and update the user report count', async function() {
      // Test the creation of a report for a post:
      // Submit a report and verify that the response contains the report id
      const res = await request(app)
        .post('/reports')
        .send({
          reportedUser: userId,
          complaintText: 'Spam',
          postId: postId,
          reporterUser: reporterId
        })
        .expect(201);
      reportId = res.body.report_id;
      expect(res.body).to.have.property('report_id');
    });

    it('should dismiss a report', async function() {
      // Test dismissing (or deleting) a report:
      // Create a report, then delete the report and check the response to ensure the correct report was dismissed
      const repRes = await request(app)
        .post('/reports')
        .send({
          reportedUser: userId,
          complaintText: 'Offensive',
          postId: postId,
          reporterUser: reporterId
        })
        .expect(201);
      reportId = repRes.body.report_id;
      const res = await request(app)
        .delete(`/reports/${reportId}`)
        .expect(200);
      expect(res.body.report_id).to.equal(reportId);
    });
  });
});
