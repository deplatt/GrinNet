# Sprint 3 Review Report 

Describe what you completed this sprint.

How has your product improved or progressed from a customer perspective? Describe in terms of high level features that a non-technical user could recognize and appreciate.
What progress have you made that is not visible to a common user?
The Sprint Review document should include:

For each user-facing feature that is operational, describe steps to activate that feature in the user interface. The steps should be clear enough that your instructor can follow them while grading your work, without help from your team.

## Description of what we completed this sprint

At the end of the third sprint, we were able to:
- Implement 4 different pages: Login, View Post, Create Post, and Home page
- This means that for these 4 pages we have a complete user facing product that works as intended
- Login Page allows user to either login or register an account. We were able to implement firebase authentition wich will check that the email and password match with the information in our data base.
- We have also provided some test to see that the UI elements are rendering correctly and showing the text/images they are supposed to
- We have also tests for mocked logins using the Mocktail library in the flutter testing package to simulate a regular user login.
- In the home page we have successfully displayed the posts, including the posts that appeared after we creating using the new post feature.
- You can scroll through the posts which are presented in order of creation.
- You can also search based on tags and events
- Backend stuff (Anthony to do)

## How has your product improved or progressed from a customer perspective? 
The product has improved a lot from a customer perspective since we finally have a visible product. Even though there is still a lot of work to put into the product, we have a UI and some basic functionality. The user will be able to register and login, search from posts, create posts and see posts. In other words, the customer finally has a version of the app! It is no longer just resports and answers to questions, this is actually a product. 

Below are the steps to use each user-facing feature. 
To register a new account, enter a valid email address and valid password. A valid email address right now is anything in the form of xxxxxx@xxxx.xxx. A valid password is any alphanumeric input of the length of atleast 6 characters. Once a valid email and password have been entered, the user can click on register to register a new account. This will then show up in the Firebase as an account. Next, to login, enter the registered email and password and then click Login. This brings the user to the home page. The user can click on any of the visible posts in the home page to go to the view post page specific to that post. To leave the view post page, click on the top left arrow icon which represents the back button. 
To create a new post, from the homepage click on the bottom left '+' icon, then enter post title and description along with tags. Attaching images are optional and local (not on the database) for now but visible in the homepage if post is created with attached image. Once all information is entered, you can click on the submit post button which takes the user to the home page and the user are able to view the post in the home page. 
Next the user can search using event titles, description, username and tags through the search bar on top of the home page. To search, the user can enter alphanumeric characters according to the user's preference. Note that if no such post exists, no post will show up in the homepage. 
The user is also able to view their own profile by the bottom right button in the homepage. However this is not completely implemented and shows every post by every user for now in a list format. There is also a settings button in this page, if clicked it should just show "enter user settings functionality here," as it has also not been implemented yet.


## What progress have you made that is not visible to a common user?
A lot of time investigating, learning, and testing the dart language as well as Node.js. In addition, we have had several meetings discussing and working, there has been time dedicated to write reports like this and other miscellaneous requirements.
Anthony (do the rest for backend!!!)

