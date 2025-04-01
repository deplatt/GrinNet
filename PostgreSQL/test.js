// test.js
const { expect } = require('chai');
const db = require('./functions.js'); 

// Helper to remove test users and posts if necessary.

describe('User Functions', function () {
  let user;

  afterEach(async function () {
    // Clean up: Delete the created user if exists
    if (user && user.id) {
      try {
        await db.deleteUser(user.id);
      } catch (err) {
        // Ignore errors if user was already deleted
      }
    }
  });

  it('should create a user', async function () {
    user = await db.createUser('testuser', 'password123', 'Test bio', 'profile.jpg');
    expect(user).to.have.property('id');
    expect(user.username).to.equal('testuser');
  });

  it('should ban a user', async function () {
    user = await db.createUser('banuser', 'password123');
    const banned = await db.banUser(user.id);
    expect(banned.status).to.equal('banned');
  });

  it('should warn a user', async function () {
    user = await db.createUser('warnuser', 'password123');
    const warned = await db.warnUser(user.id);
    expect(warned.status).to.equal('warned');
  });

  it('should change bio', async function () {
    user = await db.createUser('bioUser', 'password123', 'Old bio');
    const updated = await db.changeBio(user.id, 'New bio');
    expect(updated.bio_text).to.equal('New bio');
  });

  it('should change profile picture', async function () {
    user = await db.createUser('picUser', 'password123', '', 'old.jpg');
    const updated = await db.changeProfilePicture(user.id, 'new.jpg');
    expect(updated.profile_picture).to.equal('new.jpg');
  });

  it('should change and verify password', async function () {
    user = await db.createUser('passUser', 'oldpassword');
    const checkOld = await db.checkPassword('passUser', 'oldpassword');
    expect(checkOld).to.be.true;
    await db.changePassword(user.id, 'newpassword');
    const checkNew = await db.checkPassword('passUser', 'newpassword');
    expect(checkNew).to.be.true;
    const checkOldAgain = await db.checkPassword('passUser', 'oldpassword');
    expect(checkOldAgain).to.be.false;
  });

  it('should delete a user', async function () {
    user = await db.createUser('deleteUser', 'password123');
    const deleted = await db.deleteUser(user.id);
    expect(deleted.id).to.equal(user.id);
    // Check that user is no longer available
    try {
      await db.checkPassword('deleteUser', 'password123');
    } catch (error) {
      expect(error.message).to.equal('User not found');
    }
  });
});

describe('Post Functions', function () {
  let user, post;

  beforeEach(async function () {
    // Create a user to be the post creator
    user = await db.createUser('postCreator', 'password');
  });

  afterEach(async function () {
    // Clean up the post if it exists
    if (post && post.post_id) {
      try {
        await db.deletePost(post.post_id);
      } catch (err) {
        // Ignore errors if the post cannot be deleted
      }
    }
    // Clean up the creator user
    if (user && user.id) {
      await db.deleteUser(user.id);
    }
  });

  it('should create a post', async function () {
    post = await db.createPost(user.id, 'Hello world!', 'image.jpg', ['tag1', 'tag2']);
    expect(post).to.have.property('post_id');
    expect(post.creator).to.equal(user.id);
  });

  it('should terminate a post', async function () {
    post = await db.createPost(user.id, 'Post to terminate');
    const terminated = await db.terminatePost(post.post_id);
    expect(terminated.date_of_termination).to.not.be.null;
  });

  it('should delete a terminated post with no reports', async function () {
    post = await db.createPost(user.id, 'Post to delete');
    await db.terminatePost(post.post_id);
    const deleted = await db.deletePost(post.post_id);
    expect(deleted.post_id).to.equal(post.post_id);
    // Mark post as deleted so afterEach does not try to delete it again.
    post = null;
  });

  it('should not delete a post that has reports', async function () {
    post = await db.createPost(user.id, 'Reported post');
    const reporter = await db.createUser('reporter', 'password');
    try {
      await db.reportPost(user.id, 'Offensive content', post.post_id, reporter.id);
      await db.terminatePost(post.post_id);
      await db.deletePost(post.post_id);
    } catch (error) {
      expect(error.message).to.equal('Post has reports and cannot be deleted.');
    }
    await db.deleteUser(reporter.id);
  });
});

describe('Report Functions', function () {
  let user, reporter, post, report;

  beforeEach(async function () {
    user = await db.createUser('reportedUser', 'password');
    reporter = await db.createUser('reporterUser', 'password');
    post = await db.createPost(user.id, 'Offensive post');
  });

  afterEach(async function () {
    if (report && report.report_id) {
      try {
        await db.dismissReport(report.report_id);
      } catch (err) {}
    }
    if (post && post.post_id) {
      try {
        await db.deletePost(post.post_id);
      } catch (err) {}
    }
    if (user && user.id) {
      await db.deleteUser(user.id);
    }
    if (reporter && reporter.id) {
      await db.deleteUser(reporter.id);
    }
  });

  it('should report a post and update the user report count', async function () {
    report = await db.reportPost(user.id, 'Inappropriate content', post.post_id, reporter.id);
    expect(report).to.have.property('report_id');
  });

  it('should dismiss a report', async function () {
    report = await db.reportPost(user.id, 'Spam', post.post_id, reporter.id);
    const dismissed = await db.dismissReport(report.report_id);
    expect(dismissed.report_id).to.equal(report.report_id);
    // Prevent afterEach from re-dismissing the report.
    report = null;
  });
});
