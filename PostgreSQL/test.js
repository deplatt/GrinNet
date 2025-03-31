// test.js
const db = require('./functions.js');

async function runTests() {
  try {
    console.log('--- Starting Tests ---');

    // 1. Create a user
    console.log('\nCreating user "alice"...');
    let userAlice = await db.createUser("alice", "password123", "Hello, I am Alice", "http://example.com/alice.jpg");
    console.log("Created:", userAlice);

    console.log('\nCreating user "bob"...');
    let userBob = await db.createUser("bob", "securepass", "Hi, I'm Bob", "http://example.com/bob.jpg");
    console.log("Created:", userBob);

    // 2. Change Alice's bio and profile picture
    console.log('\nChanging Alice\'s bio...');
    let updatedAliceBio = await db.changeBio(userAlice.id, "Updated bio for Alice");
    console.log("Updated Alice bio:", updatedAliceBio);

    console.log('\nChanging Alice\'s profile picture...');
    let updatedAlicePic = await db.changeProfilePicture(userAlice.id, "http://example.com/alice-new.jpg");
    console.log("Updated Alice profile picture:", updatedAlicePic);

    // 3. Change Alice's password and verify it
    console.log('\nChanging Alice\'s password...');
    let updatedAlicePassword = await db.changePassword(userAlice.id, "newpassword456");
    console.log("Password changed for Alice:", updatedAlicePassword);

    console.log('\nVerifying Alice\'s new password...');
    let isPasswordCorrect = await db.checkPassword("alice", "newpassword456");
    console.log("Password verification result:", isPasswordCorrect);

    // 4. Create a post by Alice
    console.log('\nAlice creates a post...');
    let post = await db.createPost(userAlice.id, "This is a post by Alice", "http://example.com/post1.jpg", ["tag1", "tag2"]);
    console.log("Created post:", post);

    // 5. Terminate Alice's post
    console.log('\nTerminating Alice\'s post...');
    let terminatedPost = await db.terminatePost(post.post_id);
    console.log("Terminated post:", terminatedPost);

    // 6. Bob reports Alice's post
    console.log('\nBob reports Alice\'s post...');
    let report = await db.reportPost(userAlice.id, "Inappropriate content", post.post_id, userBob.id);
    console.log("Created report:", report);

    // 7. Dismiss the report
    console.log('\nDismissing the report...');
    let dismissedReport = await db.dismissReport(report.report_id);
    console.log("Dismissed report:", dismissedReport);

    // 8. Ban Alice and then warn her (to simulate status changes)
    console.log('\nBanning Alice...');
    let bannedAlice = await db.banUser(userAlice.id);
    console.log("Banned user:", bannedAlice);

    console.log('\nWarning Alice (status change)...');
    let warnedAlice = await db.warnUser(userAlice.id);
    console.log("Warned user:", warnedAlice);

    // 9. Delete Bob
    console.log('\nDeleting user Bob...');
    let deletedBob = await db.deleteUser(userBob.id);
    console.log("Deleted user Bob:", deletedBob);

    // 10. Finally, delete Alice as cleanup
    console.log('\nDeleting user Alice...');
    let deletedAlice = await db.deleteUser(userAlice.id);
    console.log("Deleted user Alice:", deletedAlice);

    console.log('\n--- Tests Completed ---');
  } catch (err) {
    console.error('Test error:', err);
  } finally {
    process.exit();
  }
}

runTests();
