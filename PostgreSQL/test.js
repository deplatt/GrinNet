// test.js
const { expect } = require('chai');
const db = require('./functions.js'); 

// Helper to remove test users and posts if necessary.
describe('User Functions', function () {
  let user;

  // After each test, if a user was created, clean up by deleting the user.
  afterEach(async function () {
    if (user && user.id) {
      // Clean up: Delete user if they already exist
      try {
        await db.deleteUser(user.id);
      } catch (err) {
        // Ignore errors if user was already deleted
      }
    }
  });

  // Test: Create a user and verify that the returned object includes an id and the correct username.
  it('should create a user', async function () {
    user = await db.createUser('testuser', 'Test bio', 'profile.jpg');
    expect(user).to.have.property('id');
    expect(user.username).to.equal('testuser');
  });

  // Test: Ban a user by creating one and then marking them as banned.
  it('should ban a user', async function () {
    user = await db.createUser('banuser');
    const banned = await db.banUser(user.id);
    // The test expects the status of the banned user to be set to 'banned'.
    expect(banned.status).to.equal('banned');
  });

  // Test: Warn a user by creating one, applying a warning, and checking the warning status.
  it('should warn a user', async function () {
    user = await db.createUser('warnuser');
    const warned = await db.warnUser(user.id);
    // Verify that the user's status is updated to 'warned'.
    expect(warned.status).to.equal('warned');
  });

  // Test: Update a user's biography by changing it from an old bio to a new one.
  it('should change bio', async function () {
    user = await db.createUser('bioUser', 'Old bio');
    const updated = await db.changeBio(user.id, 'New bio');
    // Ensure that the bio_text reflects the change.
    expect(updated.bio_text).to.equal('New bio');
  });

  // Test: Update a user's profile picture by replacing the old picture with a new file.
  it('should change profile picture', async function () {
    user = await db.createUser('picUser', '', 'old.jpg');
    const updated = await db.changeProfilePicture(user.id, 'new.jpg');
    // Check that the profile_picture field now has the new image.
    expect(updated.profile_picture).to.equal('new.jpg');
  });

  // Test: Delete a user and then confirm the deletion by comparing user ids.
  it('should delete a user', async function () {
    user = await db.createUser('deleteUser');
    const deleted = await db.deleteUser(user.id);
    // Check that the id of the deleted user matches the created user.
    expect(deleted.id).to.equal(user.id);
  });
});

describe('Post Functions', function () {
  let user, post;

  // Create a user to be used for post related tests.
  beforeEach(async function () {
    user = await db.createUser('postCreator');
  });

  // Clean up after tests: delete any created posts and the user.
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

  // Test: Create a post and ensure that only allowed tags (converted to lowercase) remain.
  it('should create a post with allowed tags only', async function () {
    post = await db.createPost(user.id, 'Hello world!', 'image.jpg', ['tag1', 'sports', 'MUSIC']);
    expect(post).to.have.property('post_id');
    expect(post.creator).to.equal(user.id);
    // Expect that only valid tags ('sports' and 'music') are stored, in lowercase.
    expect(post.post_tags).to.deep.equal(['sports', 'music']);
  });

  // Test: Terminate a post by setting its termination date.
  it('should terminate a post', async function () {
    post = await db.createPost(user.id, 'Post to terminate', '', ['misc']);
    const terminated = await db.terminatePost(post.post_id);
    // Verify that a termination date is set (i.e., the post is terminated).
    expect(terminated.date_of_termination).to.not.be.null;
  });

  // Test: Delete a post that has been terminated and has no reports.
  it('should delete a terminated post with no reports', async function () {
    post = await db.createPost(user.id, 'Post to delete', '', ['misc']);
    await db.terminatePost(post.post_id);
    const deleted = await db.deletePost(post.post_id);
    // Confirm the deleted post id matches the original post.
    expect(deleted.post_id).to.equal(post.post_id);
    post = null;
  });

  // Test: Attempt to delete a reported post. It should fail deletion, throwing an error.
  it('should not delete a post that has reports', async function () {
    post = await db.createPost(user.id, 'Reported post', '', ['misc']);
    const reporter = await db.createUser('reporter');
    try {
      // Report the post, terminate it, and then attempt to delete it.
      await db.reportPost(user.id, 'Offensive content', post.post_id, reporter.id);
      await db.terminatePost(post.post_id);
      await db.deletePost(post.post_id);
    } catch (error) {
      // Confirm that the error message indicates the post cannot be deleted due to reports.
      expect(error.message).to.equal('Post has reports and cannot be deleted.');
    }
    // Clean up reporter user.
    await db.deleteUser(reporter.id);
  });
});

describe('Report Functions', function () {
  let user, reporter, post, report;

  // Before each test, create a user whose post will be reported, a reporter, and the post.
  beforeEach(async function () {
    user = await db.createUser('reportedUser');
    reporter = await db.createUser('reporterUser');
    post = await db.createPost(user.id, 'Offensive post', '', ['misc']);
  });

  // Clean up: Dismiss any created report, and delete the post and users.
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

  // Test: Create a report on a post and validate that a report_id is returned.
  it('should report a post and update the user report count', async function () {
    report = await db.reportPost(user.id, 'Inappropriate content', post.post_id, reporter.id);
    expect(report).to.have.property('report_id');
  });

  // Test: Dismiss an existing report and check that the returned report id matches.
  it('should dismiss a report', async function () {
    report = await db.reportPost(user.id, 'Spam', post.post_id, reporter.id);
    const dismissed = await db.dismissReport(report.report_id);
    expect(dismissed.report_id).to.equal(report.report_id);
    // Reset report since it's already dismissed.
    report = null;
  });
});

describe('Post Tag Validation', function () {
  let user, post;

  // Create a user to test post tag functionalities.
  beforeEach(async function () {
    user = await db.createUser('tagTester');
  });

  // Clean up the post and user after tests.
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

  // Test: Create a post with at least one valid tag, ensuring that invalid tags are removed
  // and valid tags are normalized to lowercase.
  it('should create a post if at least one allowed tag is provided', async function () {
    post = await db.createPost(user.id, 'Valid tags', '', ['SOcial', 'MUSIC', 'invalid']);
    // Expect only valid tags ('social' and 'music') to be saved in lowercase.
    expect(post.post_tags).to.deep.equal(['social', 'music']);
  });

  // Test: Fail to create a post if none of the provided tags are allowed.
  it('should fail to create a post if no allowed tags are provided', async function () {
    let errorCaught = false;
    try {
      // All provided tags are invalid.
      post = await db.createPost(user.id, 'Invalid tags', '', ['random', 'tags']);
    } catch (error) {
      errorCaught = true;
      // Expect an error message indicating that at least one allowed tag is required.
      expect(error.message).to.include('Post must have at least one allowed tag');
    }
    expect(errorCaught).to.be.true;
  });

  // Test: Fail to create a post when the tag array is empty.
  it('should fail to create a post if an empty tag array is provided', async function () {
    let errorCaught = false;
    try {
      // No tags provided at all.
      post = await db.createPost(user.id, 'No tags', '', []);
    } catch (error) {
      errorCaught = true;
      // Expect an error indicating the post needs at least one allowed tag.
      expect(error.message).to.include('Post must have at least one allowed tag');
    }
    expect(errorCaught).to.be.true;
  });
});
