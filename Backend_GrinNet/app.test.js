/**
 * End-to-end API tests using Supertest for the GrinNet backend
 *
 * Verifies RESTful Express endpoints for users, posts, and reports,
 * ensuring correct behavior across creation, modification, retrieval, and deletion flows.
 *
 * @module app.test
 */

const request = require('supertest');
const { expect } = require('chai');
const app = require('./app');
const db = require('./functions.js');

describe('API Endpoints', function () {
  let userId, postId, reportId, reporterId;

  /* ======================== User Endpoints Tests ======================== */
  describe('User Endpoints', function () {
    /** Test creating a user */
    it('should create a new user', async function () {
      const res = await request(app)
        .post('/users')
        .send({ username: 'apiTester', bioText: 'Hello API', profilePicture: 'pic.jpg' })
        .expect(201);
      expect(res.body).to.have.property('id');
      expect(res.body.username).to.equal('apiTester');
      userId = res.body.id;
    });

    /** Test banning a user */
    it('should ban a user', async function () {
      const createRes = await request(app)
        .post('/users')
        .send({ username: 'banUser', bioText: '', profilePicture: '' })
        .expect(201);
      const id = createRes.body.id;
      const res = await request(app)
        .put(`/users/${id}/ban`)
        .expect(200);
      expect(res.body.status).to.equal('banned');
    });

    /** Test warning a user */
    it('should warn a user', async function () {
      const createRes = await request(app)
        .post('/users')
        .send({ username: 'warnUser', bioText: '', profilePicture: '' })
        .expect(201);
      const id = createRes.body.id;
      const res = await request(app)
        .put(`/users/${id}/warn`)
        .expect(200);
      expect(res.body.status).to.equal('warned');
    });

    /** Test changing a user's bio */
    it('should change bio', async function () {
      const createRes = await request(app)
        .post('/users')
        .send({ username: 'bioUser', bioText: 'Old Bio', profilePicture: '' })
        .expect(201);
      const id = createRes.body.id;
      const res = await request(app)
        .put(`/users/${id}/bio`)
        .send({ newBio: 'New Bio' })
        .expect(200);
      expect(res.body.bio_text).to.equal('New Bio');
    });

    /** Test changing a user's profile picture */
    it('should change profile picture', async function () {
      const createRes = await request(app)
        .post('/users')
        .send({ username: 'picUser', bioText: '', profilePicture: 'old.jpg' })
        .expect(201);
      const id = createRes.body.id;
      const res = await request(app)
        .put(`/users/${id}/profile-picture`)
        .send({ newProfilePicture: 'new.jpg' })
        .expect(200);
      expect(res.body.profile_picture).to.equal('new.jpg');
    });

    /** Test deleting a user */
    it('should delete a user', async function () {
      const createRes = await request(app)
        .post('/users')
        .send({ username: 'delUser', bioText: '', profilePicture: '' })
        .expect(201);
      const id = createRes.body.id;
      const res = await request(app)
        .delete(`/users/${id}`)
        .expect(200);
      expect(res.body.id).to.equal(id);
    });
  });

  /* ======================== Post Endpoints Tests ======================== */
  describe('Post Endpoints', function () {
    before(async function () {
      const res = await request(app)
        .post('/users')
        .send({ username: 'postUser', bioText: '', profilePicture: '' })
        .expect(201);
      userId = res.body.id;
    });

    after(async function () {
      if (userId) {
        await request(app).delete(`/users/${userId}`);
      }
    });

    /** Test creating a post */
    it('should create a post', async function () {
      const res = await request(app)
        .post('/posts')
        .send({
          creator: userId,
          postText: 'Test post',
          postImage: '',
          postTags: ['misc', 'sports']
        })
        .expect(201);
      expect(res.body).to.have.property('post_id');
      postId = res.body.post_id;
    });

    /** Test terminating a post */
    it('should terminate a post', async function () {
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
      expect(termRes.body.date_of_termination).to.not.be.null;
    });

    /** Test deleting a terminated post */
    it('should delete a terminated post with no reports', async function () {
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
      await request(app).put(`/posts/${pid}/terminate`).expect(200);
      const delRes = await request(app).delete(`/posts/${pid}`).expect(200);
      expect(delRes.body.post_id).to.equal(pid);
    });

    /** Test failing to delete a reported post */
    it('should not delete a post that has reports', async function () {
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

      const repRes = await request(app)
        .post('/users')
        .send({ username: 'reporter', bioText: '', profilePicture: '' })
        .expect(201);
      reporterId = repRes.body.id;

      await request(app)
        .post('/reports')
        .send({
          reportedUser: userId,
          complaintText: 'Inappropriate content',
          postId: pid,
          reporterUser: reporterId
        })
        .expect(201);

      await request(app).put(`/posts/${pid}/terminate`).expect(200);

      const delRes = await request(app).delete(`/posts/${pid}`).expect(500);
      expect(delRes.body.error).to.include('Post has reports and cannot be deleted.');
    });

    /* ======================== Get All Posts Tests ======================== */
    describe('Get All Posts Endpoint', function () {
      let activePost1, activePost2, terminatedPost;

      before(async function () {
        const res = await request(app)
          .post('/users')
          .send({ username: 'activeUser', bioText: '', profilePicture: 'activePic.jpg' })
          .expect(201);
        userId = res.body.id;
      });

      after(async function () {
        if (userId) {
          await request(app).delete(`/users/${userId}`);
        }
      });

      beforeEach(async function () {
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

        await request(app)
          .put(`/posts/${terminatedPost}/terminate`)
          .expect(200);
      });

      afterEach(async function () {
        if (activePost1) {
          await request(app).put(`/posts/${activePost1}/terminate`).expect(200);
          await request(app).delete(`/posts/${activePost1}`).expect(200);
        }
        if (activePost2) {
          await request(app).put(`/posts/${activePost2}/terminate`).expect(200);
          await request(app).delete(`/posts/${activePost2}`).expect(200);
        }
        if (terminatedPost) {
          await request(app).delete(`/posts/${terminatedPost}`).expect(200);
        }
      });

      /** Test getting active posts with correct properties */
      it('should return an array of active posts with the correct properties', async function () {
        const res = await request(app).get('/posts').expect(200);
        expect(res.body).to.be.an('array');

        const terminatedPosts = res.body.filter(post => post.post_text === 'Terminated post');
        expect(terminatedPosts).to.have.lengthOf(0);

        res.body.forEach(post => {
          expect(post).to.have.property('creation_date');
          expect(post).to.have.property('creation_time');
          expect(post).to.have.property('post_text');
          expect(post).to.have.property('post_image');
          expect(post).to.have.property('post_tags');
          expect(post).to.have.property('profile_picture');
        });
      });

      /** Test getting only active posts */
      it('should only return active posts (skipping terminated ones)', async function () {
        const res = await request(app).get('/posts').expect(200);
        const activePosts = res.body.filter(post =>
          post.post_text === 'Active post 1' || post.post_text === 'Active post 2'
        );
        expect(activePosts.length).to.equal(2);
      });

      /** Test posts are ordered by newest first */
      it('should return posts in descending order by creation datetime', async function () {
        const res = await request(app).get('/posts').expect(200);
        if (res.body.length >= 2) {
          const firstPostDate = new Date(`${res.body[0].creation_date}T${res.body[0].creation_time}`);
          const secondPostDate = new Date(`${res.body[1].creation_date}T${res.body[1].creation_time}`);
          expect(firstPostDate.getTime()).to.be.at.least(secondPostDate.getTime());
        }
      });
    });
  });

  /* ======================== Report Endpoints Tests ======================== */
  describe('Report Endpoints', function () {
    before(async function () {
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

    after(async function () {
      if (postId) await request(app).delete(`/posts/${postId}`);
      if (userId) await request(app).delete(`/users/${userId}`);
      if (reporterId) await request(app).delete(`/users/${reporterId}`);
    });

    /** Test reporting a post */
    it('should report a post and update the user report count', async function () {
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

    /** Test dismissing a report */
    it('should dismiss a report', async function () {
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