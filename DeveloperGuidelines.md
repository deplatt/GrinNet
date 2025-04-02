### Coding Guidelines

For this project, we will expect any Dart code to be formatted accoring to the following style guide: \
https://dart.dev/effective-dart/style

This guide was chosen because it is the style guide on the offical Dart reference pages, so it is likely to result in the most transferable and standardized code. Dart also provides a command
```dart format``` which will automatically format dart code. 

For SQL, we will use the following guide: \
https://www.sqlstyle.guide/

This guide was chosen because it is comprehensive and provides good rationale.

To enforce proper style, team members are expected to bring any issues to the team's attention and judicously use ```dart format``` (in the case of dart code).

For JavaScript, we will use this guide: \
https://google.github.io/styleguide/jsguide.html

This guide was published by Google and as such is recognized as an industry standard. It is also very comprehensive.

---

### Testing and CI

## Flutter testing:

## Node.js testing:

1. **Locate the Test Directory:**
   - All node.js tests are located in the `GrinNet/PostgreSQL` directory. This is where you'll add or update your test files. All test files in this directory are ran every CI trigger.

2. **Create or Update a Test File:**
   - If you're introducing a new test, create a file (e.g., `newTest.js`) in the same directory.
   - You can also add test cases to an existing file (such as `test.js`).

3. **Write Your Test:**
   - Follow the project’s testing style and structure.
   - Use the test framework's functions and the assertion library for validating outcomes.
   - Ensure your tests properly clean up any data they create (like test users or posts).

4. **Verify Locally:**
   - Run your tests locally using the command:
     ```bash
     npm test
     ```
   - Confirm that your new tests pass before pushing your changes.

## CI Build Triggers

1. **On Code Push:**
   - Every push to the main branch triggers the CI pipeline automatically.

2. **On Pull Requests:**
   - Opening a pull request targeting the main branch will also trigger a CI build.


<!-- In the Developer Guidelines section of your Repository, document what a developer needs to know about testing and CI, including:

How to add a new test to the code base.
Which tests will be executed in a CI build.
Which development actions trigger a CI build. -->
