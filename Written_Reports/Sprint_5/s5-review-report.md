## Summary of Work Completed in this Sprint
In this sprint, we
- Merged backend progress, resulting in full image support on the app
- Fully implemented the forgot password feature
- Created an adoption plan for our product
- Practiced bug logging for three distinct bugs
- Created a blog post for softarchitech.cs.grinnell.edu
- Implemented a date/time feature for each post
- Chose a license for our software
- Created tests for many frontend pages
- Added a bar to the homepage for easy tag filtering
- Beatified the codebase in the repo
- Completed the change password and dark/light mode features on the settings page
- Added the ability to select add a profile picture in the settings page
- Presented our product in a final demo presentation
- Fixed our GitHub actions configuration, allowing us to merge into main

## User-Facing Improvements
In this sprint, we made a lot of user-facing accomplishments. Perhaps the largest one was full integration of images in the app. We previously had the user be able to attach an image to a post and see it, but they were not able to see any images on other's posts, and the image would break if the app was closed and reopened. In this sprint, we fixed some issues so now, users can submit and see any image for posts in the app! Additionally, following suggestions from our shareholders, we added a dedication date and time selection when making a post. Now, users will be able to see the specific date and time for each event, and posts will automatically be deleted 24 hours after their corresponding event occurs. 

In addition, the Forgot Password feature is fully complete. Now users can click "Forgot Password" below the password field on the login screen. This will take them to a page where they can enter their email, and upon doing so an email will be sent allowing them to change their password outside of the account. We have also added functionality to many parts of the settings page (which can be found by clicking the gear icon on the top right of the user profile page). In settings, users can change their app from light mode to dark mode and vice versa, they can add a profile pic from their camera roll, they can change their password directly within the app, and they can even delete their account! Finally, user can filter for tags they are interested in directly from the homepage, with a new tag bar slider just below the search bar.

## Non-User Facing Improvements
A lot of effort in this Sprint went into writing tests our new pages, which are instrumental for development but do not affect the users directly. We also spent some time cleaning up the codebase to make future development easier, and we restructured some of the backend. We also practiced bug logging through three different bug reports on the Trello board.

A signficicant aspect of this sprint was our version control struggles. For the last two sprints, we have been working out of a branch that is not main (```final-demo``` and then ```last-demo```) but we were adding all of our written reports to main directly. We practiced good habits and did many code reviews when merging into these demos, but we were never able to merge into main due to an issue with GitHub actions in main specifically. And from demos at the end of each sprint, we accrewed a significant amount of technical debt. In this sprint, we fixed that, although the path to do so took a lot of time and effort. Notably, we changed our default branch and had to manually copy the written reports. As a result, the blame for each file in the ```Written-Reports``` folder is missing, and can instead be found in the branch called ```old-main```. This was an unfortunate misstep in our process and if we continue to work on the project going forward, we will be able to avoid making a similar mistake.