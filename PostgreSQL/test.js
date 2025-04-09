// test.js
const { expect } = require('chai');
const db = require('./functions.js'); 

describe('User Functions', function () {
  let user;

  afterEach(async function () {
    if (user && user.id) {
      try {
        await db.deleteUser(user.id);
      } catch (err) {
        // Ignore errors if user was already deleted
      }
    }
  });

  it('should create a user', async function () {
    user = await db.createUser('testuser', 'Test bio', 'profile.jpg');
    expect(user).to.have.property('id');
    expect(user.username).to.equal('testuser');
  });

  it('should ban a user', async function () {
    user = await db.createUser('banuser');
    const banned = await db.banUser(user.id);
    expect(banned.status).to.equal('banned');
  });

  it('should warn a user', async function () {
    user = await db.createUser('warnuser');
    const warned = await db.warnUser(user.id);
    expect(warned.status).to.equal('warned');
  });

  it('should change bio', async function () {
    user = await db.createUser('bioUser', 'Old bio');
    const updated = await db.changeBio(user.id, 'New bio');
    expect(updated.bio_text).to.equal('New bio');
  });

  it('should change profile picture', async function () {
    user = await db.createUser('picUser', '', 'old.jpg');
    const updated = await db.changeProfilePicture(user.id, 'new.jpg');
    expect(updated.profile_picture).to.equal('new.jpg');
  });

  it('should delete a user', async function () {
    user = await db.createUser('deleteUser');
    const deleted = await db.deleteUser(user.id);
    expect(deleted.id).to.equal(user.id);
  });
});

describe('Post Functions', function () {
  let user, post;

  beforeEach(async function () {
    user = await db.createUser('postCreator');
  });

  afterEach(async function () {
    if (post && post.post_id) {
      try {
        await db.deletePost(post.post_id);
      } catch (err) {
        // Ignore errors if the post cannot be deleted
      }
    }
    if (user && user.id) {
      await db.deleteUser(user.id);
    }
  });

  it('should create a post with allowed tags only', async function () {
    post = await db.createPost(user.id, 'Hello world!', 'image.jpg', ['tag1', 'sports', 'MUSIC']);
    expect(post).to.have.property('post_id');
    expect(post.creator).to.equal(user.id);
    // Only allowed tags (in lowercase) should remain: 'sports' and 'music'
    expect(post.post_tags).to.deep.equal(['sports', 'music']);
  });

  it('should terminate a post', async function () {
    post = await db.createPost(user.id, 'Post to terminate', '', ['misc']);
    const terminated = await db.terminatePost(post.post_id);
    expect(terminated.date_of_termination).to.not.be.null;
  });

  it('should delete a terminated post with no reports', async function () {
    post = await db.createPost(user.id, 'Post to delete', '', ['misc']);
    await db.terminatePost(post.post_id);
    const deleted = await db.deletePost(post.post_id);
    expect(deleted.post_id).to.equal(post.post_id);
    post = null;
  });

  it('should not delete a post that has reports', async function () {
    post = await db.createPost(user.id, 'Reported post', '', ['misc']);
    const reporter = await db.createUser('reporter');
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
    user = await db.createUser('reportedUser');
    reporter = await db.createUser('reporterUser');
    post = await db.createPost(user.id, 'Offensive post', '', ['misc']);
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
    report = null;
  });
});

describe('Post Tag Validation', function () {
  let user, post;

  beforeEach(async function () {
    user = await db.createUser('tagTester');
  });

  afterEach(async function () {
    if (post && post.post_id) {
      try {
        await db.deletePost(post.post_id);
      } catch (err) {
        // ignore
      }
    }
    if (user && user.id) {
      await db.deleteUser(user.id);
    }
  });

  it('should create a post if at least one allowed tag is provided', async function () {
    // This should succeed and store only the valid tags in lower-case.
    post = await db.createPost(user.id, 'Valid tags', '', ['SOcial', 'MUSIC', 'invalid']);
    expect(post.post_tags).to.deep.equal(['social', 'music']);
  });

  it('should fail to create a post if no allowed tags are provided', async function () {
    let errorCaught = false;
    try {
      // None of these tags are valid.
      post = await db.createPost(user.id, 'Invalid tags', '', ['random', 'tags']);
    } catch (error) {
      errorCaught = true;
      expect(error.message).to.include('Post must have at least one allowed tag');
    }
    expect(errorCaught).to.be.true;
  });

  it('should fail to create a post if an empty tag array is provided', async function () {
    let errorCaught = false;
    try {
      // No tags provided.
      post = await db.createPost(user.id, 'No tags', '', []);
    } catch (error) {
      errorCaught = true;
      expect(error.message).to.include('Post must have at least one allowed tag');
    }
    expect(errorCaught).to.be.true;
  });
});
