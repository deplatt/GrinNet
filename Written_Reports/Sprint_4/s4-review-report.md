## Summary of Work Completed in this Sprint
At the end of our fourth sprint, we were able to:
- Create a user guide for our product
- Demo our product with three shareholders
- Implement seamless email verification for new users
- Created a "forgot password" page from the login screen
- Implement a setting page in the app
- Implement a user profile page in the app
- Implement a "report post" button in each post
- Improve the look of the UI overall
- Work on image capabilities in the backend
- Carry out several experiments with generative AI
- Demo our new features with a presentation
- Improve our documentation for existing code

## User-Facing Improvements
A lot of our progress this sprint was new features within the app, which are naturally very user facing. The following features are user-facing, and can be activated as follows:
- We implemented email verification, so now only users with grinnell.edu email addresses can make a new account, and they have to click on a link sent to their email in order to finishing creating their accounts.
  - To activate, click the "I want to create an account" button from the login page and enter your grinnell.edu email. Then in Outlook, click the link in the email sent to you. Finally, navigate back to GrinNet to see that you have successfully been logged in to the app!
- Users who forgot their password can navigate to the "Forgot Password" page from the login screen and enter an email for account recovery
  - To activate, click the "Forgot Password" button below the text field where you enter your password on the login screen (you may have to click "I already have an account" to go from sign-up to sign-in). Then enter your grinnell.edu email in the text field and click "Send Email". This will take you back to the login screen, but unfortunately no email will be sent yet.
- Users can also report posts
  - To activate, click on any post on the homepage to see its enlarged version. At the bottom, you will see a red "Report Post" button.
- Users can access a user profile page containing all their previous posts.
  - To activate, click the person icon on the bottom right of the homepage.
 - Users can access a settings page for the app
  - To activate, click the gear icon on the top right of the user profile page. Right now, the only functional button is "Log Out" at the bottom, which will take you back to the login page.

In addition, the user can see that the UI looks a little cleaner, and is now in dark mode by default.

Importantly, to access these features in the current state of the repo, you need to pull from the ```final-demo``` branch.

## Non User-Facing Progress
We completely three stakeholder meetings this sprint, and they all provided useful feedback for how to improve our app. We have not has time to implement any of their suggestions yet, but we plan to work on this in the next sprint. In addition, we improved documentation accross the board, specifically during the internal documentation lab. We also spent a lot of time reworking the way posts in the frontend and images in the backend are stored, which is very important but not a visible change to those using the app. Finally, we conducted AI experiments, which are helpful in the broader context of CSC-324.
