# Milestone 2

## Tools
- PostgreSQL Database
- Firebase Authenticator
- Flutter
- Dart
- Firebase Cloud Messaging (FCM)
- Elasticsearch
- Node.js

## Contributions
### Pranav

**APIs and Libraries :** 

**Firebase Cloud Messaging (FCM)** - cloud-based messaging service that allows us to send notifications to users across IOS and Android. As per my research and our project features, we plan to incorporate FCM for the following purposes : 
- Push notifications for users for new posts in their categories of interest.
- Push notifications for users about likes on their post(s).

FCM is ideal for our project as compared to its alternative - Amazon Simple Notification Service (SNS) - as FCM is free, while SNS is pay-per-use. Even though the cost of SNS is $0.50 per million notifications (which would not affect our project at its current stage), we would like to stick with FCM for scalability purposes. FCM is also known for its ease of use and its integration with the rest of the Firebase Ecosystem. FCM does not support platforms such as SMS and Email (while SNS does), but this is not pertinent to our project as it is a mobile-application only. 

**Elasticsearch** - search and analytics engine. As per my research and our project features, we plan to incorporate Elasticsearch for the following purposes :
- Searching for other users on the app
- Searching for posts by keywords
- (Potentially) Advanced filtering for posts within a specific date range or category 
- (Potentially) Use Elasticsearch’s data aggregations to gain insights into the usage of our app
  
Elasticsearch also has autocomplete features and a “fuzzy” search feature that would help display despite misspellings in the search. Elasticsearch is ideal for our project as compared to an alternative option - Algolia - as Elasticsearch is free if self-hosted, while Algolia is paid. We plan to use Firebase for hosting purposes. One downside of using Elasticsearch is that it requires manual scaling, so this is something we should keep in mind during the development process to ensure efficient scaling in the future, if need be. It is also less easy to setup and maintain than its alternative, but once again, it is ideal for our project at its current stage as it is a free service.



### Shibam
I looked at both databases and our backend language for this software. First I explored the following three options: **Node.js, Python, and Java**. Each has distinct strengths and trade-offs in terms of scalability, performance, and ease of use. 
#### Node.js
Node.js is a JavaScript runtime that is event-driven, making it highly efficient for handling multiple requests. It is good for handling real-time interactions with the user such as notifications and chat. It has a lot of libraries which reduces our development time while implementing certain features that already exist. Node.js is cross-platform so we can use any database and cloud service for storage with it. While it is efficient, it can struggle with CPU-intensive tasks. Since it is asynchronous, it's operations will be difficult to struct without proper management.
#### Python
Python has multiple backend frameworks like Django which is full-stack and Flask which is lightweight. While it is easy to learn and has readable code, it is slower than Node.js and not as optimized as Node.js for handlying many concurrent requests. There is also extensive documentation for both Django and Flask. However it is also more memory intensive and needs more optimization to work for a large-scale application.
#### Java 
Java is robust and highly scalable for backend. It has multi-threaded processing making it efficient for high traffic. It is also compatible with many different operation systems. However it is more complex and requires more setup compared to both Python and Node.js. It also requires more effort to implement simple features and consumes more memory when compared to Node.js.

With these points in mind, I decided that we will work in **Node.js** for backend development since it seems like the best out of the ones explroed. Next I looked at backed databases: **PostgreSQL, MySQL, Firestore**.
Firestore is a NoSQL database while PostgreSQL and MySQL are SQL databases. Firestore has really fast querying for data but it has no SQL capabilities so the data that can be used with Firestore can be semi-structured at most. 
MySQL is free and open-source and supports many platforms. It however only stores structured data which can be not very helpful if we want to work with JSON. 
PostgreSQL is object-oriented database with both SQL and NoSQL capabilities. It is also free and open-source and is compatible with various operating systems. Additionally there are many third party service providers and works with extra-large databases and can run complicated queries. This seems like the most helpful database that we should use since it works with a mix of structured data and unstructured data and is the most dynamic. So I have decided that we will use **PostgreSQL**.


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
