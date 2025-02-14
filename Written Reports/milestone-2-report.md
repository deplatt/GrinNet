# Milestone 2

## Tools
- Firebase Authenticator
- Flutter

## Contributions
### Pranav


### Shibam
Backend Databases: PostgreSQL vs MySQL


### Jeronimo

I took a look into what cloud services we could integrated to our app. From the research I conducted I found the following options: Firebase, AWS amplify and Superbase. I also found out other options such as Microsoft Azure and Google Cloud Platform, however this options are more costume based and in order to maximize their utility, we would have to build our own costume back end. And although we would have full control and customizability, it requires extensive knowledge to maintain as well as time to develop, two things we do not have right now.  So that’s why I focused my pros and cons analysis on this options: Firebase, AWS amplify and Superbase. 

For Firebase: 
Pros: 
- It is relatively easy to use, specially having into account that we are using flutter which already integrates firebase within. In addition, there is a lot of documentation and it has pre-built Software Development Kits.
- It supports several authentication methods such as email or Facebook.
- Provides analytics 
- It has a free tier for small apps which includes: Firestore: 50k reads, 20k writes, 1GB storage per month. Authentication: 10k monthly active users. Storage: 1GB download, 5GB upload per month.
Cons: 
- has limited querying capabilities compared to SQL databases
- Can become expensive as our app grows 
- Tied with Google, they get to see the data

For AWS Amplify: 
Pros: 
- Flexible: Supports multiple AWS services (e.g., S3, Lambda, DynamoDB).
- Highly scalable and reliable 
- More control over the backend compared to firebase 
- Built-in support for GraphQL APIs. Which can be useful 
- Tied with Amazon, they get to see the data
- Includes a Free Tier: 1 million monthly active users for authentication, 5GB storage, 1GB data transfer per month.
Cons:
- Much more complex than firebase, which means its more time demanding 
- Can become expensive if not managed properly.
- Extra configuration and set up

For SuperBase: 
Pros: 
- It’s open source, and gives us control over the data
- Uses a powerful SQL database, offering advanced querying capabilities.
- Built-in real-time functionality.
- Overall cheaper option in the long run
Cons: 
- Its a newer platform, so not as much material to prepare 
- Fewer built-in features compared to Firebase and AWS
- Requires more technical expertise 


So given time and money constraints and the listed analysis, we are going to use firebase.


### Deven
I looked at options for an email authenticator to use for our app. As part of the app, we require that users have a valid grinnell.edu email address, so verifying their email is a very important aspect of the project. After reviewing the options, I decided that we will use Firebase for email authentication.
Firebase provides built in support for Flutter, and is well documented. It is a commonly used tool with a large community, so finding tutorials and answers to questions online will not be a barrier. It also has a free starting plan, which should be enough for a project of this scale. 
Other alternatives include Amazon Cognito, WorkOS, and Parse. While any of these would surely satisfy the (relatively simple) requirements for this apsect of our project, Firebase's ease of use and documention made it the stand-out.

In the process of deciding on this, I looked at some online tutorials on integrating Firebase and asked some basic questions about it with a friend who has used it before in full-stack app development.

### Anthony
In developing the app, one of the key decisions we had to make was selecting the frontend. We needed a framework that would not only deliver a user-friendly interface but also support cross-platform functionality. After looking at our options, I narrowed it down to two main contenders: React Native and Flutter.

Ultimately, I decided that we should go with Flutter for our frontend development. One of the driving factors behind this choice was the simplicity of its syntax, which made it easier to learn on our tight schedule. The syntax is also somewhat similar to Java, which we all already know how to code in. Second driving factor is that app updates with Flutter are significantly easier to do. With React Native, updates are a very involved process which we really don't have time to dedicate our time to.

We will be installing the Flutter extension on vscode and coding/debugging in it. Towards the end of the project we will also use our personal devices or VMs to make sure the app's frontend works correctly.
