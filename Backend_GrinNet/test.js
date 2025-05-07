/**
 * GrinNet Direct Database Function Tests
 *
 * Integration tests for core database functions in the GrinNet app.
 * Tests cover user management, post creation/termination/deletion,
 * report creation/dismissal, and tag validation.
 *
 * @module test
 */

const { expect } = require('chai');
const db = require('./functions.js');

// Clear database before running all tests
db.clearDatabase();

/* ======================== User Function Tests ======================== */
describe('User Functions', function () {
  beforeEach(async () => {
    await db.clearDatabase(); // Ensure no leftover data
  });

  let user;

  // Clean up any created users after each test
  afterEach(async function () {
    if (user && user.id) {
      try {
        await db.deleteUser(user.id);
      } catch (err) { /* Ignore errors if user already deleted */ }
    }
  });

  /**
   * Test creating a user
   */
  it('should create a user', async function () {
    user = await db.createUser('testuser', 'Test bio', 'profile.jpg');
    expect(user).to.have.property('id');
    expect(user.username).to.equal('testuser');
  });

  /**
   * Test banning a user
   */
  it('should ban a user', async function () {
    user = await db.createUser('banuser');
    const banned = await db.banUser(user.id);
    expect(banned.status).to.equal('banned');
  });

  /**
   * Test warning a user
   */
  it('should warn a user', async function () {
    user = await db.createUser('warnuser');
    const warned = await db.warnUser(user.id);
    expect(warned.status).to.equal('warned');
  });

  /**
   * Test changing a user's biography
   */
  it('should change bio', async function () {
    user = await db.createUser('bioUser', 'Old bio');
    const updated = await db.changeBio(user.id, 'New bio');
    expect(updated.bio_text).to.equal('New bio');
  });

  /**
   * Test updating a user's profile picture
   */
  it('should change profile picture', async function () {
    user = await db.createUser('picUser', '', 'old.jpg');
    const updated = await db.changeProfilePicture(user.id, 'new.jpg');
    expect(updated.profile_picture).to.equal('new.jpg');
  });

  /**
   * Test deleting a user
   */
  it('should delete a user', async function () {
    user = await db.createUser('deleteUser');
    const deleted = await db.deleteUser(user.id);
    expect(deleted.id).to.equal(user.id);
  });
});

/* ======================== Post Function Tests ======================== */
describe('Post Functions', function () {
  let user, post;

  // Create a user before each post test
  beforeEach(async function () {
    user = await db.createUser('postCreator');
  });

  // Clean up after each post test
  afterEach(async function () {
    if (post && post.post_id) {
      try { await db.deletePost(post.post_id); } catch (err) {}
    }
    if (user && user.id) {
      await db.deleteUser(user.id);
    }
  });

  /**
   * Test creating a post with valid tags
   */
  it('should create a post with allowed tags only', async function () {
    post = await db.createPost(user.id, 'Hello world!', 'image.jpg', ['tag1', 'sports', 'MUSIC']);
    expect(post).to.have.property('post_id');
    expect(post.creator).to.equal(user.id);
    expect(post.post_tags).to.deep.equal(['sports', 'music']);
  });

  /**
   * Test terminating a post
   */
  it('should terminate a post', async function () {
    post = await db.createPost(user.id, 'Post to terminate', '', ['misc']);
    const terminated = await db.terminatePost(post.post_id);
    expect(terminated.date_of_termination).to.not.be.null;
  });

  /**
   * Test deleting a terminated post
   */
  it('should delete a terminated post with no reports', async function () {
    post = await db.createPost(user.id, 'Post to delete', '', ['misc']);
    await db.terminatePost(post.post_id);
    const deleted = await db.deletePost(post.post_id);
    expect(deleted.post_id).to.equal(post.post_id);
    post = null;
  });

  /**
   * Test failing to delete a reported post
   */
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

  /* Nested: Get All Posts Tests */
  describe('getAllPosts Function', function () {
    beforeEach(async () => {
      await db.clearDatabase(); // Ensure no leftover data
    });
    
    let user, post1, post2, terminatedPost;

    beforeEach(async function () {
      user = await db.createUser('activePostsUser');
    });

    afterEach(async function () {
      if (post1 && post1.post_id) { try { await db.deletePost(post1.post_id); } catch (err) {} }
      if (post2 && post2.post_id) { try { await db.deletePost(post2.post_id); } catch (err) {} }
      if (terminatedPost && terminatedPost.post_id) { try { await db.deletePost(terminatedPost.post_id); } catch (err) {} }
      if (user && user.id) { await db.deleteUser(user.id); }
    });

    it('should return all active posts with correct properties', async function () {
      post1 = await db.createPost(user.id, 'Active post 1', 'img1.jpg', ['sports', 'misc']);
      post2 = await db.createPost(user.id, 'Active post 2', 'img2.jpg', ['music', 'social']);
      const posts = await db.getAllPosts();
      const activePosts = posts.filter(p => p.post_text === 'Active post 1' || p.post_text === 'Active post 2');
      expect(activePosts.length).to.equal(2);
    });

    it('should not include terminated posts', async function () {
      post1 = await db.createPost(user.id, 'Active post', 'img.jpg', ['misc']);
      terminatedPost = await db.createPost(user.id, 'Terminated post', 'imgTerm.jpg', ['misc']);
      await db.terminatePost(terminatedPost.post_id);
      const posts = await db.getAllPosts();
      const terminatedPostsFound = posts.filter(p => p.post_text === 'Terminated post');
      expect(terminatedPostsFound).to.have.lengthOf(0);
    });

    it('should return posts in descending order', async function () {
      post1 = await db.createPost(user.id, 'First post', 'first.jpg', ['misc']);
      await new Promise(resolve => setTimeout(resolve, 1000));
      post2 = await db.createPost(user.id, 'Second post', 'second.jpg', ['misc']);
      const posts = await db.getAllPosts();
      const [firstPost, secondPost] = posts
        .map(post => ({
          text: post.post_text,
          timestamp: new Date(`${post.creation_date}T${post.creation_time}`)
        }))
        .sort((a, b) => b.timestamp - a.timestamp);
      expect(firstPost.text).to.equal('Second post');
    });
  });
});

describe('Post Cleanup Tests', () => {
  beforeEach(async () => {
    await db.clearDatabase(); // Ensure no leftover data
  });

  it('should delete expired posts after event date + 1 day', async () => {
    const user = await db.createUser('janedoe', 'Bio', '');
    
    const now = new Date();
    const pastEvent = new Date(now.getTime() - 2 * 86400000); // 2 days ago

    // This post is expired
    await db.createPost(user.id, 'Old event', '', ['misc'], pastEvent.toISOString());

    const resultBefore = await require('./functions').query(`SELECT COUNT(*) FROM posts`);
    expect(parseInt(resultBefore.rows[0].count)).to.equal(1);

    await db.cleanupExpiredPosts();

    const resultAfter = await require('./functions').query(`SELECT COUNT(*) FROM posts`);
    expect(parseInt(resultAfter.rows[0].count)).to.equal(0);
  });

  it('should NOT delete reported expired post', async () => {
    const user = await db.createUser('expiredUser');
    const reporter = await db.createUser('repUser');
    const pastEvent = new Date(Date.now() - 2 * 86400000); // 2 days ago
  
    const post = await db.createPost(user.id, 'Reported expired', '', ['misc'], pastEvent.toISOString());
    await db.terminatePost(post.post_id);
    await db.reportPost(user.id, 'Abuse', post.post_id, reporter.id);
  
    await db.cleanupExpiredPosts();
    const result = await db.query('SELECT COUNT(*) FROM posts');
    expect(parseInt(result.rows[0].count)).to.equal(1);
  
    await db.clearDatabase();
  });

  it('should keep future events', async () => {
    const user = await db.createUser('futureGuy');
    const futureEvent = new Date(Date.now() + 86400000); // Tomorrow
  
    await db.createPost(user.id, 'Future event', '', ['misc'], futureEvent.toISOString());
  
    await db.cleanupExpiredPosts();
    const result = await db.query('SELECT COUNT(*) FROM posts');
    expect(parseInt(result.rows[0].count)).to.equal(1);
  
    await db.clearDatabase();
  });
});

/* ======================== Report Function Tests ======================== */
describe('Report Functions', function () {
  beforeEach(async () => {
    await db.clearDatabase(); // Ensure no leftover data
  });
  
  let user, reporter, post, report;

  beforeEach(async function () {
    user = await db.createUser('reportedUser');
    reporter = await db.createUser('reporterUser');
    post = await db.createPost(user.id, 'Offensive post', '', ['misc']);
  });

  afterEach(async function () {
    if (report && report.report_id) { try { await db.dismissReport(report.report_id); } catch (err) {} }
    if (post && post.post_id) { try { await db.deletePost(post.post_id); } catch (err) {} }
    if (user && user.id) { await db.deleteUser(user.id); }
    if (reporter && reporter.id) { await db.deleteUser(reporter.id); }
  });

  /**
   * Test reporting a post
   */
  it('should report a post and update user report count', async function () {
    report = await db.reportPost(user.id, 'Inappropriate content', post.post_id, reporter.id);
    expect(report).to.have.property('report_id');
  });

  /**
   * Test dismissing a report
   */
  it('should dismiss a report', async function () {
    report = await db.reportPost(user.id, 'Spam', post.post_id, reporter.id);
    const dismissed = await db.dismissReport(report.report_id);
    expect(dismissed.report_id).to.equal(report.report_id);
    report = null;
  });
});

/* ======================== Post Tag Validation Tests ======================== */
describe('Post Tag Validation', function () {
  let user, post;

  beforeEach(async function () {
    await db.clearDatabase(); // Ensure no leftover data
    user = await db.createUser('tagTester');
  });

  afterEach(async function () {
    if (post && post.post_id) { try { await db.deletePost(post.post_id); } catch (err) {} }
    if (user && user.id) { await db.deleteUser(user.id); }
  });

  it('should create a post with valid tags', async function () {
    post = await db.createPost(user.id, 'Valid tags', '', ['SOcial', 'MUSIC', 'invalid']);
    expect(post.post_tags).to.deep.equal(['social', 'music']);
  });

  it('should fail to create post if no valid tags', async function () {
    let errorCaught = false;
    try {
      post = await db.createPost(user.id, 'Invalid tags', '', ['random', 'tags']);
    } catch (error) {
      errorCaught = true;
      expect(error.message).to.include('Post must have at least one allowed tag');
    }
    expect(errorCaught).to.be.true;
  });

  it('should fail if empty tag array', async function () {
    let errorCaught = false;
    try {
      post = await db.createPost(user.id, 'No tags', '', []);
    } catch (error) {
      errorCaught = true;
      expect(error.message).to.include('Post must have at least one allowed tag');
    }
    expect(errorCaught).to.be.true;
  });
});
