# Milestone 2

## Tools
- PostgreSQL Database
- Firebase Authenticator

## Contributions
### Pranav


### Shibam
Backend Databases: Options reviewed: PostgreSQL, MySQL, Firestore
Firestore is a NoSQL database while PostgreSQL and MySQL are SQL databases. Firestore has really fast querying for data but it has no SQL capabilities so the data that can be used with Firestore can be semi-structured at most. 
MySQL is free and open-source and supports many platforms. It however only stores structured data which can be not very helpful if we want to work with JSON. 
PostgreSQL is object-oriented database with both SQL and NoSQL capabilities. It is also free and open-source and is compatible with various operating systems. Additionally there are many third party service providers and works with extra-large databases and can run complicated queries. This seems like the most helpful database that we should use since it works with a mix of structured data and unstructured data and is the most dynamic.


### Jeronimo


### Deven
I looked at options for an email authenticator to use for our app. As part of the app, we require that users have a valid grinnell.edu email address, so verifying their email is a very important aspect of the project. After reviewing the options, I decided that we will use Firebase for email authentication.
Firebase provides built in support for Flutter, and is well documented. It is a commonly used tool with a large community, so finding tutorials and answers to questions online will not be a barrier. It also has a free starting plan, which should be enough for a project of this scale. 
Other alternatives include Amazon Cognito, WorkOS, and Parse. While any of these would surely satisfy the (relatively simple) requirements for this apsect of our project, Firebase's ease of use and documention made it the stand-out.

In the process of deciding on this, I looked at some online tutorials on integrating Firebase and asked some basic questions about it with a friend who has used it before in full-stack app development.

### Anthony