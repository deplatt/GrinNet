# Sprint 5 Journal

## Part 1 : Adoption Plan

1a) Create Adoption Plan

Date : Thursday, 1st May, 2025
   
**Is your product ready for adoption?**

"Describe the current state of your product's development at the time of writing this journal entry."  
Our GrinNet bulletin-board app is not yet production-ready. We have many functional features — users can register with a @grinnell.edu address (Firebase Auth), create posts with text and tags, view an event feed, open posts in detail, and even report a user. The Express / PostgreSQL backend supports users, posts, and reports, and frontend-to-backend traffic works for the primary use cases that exist. We also have automated tests cover basic login, in addition to the create-post and view-post UIs. 

However, the codebase is still quite a nascent state overall :
- images are not persisted yet (we only have local file path placeholders).
- profile, settings, and password-reset use cases are not fully implemented.
- error handling and input validation are minimal.
- the CI suite and failing tests on the final-demo branch must be resolved before merging back into the main branch.
- deployment scripts for the remote Express server and image server are not fully implemented yet. 

In short, our foundations are solid, but we need polish our code and make it more robust. The full set of features that should be expected of a high-quality product are still missing.


"Give a comprehensive risk/benefit analysis of your product by stating at least 5 risks or benefits of using your product."  
Benefits -  
Increased interactions on campus : a dedicated bulletin board just for Grinnell students helps discover more on-campus events and increases community engagement.  
Authentication limited to @grinnell.edu : the app ensures that only Grinnell College members can access the app, both reducing spam on the app and also ensuring a safer community.  
Built-in reporting and moderation : reports are stored in the reports table and gives moderators the required information to ensure safe discourse on the app.  

Risks -  
Incomplete image pipeline : posts referencing local file paths could potentially break or expose filesystem structure once deployed.  
Privacy & data-leak potential : currently, we handle user IDs and profile pictures without encryption so any leaks would expose student data.


"Is it right to encourage people to adopt your product in its current state? Or will you continue developing instead? Explain your decision."    
It is not yet advisable to push campus-wide adoption. While the core posting and viewing experience works and the Auth wall keeps the audience limited to Grinnell addresses, the missing image storage, unfinished profile flows, and security gaps would lead to a poor first-impression and potential data-safety issues. We should therefore continue development, focusing on stability and the completeness of our features, before inviting real users.


**Continued development plan (if not ready for adoption)**  
"Will your product be ready for adoption after some future work? Why or why not?"  
Yes. The remaining gaps in our codebase are relatively well-defined and the architecture (Flutter --> Express --> PostgreSQL) is in place. Completing the remaining items will give us an MVP suitable for real-world use even if certain stretch features remain unimplemented.

"If you answered yes to the previous question, what future work is needed before adoption?"  
Core tasks to finish this semester :  
1.	Image pipeline – integrate a local image server; update /posts to store URLs instead of path stubs.
2.	Profile page to Settings page sync – make bio text from settings page appear on the profile page.
3.	Tag bar filter – quick-filter chips below the search bar to allow sorting posts by tags.
4.	Forgot-password feature and obscured password field on login page.
5.	Additional automated tests for backend : /reports, /posts edge cases.
6.	Additional automated tests for frontend: report feature, profile page, settings page.
7.	Bug-fix pass – resolve failing tests on final-demo and merge to main.
8.	Setting up a remote connection to our express and image servers.
9.	Add Date & Time fields to posts

Higher-aspiration items (post-semester)  
- Like feature for posts
- Comments features for posts
- Editing your post after it has already been made
- Posts recommendation algorithm based on a user’s activity on the app
- Personalized calendar to view events marked as interesting / interested
- Push notifications for tagged interests.
- Data Analytics (e.g., Sentry, PostHog) for proactive error-tracking and quality monitoring of the activity on the app.
Completing the core tasks delivers a safe, functional bulletin board; and the aspirational items would elevate it to a polished, production-grade campus platform.




1b) Carry out Adoption / Continued Development Plan
// In part (1a), you made a plan. Towards the end of the sprint, add a section to your Sprint Journal describing what you did to carry out that plan // and the outcomes. Make sure to include the date of the journal entry. It should be after the date of the entry in which you created your plan.

Date : Tuesday, 13th May, 2025. 

We made significant progress on our core tasks to finish by the end of the semester, completing all but one of them — we were unfortunately not able to figure out how to set up a remote connection to our express and image servers. Other than that, we managed to integrate a local image server by updating /posts to store URLs for images instead of path stubs, synced up our Profile and Settings pages and made the bio actually appear on the profile page, added a tag-bar under our search bar so that users can simply sort by the tags if needed, implemented a forgot-password feature and obscured the password field while logging in, added additional automated tests for the frontend and backend, resolved our failing tests on latest-working branch and merged into main, and lastly we added date and time fields to our event (posts) model. While we were hoping to try and implement at least one or two of the higher-aspiration items as well, we have not found the time to do so as everyone has been occupied with other final's week work as well. Overall, we are very happy with the current state of our product, and we may even continue working on the product after the end of the semester.  


## Part 3: Bug Logging
Bug 1: https://trello.com/c/5IV3Rb41/83-create-post-bug
Bug 2: https://trello.com/c/6p9Kovui/84-report-feature-bug
Bug 3: https://trello.com/c/75yu3Hxm/85-user-id-fail-fetch-bug

## Part 5: Wrap-Up Work
In this section, we first of all merged our last-demo branch with our Main branch. This was very difficult since even though the main branch did not have the files in last demo, we were receiving many merge conflicts. We ended up renaming our last-demo branch to Main and renaming our old main branch to (you guessed it!) old-main. This also had some issues, since we now tried merging old-main into our last-demo branch, this meant that the previous ReadMe.md version got merged in, deleting significant progress from our previously updated Readme.md file. Luckily we were able to find our previous Readme.md file through our commit history and similarly with most of the written reports. Note, this is also a reason why it showcases that our old sprints have been recently committed. Next, we worked on adding our final documentation to each of the new code files that were added. We also updated the repository structure in the Readme.md file while also clearing out any unwanted files that should have been cleared through gitignore to begin with. This includes file like DS-store, .flutter-dependencies, etc. 
