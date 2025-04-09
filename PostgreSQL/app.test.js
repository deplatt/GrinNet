// app.test.js
const request = require('supertest');
const { expect } = require('chai');
const app = require('./app');

describe('API Endpoints', function() {
  let userId, postId, reportId, reporterId;

  describe('User Endpoints', function() {
    it('should create a new user', async function() {
      const res = await request(app)
        .post('/users')
        .send({ username: 'apiTester', bioText: 'Hello API', profilePicture: 'pic.jpg' })
        .expect(201);
      expect(res.body).to.have.property('id');
      expect(res.body.username).to.equal('apiTester');
      userId = res.body.id;
    });

    it('should ban a user', async function() {
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

    it('should warn a user', async function() {
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

    it('should change bio', async function() {
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

    it('should change profile picture', async function() {
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

    it('should delete a user', async function() {
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

  describe('Post Endpoints', function() {
    before(async function() {
      // Create a user to associate with posts
      const res = await request(app)
        .post('/users')
        .send({ username: 'postUser', bioText: '', profilePicture: '' })
        .expect(201);
      userId = res.body.id;
    });
    after(async function() {
      if (userId) {
        await request(app).delete(`/users/${userId}`);
      }
    });

    it('should create a post', async function() {
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

    it('should terminate a post', async function() {
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

    it('should delete a terminated post with no reports', async function() {
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

    it('should not delete a post that has reports', async function() {
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

      await request(app)
        .put(`/posts/${pid}/terminate`)
        .expect(200);

      const delRes = await request(app)
        .delete(`/posts/${pid}`)
        .expect(500);
      expect(delRes.body.error).to.include('Post has reports and cannot be deleted.');
    });
  });

  describe('Report Endpoints', function() {
    before(async function() {
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
      if (postId) await request(app).delete(`/posts/${postId}`);
      if (userId) await request(app).delete(`/users/${userId}`);
      if (reporterId) await request(app).delete(`/users/${reporterId}`);
    });

    it('should report a post and update the user report count', async function() {
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
      // Create a report first
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
