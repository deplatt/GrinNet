## Coding Guidelines

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

## Build Guide

### Backend

1. **Download PostgreSQL, node.js, and (optionally) pgAdmin 4**
   - Download PostgreSQL at https://www.postgresql.org/download/ or through equivalent command line arguments. Ensure that the command 'psql -U postgres' works in your before continuing. 
   - Download node.js at https://nodejs.org/en/download or through equivalent command line arguments.
   - pgAdmin 4 isn't necessarily required for this project, but further steps will be listed as if you are using pgAdmin 4. Download at https://www.pgAdmin.org/download/ or through equivalent command line arguments.
  
2. **Clone our repository in a path of your choosing.**

## PostgreSQL

4. **Open your SQL shell and type psql -U postgres**
   - In Mac and linux, the SQL is simply your terminal.
   - On Windows, the SQL shell executable should be somewhere in C://Program files/PostgreSQL/xx (whatever your version of postgreSQL is). In ~/scripts/, there is a .bat file called runpsql.bat that you can run. This can vary by version, though.
5. **Run the command CREATE USER grinnetadmin WITH SUPERUSER CREATEDB PASSWORD 'csc324AdminDropTheClass!';**
   - You can make the username and password different, but make sure to change the 'config.js' file in the ./PostgreSQL/ directory of this project accordingly.
6. **Open pgAdmin, navigate to the dashboard, and press 'Add New Server'.**
   - If you don't see the option, create a new server group first. Do this by right clicking the left-hand menu and selecting 'Create->Server Group'
7. **Name the server GrinNetApp, then navigate to the 'Connection' tab.**
8. **Set the 'Host name/Address' to 'localhost' or '127.0.0.1', with port 5432**
   - You can set your port to be different, but you must change the config.js file mentioned before accordingly.
9. **Set the username to 'grinnetadmin' and the password to 'csc324AdminDropTheClass!'.**
   - Tip: Save your password! It saves a lot of time!
10. **You should see a new server called 'GrinNetApp' running now!**
11. **Navigate to the left-most side bar, and select the 'PSQL Tool Workspace' option. Select the 'GrinNetApp' server, and log into it with the 'grinnetadmin' account.**
12. **Copy and paste the code in the 'schema.sql' file into this terminal.**
   - If you modify 'schema.sql' and want to reinitalize the database, it is recommended to simply delete the tables in the GUI workspace and redo this step. With a project this small, it's the quickest option.
13. **Navigate to the GUI workspace and click on 'GrinNetApp'. Give it about 5 seconds, and you should see some activity! This means that you are done with the PostgreSQL database setup.**

## Node.js
14. **Open up your favorite IDE that has terminal usage capabilities. Navigate back to the directory where you put the cloned GrinNet repository. Navigate to the ./PostgreSQL/ directory.**
15. **Run 'npm app.js' to start up the express (node.js) server. Feel free to change the port of this express server in ~/config.js.**

16. **Congrats! You have successfully set up the backend part of GrinNet locally! Time to move onto the frontend setup...**

### Frontend

---

## Testing and CI

### CI Build Triggers

1. **On Code Push:**
   - Every push to the main branch triggers the CI pipeline automatically.

2. **On Pull Requests:**
   - Opening a pull request targeting the main branch will also trigger a CI build.

### Flutter testing:

1. **Locate the Test Directory:**
   - For **Unit/Widget** Tests, put them in `Flutter_GrinNet/test`.
   - For **Integration Tests**, put them in `Flutter_GrinNet/integration_test`.
   - All test files in these directories are run every CI trigger.

2. **Create or Update a Test File:**
   - If you're introducing a new test, create a file (e.g., `newTest.dart`) in the corresponding directory.

3. **Write Your Test:**
   - Follow the project’s testing style and structure.
   - Use the `flutter_test` library for validating outcomes.
   - Ensure to update the CI workflow if a test requires adding an emulator.

### Node.js testing:

1. **Locate the Test Directory:**
   - All node.js tests are located in the `GrinNet/PostgreSQL` directory. This is where you'll add or update your test files.
   - All test files in this directory are ran every CI trigger.

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


<!-- In the Developer Guidelines section of your Repository, document what a developer needs to know about testing and CI, including:

How to add a new test to the code base.
Which tests will be executed in a CI build.
Which development actions trigger a CI build. -->
