// test/setup.js
const db = require('./functions.js');

// Clear database before running all tests
before(async () => {
  await db.clearDatabase();
});

// Clear database after running all tests. Then, close the connection to the database
after(async () => {
  db.clearDatabase();
  await db.pool.end(); // Only run once after all tests
});

// Exit tests once everything is done
after(() => {
  setTimeout(() => {
    console.log("Exiting test runner...");
    process.exit(0);
  }, 500); // allow mocha time to flush output
});