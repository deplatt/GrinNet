# Sprint 3 Journal

<!-- As before, for any changes to the Requirements Document, add a link to a difference document in your Sprint Journal. The difference document is separate from the Requirements Document and there are a couple ways to create it:

1) Format added text with underline and deleted text with strikethrough.
2) Generate a URL comparing commits of your document before and after changes.
If your Requirements Document did not change this sprint, clearly say so in your Sprint Journal. -->

We did not make any changes to our Requirements Document during this sprint. 

### Summmary of Progress
In this sprint, we prepared for our upcoming demo by completing an end-to-end implementation of our project. 

Behind the scenes, we created tests for the frontend and backend and integrated these tests with Github Actions to automatically test the project whenever a commit is made. We exercised good coding and version control practices by creating branches with git and developing within those branches instead of main. We completed a code review every time we wanted to merge a branch into main to make sure that the main branch is clean and functional. We made many revisions to our code base through code reviews, and we documented our code as we wanteded to ensure readability and clarity. 

For the backend, we completed our node.js functions (found in functions.js), our express (node.js) server (found in app.js), created a trigger in our schema.sql that normalizes and validates post tags.  

We made a significant amount of technical progress as well. We developed a functional frontend for our app. This includes a sign-in and register account page, homepage with a feed of posts, a create post page, view post page, and a profile page where the user can view their previous posts. This was quite an involved process, and it required a lot of effort to merge each component into a connected piece of software. Now each page contains the information it needs, and we have developed the logic for navigation between pages.

This frontend was then connected to our backend PostgreSQL database locally for each machine. Now the user posts are saved in the backend database, so whenever we run the code (on a single device, on the same server), it showcases all of the previous posts created by different users (on the same device) in the front end home page. 

We also connected the login logic of the frontend to Firebase's authentication service. This means we now have a database behind the scenes that tracks the email and (encrypted) password of every user who signs up for the app. Then if that user tries to log in again with the same email, they will only be able to do so with the correct username and password.



### Git Tag


<!-- Make an entry in your Sprint Journal document including:

A summary of non-user-facing progress for this milestone. -->


<!-- Make an entry in your Sprint Journal that includes:

Name of the git tag for the commit containing your demo code. -->
