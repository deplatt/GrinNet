# GrinNet

## Product Description
GrinNet seeks to address the unique challenges of Grinnell’s community by offering an organized, accessible, and interest-focused platform. Unlike traditional social media platforms, GrinNet is tailored specifically for Grinnell students, leveraging the shared context of campus life. The existing systems such as email notifications and physical bulletin boards with event flyers often fall short of their goal due to information overload. GrinNet streamlines these processes by allowing students to sift through categorized posts, ensuring relevance and fostering meaningful interactions.
GrinNet will segment posts into broad categories such as gaming, sports, educational, and social, allowing users to easily find content relevant to their interests. Clubs and organizations will be able to create accounts as well, posting event details directly to the app and reducing reliance on overcrowded email inboxes or bulletin boards. In addition, GrinNet will have features like direct messaging to enable seamless collaboration and socialization among students (and/or organizations). Only Grinnell students can join, verified through their college email address.


## Repository Structure:
```
GrinNet/
├── README.md # Top-Level ReadMe file
├── DeveloperGuidelines.md # Contains information for developers, including style guides
├── Flutter_Tutorial # Folder containing code for a tutorial flutter app
├── Written_Reports/ # Folder containing our Written Reports
├── milestone-2-report.md # Report for Milestone 2
├── Sprint_1/ # Folder containing write-ups for sprint 1
├── Sprint_1_Images/ # Folder containing images for sprint 1
├── s1-planning-report.md # Planning report for sprint 1
├── s1-journal.md # Journal documenting progress for sprint 1
├── s1-review-report.md # Sprint report for sprint 1
├── Sprint_2/ # Folder containing write-ups for sprint 2
├── Sprint_2_Images/ # Folder containing images for sprint 2
├── s2-planning-report.md # Planning report for sprint 2
├── s2-review-report.md # Sprint report for sprint 2
├── s2-review-report.md # Sprint report for sprint 2
├── Sprint_3/ # Folder containing write-ups for sprint 2
├── s3-planning-report.md # Planning report for sprint 3
├── s3-review-report.md # Sprint report for sprint 3
├── s3-review-report.md # Sprint report for sprint 3


```

## Living Document Link
[https://docs.google.com/document/d/1CTr36a_xVtXY6tOySVvDR9Y9vrs7qS_BvlUNhrXX-tU/edit?usp=sharing](https://docs.google.com/document/d/1N8MflN70gUDutiXGfdL87tRxbGoefqRwZsnvDhCE3Ic/edit?usp=sharing)

## Issue Tracking Tool Link
https://trello.com/b/oLoye0oC/grinnet

# Build Guide

## Backend

1. **Download PostgreSQL, node.js, and (optionally) pgAdmin 4**
- Download PostgreSQL at https://www.postgresql.org/download/ or through equivalent command line arguments. Ensure that the command 'psql -U postgres' works in your before continuing.
- Download node.js at https://nodejs.org/en/download or through equivalent command line arguments.
- pgAdmin 4 isn't necessarily required for this project, but further steps will be listed as if you are using pgAdmin 4. Download at https://www.pgAdmin.org/download/ or through equivalent command line arguments.

2. **Clone our repository in a path of your choosing.**

### PostgreSQL

4. **Open your SQL shell and type 'psql -U postgres'**
- On linux, the SQL shell is simply your terminal.
- On Windows, the SQL shell executable should be somewhere in C://Program files/PostgreSQL/xx (whatever your version of postgreSQL is). In ~/scripts/, there is a .bat file called runpsql.bat that you can run. This can vary by version, though.
- On Mac, it could be that your SQL shell is your terminal. This is the case if you installed using the command 'brew install postgresql@17'. If not, type '/Library/PostgreSQL/17/bin/psql -U postgres' in the terminal instead. If you still cannot run psql, follow what the most liked post says on this stack exchange post: 'https://dba.stackexchange.com/questions/3005/how-to-run-psql-on-mac-os-x'.
5. **Run the command 'CREATE USER grinnetadmin WITH SUPERUSER CREATEDB PASSWORD 'csc324AdminDropTheClass!';'**
- You can make the username and password different, but make sure to change the 'config.js' file in the ./Backend_GrinNet/ directory of this project accordingly.
6. **Open pgAdmin, navigate to the dashboard, and press 'Add New Server'.**
- If you don't see the option, create a new server group first. Do this by right clicking the left-hand menu and selecting 'Create->Server Group'
7. **Name the server GrinNetApp, then navigate to the 'Connection' tab.**
8. **Set the 'Host name/Address' to 'localhost' or '127.0.0.1', with port 5432**
- You can set your port to be different, but you must change the config.js file mentioned before accordingly.
9. **Set the username to 'grinnetadmin' and the password to 'csc324AdminDropTheClass!'.**
- Tip: Save your password! It saves a lot of time!
10. **Press 'save' in the bottom right corner of the server setup window.**
11. **You should see a new server called 'GrinNetApp' running now!**
12. **Navigate to the left-most side bar, and select the 'PSQL Tool Workspace' option. Select the 'GrinNetApp' server, and log in with the 'grinnetadmin' account. Click 'Connect & Open PSQL'.**
13. **Copy and paste the code in the 'schema.sql' file into this terminal.**
- If you modify 'schema.sql' and want to reinitalize the database, it is recommended to simply delete the tables in the GUI workspace and redo this step. With a project this small, it's the quickest option.
14. **Navigate to the GUI workspace and click on 'GrinNetApp'. Give it about 5 seconds, and you should see some activity! Make sure that in the 'tables' menu of the 'GrinNetApp' server, you see 'users', 'posts', and 'reports' tables. This means that you are done with the PostgreSQL database setup.**
- If you have some kind of error, it is recommended to repeat the PSQL steps in your terminal and not the pgAdmin shell.

### Node.js
14. **Open up your favorite IDE that has terminal usage capabilities. Navigate back to the directory where you put the cloned GrinNet repository. Navigate to the ./Backend_GrinNet/ directory.**
15. **Install dependancies found in package.json with 'npm install'**
16. **Run 'npm run servers_start' to start up the node.js servers (express server to handle user data and image server to handle images). Feel free to change the port of these servers in ~/config.js.**
17. **If you want to have some sample user + image data to play around with, run 'node populate_data.js'. If you want to test the backend code, run 'npm test'.**

18. **Congrats! You have successfully set up the backend part of GrinNet locally! Time to move onto the frontend setup...**

## Frontend

1. **Install Flutter by following the instructions at this [link](https://docs.flutter.dev/get-started/install?_gl=1*mgpbu1*_gcl_aw*R0NMLjE3NDQyNTY5ODAuQ2p3S0NBand0ZGlfQmhBQ0Vpd0E5N3k4QkloNWhZYjBYTzI1TlJlN2tFNXQtUy1hREhyZVhhcUtIbkFyeEtsTTd6R0VabGJRTHhDVVpCb0NPaVVRQXZEX0J3RQ..*_gcl_dc*R0NMLjE3NDQyNTY5ODAuQ2p3S0NBand0ZGlfQmhBQ0Vpd0E5N3k4QkloNWhZYjBYTzI1TlJlN2tFNXQtUy1hREhyZVhhcUtIbkFyeEtsTTd6R0VabGJRTHhDVVpCb0NPaVVRQXZEX0J3RQ..*_ga*NTU3NDcwNzIwLjE3Mzk1MDQxOTg.*_ga_04YGWK0175*MTc0NDI1Njk4MC4xNS4wLjE3NDQyNTY5ODAuMC4wLjA.). Choose your operating system, and the reccomended first type of app.**
2. **Clone the GrinNet, then navigate to GrinNet/Flutter_GrinNet**
3. **Run the command ```flutter pub get```**
4. **Next, install an emulator of your choice. It is suggested to get Android studio if you are on Linux or Windows, and Xcode if on Mac. Make sure the Virtual Machine is running when trying to run the flutter frontend.**
5. **You should now be set up! To boot the project, run ```flutter run -d``` and observe what your emulator's ID is listed as. Run ```flutter run -d <DEVICE_ID>``` to start running the app on your VM. If you have Xcode on Mac, it could potentially be sufficient to run ```flutter run```. !!!NOTE THAT THIS APP WILL NOT WORK IN THE BROWSER OPTION!!!**

---