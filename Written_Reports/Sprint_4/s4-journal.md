# Sprint 4 Journal

## Part 1: External Documentation and Stakeholder Meetings

<!-- In your Sprint Journal, add an entry that includes the following for each stakeholder:
-Who you met with
    -Name, occupation, and other relevant information about the stakeholder
    -Date and time of the stakeholder meeting
-Description of the test session and feedback
    -What was their behavior of interacting with the documentation?
    -Did they succeed or get stuck?
    -What feedback did they provide about documentation?
    -What questions did you ask, and what were the stakeholder's answers? -->

### Stakeholder 1:
Rebecca Boroda - Regular User, grinnell college student. Conducted on Tuesday, 22nd April, 2025 at 4:00 PM

Action to perform - Use Case 1 : Search 

Behavior interacting with the documentation : Becca found the documentation to be concise and easy to understand.

Success / failure in task : Becca succeeded in her task of searching through the search bar, although it took her a second to figure out the parameters she could search by. She finally ended up searching by content in the post, by tags, and by username (all 3 possibilities to search).

Feedback on documentation : Becca initially found the documentation to be a bit too concise, but after testing the app, she found it to be sufficient for the current state of the app. 

Questions asked to the stakeholder: 
How intuitive was the interface to use? Which buttons did what you expected/which did not?
4 out of 6. All the buttons did what was expected, except the profile page, where she expected to see her own profile and not various posts. However, the profile page simply had not been implemented yet.

Did you like the layout of the create post page/how would you improve it?
There should be a dedicated section in the post for date / time of event. 

Do you have any other suggestions for changes to the interface?
The interface is visually unappealing as things stand. 

Do you think you would use this app personally?
With an improved interface, I would possibly use it. 

How the product will be updated based on feedback : based on becca's and also jesica's feedback, we are planning to modify our event / post model to include dedicated sections to display the date and time that the event will take place. 


### Stakeholder 2:
Jesica Rodriguez Beyer - Regular User, grinnell college student. Conducted on Tuesday, 22nd April, 2025 at 6:00 PM

Action to perform - Use Case 2 : Create Post 

Behavior interacting with the documentation : Jesica found the documentation easy to understand. 

Success / failure in task : Jesica succeeded in her task of creating a post. She made on for Alice, choosing the tags for culture, music, and misc. She even added a random image from the device on which she conducted her test. 

Feedback on documentation : Jesica, like Becca, said the documentation was simple and concise.  

Questions asked to the stakeholder: 
How intuitive was the interface to use? Which buttons did what you expected/which did not?
Jesica found the existing interface to be decently intuitive, although she had a number of suggestions for changes to the interface (mentioned below)

Did you like the layout of the create post page/how would you improve it?
Jesica also mentioned that there should be a dedicated section in the post for date / time of event. 

Do you have any other suggestions for changes to the interface?
- be able to preview the image when it is uploaded
- create post interface should match what the actual post will look like
- the title of the event should be in bold to make it clear
- wants to be able to refresh the feed by scrolling down instead of a refresh button

Do you think you would use this app personally?
With an improved interface, I would possibly use it. 

How the product will be updated based on feedback : based on becca's and also jesica's feedback, we are planning to modify our event / post model to include dedicated sections to display the date and time that the event will take place. We will also make the event title bold. 

### Stakehodler 3:
John Robinson - Regular User, Grinnell College student. Conducted April 23, 2025. 
Action To perform - Use Case 1 & 2 & 3: Search, create post, create account
Behavior interacting with the documentation : John found the documentation  to be straightfoward, and easy to comprehend. 

Success / failure in task : John succeeded in all of the actions he performed. He used the user manuel we provided him to create an account using his school email. During this process he was able to access the verification email send to his email and login in to our app. Afterward he explored the different pages in the app, and proceed to complete the remaining tasks. For the search, I asked John to perform different searches. He realized quickly with the help of our user manuel that he could search based on user, tag, and post. Finally, I prompt John with the final task, create a post. I asked him to create a post that announced a Movie Night. He was able write the description, include tags and include an image. 

Feedback on documentation : John found the documentation helpful. He said that the concept of the app was similar to popular apps, which meant that just based on intuition, he could perform most taks. However, he pointed out that the user manual did give him some information that help him complete the tasks, specifically for the login he re was able to see that the email had to be his school email as well as the password had a minimmun length. 

Questions asked: 

1.How intuitive was the interface to use? Which buttons did what you expected/which did not?
It was very intuitive, the buttons were clear and indicated the functionality pretty well. 

2.Did you like the layout of the create post page/how would you improve it?
I would like the design to be more user frindly and more asthetically pleasing. It feels like the bare bones of the application. I like the  organization, it is pretty easy to navigate and there is a well thought flow. I feel like the font seems reasonable as well as the posts. However, the image are to big, I would make them smaller and have a fixed sized for them.

3.Do you have any other suggestions for changes to the interface?
Smaller pictures, date of event + calendar with events I'm interested in + include notifications based on specific tags you can follow. Make app more inviting and engaging.

4.Do you think you would use this app personally?
I like it, I see pontential on it.

How the product will be updated based on feedback : based on John response we are planning to work on the design of the app, making it more visually appealing. Additionally, we are going to change the image sizes, making them fixed and proportional to our layout. We would like to implement as much of the recomendations John gave, yet those are strech goals. 


## Part 2: Internal Documentation

<!-- As part of Sprint 4, you will submit the following deliverables as entries in your sprint journal:

For each subgroup
- Name the members of that subgroup
- Identify the code that you worked with in the lab (e.g. calico.java, lines 1-437)
- Write a paragraph to describe the changes that you made to the code and the documentation
- Identify existing documentation that was helpful
- Identify the commit hash of the commit in which you wrote your new documentation. Provide a Github link where your instructor can view the diff of that commit.
- If you created or updated any issues in your issue tracker, show a "before" and "after" snapshot of the detailed view of each issue so that the difference can clearly be seen -->

### Subgroup 1: Shibam, Pranav, and Anthony

Internal Documentation Lab: Partners: Shibam (Teammate A), Anthony and Pranav (Teammates B)
Code Selected: Flutter_GrinNet/lib/pages/create_post.dart (Lines 1 - 157)

**Teammate B Review:**

Task description : 
we arrive at the create post page by clicking on the “+” button. It  allows users to create a post, with or without an image, for other users to view. Could include the task description at the top of the file.

Changes needed :
Comments on some methods but not others. Ones without comments are _submitPost (line 41).

No comments on classes. Class CreatePostScreen (line 8), _CreatePostScreenState (line 15) needs comments.  

Additionally, widget build (line 88) is a big block of code with no in-line comments. While there is an explanatory comment at the start of the widget, it is difficult to follow along with the specifics of the internal code without further comments.  

Lastly, it would be very helpful for the class and method comments to include preconditions and postconditions, and parameters and exceptions (if applicable). This would help follow the logic of the code with much more ease. 

**Changes made :**

Added comments to all methods and classes along with widget build (the UI) explaining each line of code.

Commit Hash: 19885bc51ea79a51589c1562fd82dd97ddb80280

Commit link: https://github.com/deplatt/GrinNet/commit/19885bc51ea79a51589c1562fd82dd97ddb80280

### Subgroup 2: Deven and Jeronimo

We discussed the file CreatePost_test.dart. The only existing documentation we had for this code were the line-by-line comments in the code. This is very helpful documentation, as the code would be hard to read without them. 

We decided that it would be helpful to have more documentation in the code itself, as well are more related documentation in the Trello board. In the file, we added a block comment at the top with some basic information about the test suite and how the tests work. In the Trello board, we added a few issues for various test suites that we still need to write. This includes the last part of the create post tests (making it work with image selection on a phone), and testing pages that we have yet to create. We previously did not include testing in the issue tracker, which was an oversight because writing the test suites requires a significant amount of work. The changes the Trello board are shown in the screenshots below:

Before:
![Image](../Sprint_4/Sprint_4_Images/DocLab2TrelloBefore.png)

After:
![Image](../Sprint_4/Sprint_4_Images/DocLab2TrelloAfter.png)



**Changes made :**

Added comments to the tests and add explanaitions about what each mock class does.

Commit Hash: ca986c0ee7267675c784e0e91b346d5566549395

Commit link: https://github.com/deplatt/GrinNet/commit/ca986c0ee7267675c784e0e91b346d5566549395

## Part 3: MVP

<!-- In a Sprint Journal entry, remind us what your MVP is (look back to Milestone 1 where you described what features would be included in your MVP)
Describe what work, if any, remains toward delivering your MVP -->

Our MVP includes the following features:
- Making posts
- Viewing a feed of posts
- Categorization of posts based on topic
- Searching through exising posts
- Settings page
- User profile page to view your own posts
- Email verification for login
- System for account/password recovery
- Seamless sign-in and sign-out

We are nearly there when it comes to our MVP. The main things that remain are 
1. The full implementation of the "forgot password" feature for account recovery. We currently have a "forgot password" page available from the login screen for the user to enter their email, but it is not fully functional yet.
2. A scrollable tag bar at the top of the hompage for categorization of posts. Right now a user can search the name of a tag to get every post with that tag, so it could be argued that we have fulfilled the categorization requirement, but we think it will be easier for the user if we have a specific feature for this right on the homepage.
3. Full image support for making and viewing posts. We currently have a working system for storing images on the backend, but it isn't merged with the rest of our frontend yet.


## Part 4: Generative AI Experiment

<!-- For each use of AI this sprint, write an entry in your Sprint Journal including:
- Name the members of your team who tried it.
- Going into this use of AI, what were your goals and expectations?
- Describe the use specifically in detail. How did you prompt the AI, and what was its output?
- How did this use of AI affect your product development or other sprint deliverables? If you integrated any of its output directly into your code base, include a link to a pull request where the generated output can be clearly distinguished.
- Refer back to your answer to question 2. To what extent did the use of AI achieve your goals and conform to your expectations? -->

Each member of the group worked with AI individually for the most part, so we will report on our findings individually.

### Deven

My primary AI experiment was to generate boilerplate code. I was creating the "verification screen," which is just the screen that the user sees after they create an account, but before their account has been verified through email. All that I needed for this page was a very simple UI (just a text display and a button) and a function to send out the email.

I asked ChatGPT to generate the skeleton code for this using the following prompt: 

> can you generate code for a flutter page with a text in the middle of the screen that says "Verification email sent to [email]." and a button below it that says "Resend Email"

Since this was such a simple layout, I was expecting ChatGPT to generate this with ease. I specifically avoided asking for any functionality for the button, and I was expecting the code returned to literally include "[email]" in the middle text. ChatGPT did a decent job of generating the UI elements, but the code it returned had some functionality added that I didn't ask for. It included a method for sending the email, which I then deleted to replace with my own. I did not mention Firebase in my prompt, so ChatGPT had no way to know that I was using that for verification. 

This use of AI sped up the development process a bit by allowing me to easily geneate boilerplate code, but it did not impact my learning in any way. Creating code that like is a tedious task, and it was helpful to have it automated. It achieved my goals, but did not exceed expectations. The code was used in the file ```verification_page.dart``` in the pull request https://github.com/deplatt/GrinNet/pull/26.

In addition to this experiment, I also used AI to help my install Cocoapods, a software needed to run GrinNet on an IOS Emulator on my Mac. This was a tricky installation, so every time I got an error message I fed it directly to ChatGPT. It returned a few commands to run, which was very successful. This was extremely helpful because most of the guides and forums I found online related to this installation assumed that the reader was much more savvy that me. My hope was that using ChatGPT would give me very specific, step-by-step instructions, which it did very well. This did not stunt my learning at all, because I learning how to install Cocoapods is not a skill I desire in any way. If I could have magically clicked a button and had it installed I would have done so in a heartbeat, and this use of AI seemed to be the next best thing.


### Pranav 

Goals / expectations : I used chatgpt o4-mini-high which uses advanced reasoning, and my expectation was that it would give me an in-depth explanation of exactly how our frontend and backend is interacting, specifically in terms of anything relevant to implementing the report button / feature. 

Usage description : The report button was to be placed in the view_post page. However, on my own, I was only able to figure out how to create a report button. I was unable to figure out exactly what information the report button was required to communicate to the backend, and also where that information was in our codebase. So, I gave chatgpt our schema.sql, functions.js, and api_service.dart files and asked it to explain to me in great detail exactly how these files were interacting with our main feed page and consequently the view_post page. It gave me the following key pieces of information (summarized) :
- a description of exactly what 4 pieces of data need to be included in the report button to satisfy the requirements of the sql reports table that already existed (created by Anthon), which were the reported_user, reporter_user, complaint_text, and post_id.
- an explanation of the fact that our current event model (an event in our code represents a "post" in the app's feed) did not create or contain information on neither the post_id nor the reported_user, and also how to change the event model and other parts of the main page to accomodate the two new fields.
- an explanation on how to use firebase to access the id of the current_user (which would be the reporter_user in this context).

Effect on deliverables : chatgpt greatly accelerated the timeline of my part of the sprint deliverable, which was implementing the report button. Had I not been able to use to understand the information being conveyed to and from various parts of our codebase, it would have taken me a lot longer to figure out what exactly I needed to do to actually implement some functionality in the report button. 

Result of goals / expectations : AI fully met my goals an expectations for this use. It explained, in detail and with great clarity, exactly what I was not understanding. It greatly helped me bridge the gap in my knowledge of the backend, and also helped me understand how to restructure our event model to accomodate the requirements of the backend. 

### Jeronimo 

Going into this use of AI, what were your goals and expectations?
I had used AI in the past for different purposes. I like using AI to proofread my english writing, as it is my second langauge and sometime I have some grammatical mistakes that I oversee. I had also used AI for concept explanations, as it breaks it down pretty well and gives useful examples that help ilustrate said concept. Given my past experiences I had high expectations about the possibilities it could bring to improving the process of building GrinNet. I knew that Ai is a great tool, but like any other tool you need to use it correctly to maximize the benefits from it. This meant double checking the information it gave, prompting well structered questions and asking follow up questions. My primary goal for this experiment was to gain better understanding of test creation in flutter. I had been able to built some tests in the previous sprint by following different only guides, yet I didn't comprehend 100% what was going on. So for it I wanted to focus on understanding the test libraries I used in the past, and to see what kind of tests would the AI recommend for a specific file. In this case all the testing was related to the Create_Post.dart. 

Describe the use specifically in detail. How did you prompt the AI, and what was its output?
For the experiment I used ChatGPT 4.0 as it is the one I use more often. 

Here was the first question I prompt: What's the purpose of the mocktail class in flutter? 
ChatGPT responded by clarifying  there was no mocktail class but rather a mocktail package used for Unit testing. I then said "Purpose of         mocktail in Flutter: The mocktail package is used to create mock objects for testing, especially when writing unit or widget tests. It allows     you to simulate the behavior of classes (like services, APIs, or repositories) without relying on their real implementations"  
Why use mocktail? Test isolation: It helps isolate the part of the app you're testing by replacing dependencies with mocks. Avoid side            effects: You can test without making real API calls or database writes. Customize responses: You can control return values and exceptions to      test different scenarios" (ChatGpt). Afterwards it gave me an example of a really simple authorization service that promt for a username and      a password. the it gave me a unit test for that class using the mocktail package. It concluded by saying "So, to sum up: mocktail helps you       mock dependencies in tests to ensure your app's logic is correct without relying on real implementations. Let me know if you want a real-          world test example or want to see how it compares with mockito" (ChatGPT).
After this first intial question, I went deeper and copied the following code that I had written for the testing suite, which was an extract       of the CreatePost_test.dar, and ask him to explain what it meant, as it was used in the guides I read but not fully explained. 

 tell me what this classes are: class MockImagePicker extends Mock implements ImagePicker {}
    class MockXFile extends Mock implements XFile {
      @override
      final String path;
         MockXFile(this.path);
    }
     class MockNavigatorObserver extends Mock implements NavigatorObserver {}
    //class MockFilePicker extends Mock implements FilePickerPlatform {}
    class FakeRoute extends Fake implements Route<dynamic> {}

It replied by answering: 
Great question! These classes are test doubles created using the mocktail package in Dart/Flutter for unit or widget testing. Let’s break them down one by one:

1. class MockImagePicker extends Mock implements ImagePicker {}
This mocks the ImagePicker class (from image_picker package), which is normally used to pick images from the camera or gallery.

✅ Purpose:
Allows you to simulate user selecting an image without opening the camera/gallery in tests.

Mocks the XFile class (also from image_picker or cross_file), which represents a file (like an image).

✅ Purpose:
Simulates an image/file object with a specific path, useful for checking how your code reacts to different image inputs.

3. class MockNavigatorObserver extends Mock implements NavigatorObserver {}
Mocks Flutter’s NavigatorObserver, which watches for navigation events like push/pop.

✅ Purpose:
Useful in widget tests to verify that navigation happened, like:
verify(() => mockObserver.didPush(any(), any())).called(1);

4. //class MockFilePicker extends Mock implements FilePickerPlatform {}
This one is commented out, but it would mock the FilePickerPlatform class from the file_picker package.

✅ Purpose (if enabled):
Simulates file selection without actually opening the file picker dialog.

5. class FakeRoute extends Fake implements Route<dynamic> {}
This is a fake, not a mock.

✅ Purpose:
Fakes are lightweight stand-ins used when a full mock isn’t needed. This one simulates a Route object, often used when mocking navigation behavior in tests.

📌 Important: You usually need to register fakes like this using registerFallbackValue(FakeRoute()) in your test setUp(). (ChatGPT)
 It concluded by giving a summary.

 The final part of my experiment consistent in copying the code in CreatePost.dart and asking ChatGpt to build a test suite. I wanted to compare it to my initial test suite, which was pretty basic as it tested mainly the UI elements were there and doing what they were supposed to do, trying a simulation by just selecting everything, and one where it tested no post was created whenall required fields were empty. This part was the most surprising. The approach it use wasnt completly different other than the one I had used before, yet it made a couple of complex tests in which it checked the backend as well. It made assumptions of how we were storing the information in our databases, for that reason I did not include the tests. It also just gave me the tests, it didnt explain in detail parts of the code as it did when I prompt it for explanations. 

    
How did this use of AI affect your product development or other sprint deliverables? If you integrated any of its  output directly into your code base, include a link to a pull request where the generated output can be clearly distinguished.
As said before, the main takeaway from this experiment was the explanations it gave me. The tests it wrote gave me great ideas for future tests but I did not use them for this sprint, as they were broken, mostly because of a lack of context given to it.
To what extent did the use of AI achieve your goals and conform to your expectations? 
It helped me understand a lot better the different components of unit testing which was my main goal. 

### Anthony

**Goals / expectations :** I used chatgpt 4o, and I expected it to give 
 - A blueprint and steps on how to implement images into our project
 - Write JSDoc documentation for all of our backend 
 - (later on in the project) help me troubleshoot as to why the frontend -> express server connection was seemingly cut. 

**Usage description :** For the blueprint, I pasted my functions.js, app.js, api_service.dart, schema.sql, and create_post.dart files' code into ChatGPT and asked it

"Give suggestions on how to properly send, store, retrieve, and delete posts for our app without changing our current architecture significanly. Write a brief explanation of your suggestions and write some sample blueprint code that will help our implementation of these suggestions. Do not write the entirety of the code. Make sure to tell what libraries/plugins/etc. to use and why we must use these specific tools. "

ChatGPT outputted a blueprint for a new node.js server and told me what to change in create_post.dart to make it work. It also explained to me what each package listed at the top of image_upload_app.js did and why we needed it. It also told me that doing a web app for testing wouldn't work anymore which was definitely useful information (I would have spent hours just wasting my time trying to figure out why the web app stopped working).

For the JSDoc documentation, I pasted in my functions.js, app.js, image_upload_app.js, corresponding test files, and every other js file not listed here, and asked it to "Write detailed JSDoc documentation for the following files. Do not remove any code I have written. For the servers, you must write each of the routes at the top and what they do. " It did exactly what I told it to do, without any deviation. 

For the troubleshooting, I pasted all relevant files (functions.js, app.js, api_service.dart, image_upload_app.js, firebase files, etc.) and the errors Android Studio gave as I tried to create a post with the UI, and told ChatGPT that the image upload was actually working already. Then, I told it "Please explain to me in detail what the issue likely is with my code, and fix any code snippets that would be causing my problems. Do not change any code outside of what you change. ". 

For this prompt, it was absolutely confident that the error was in the create_post endpoint in app.js, and took me on an at least 2 hour wild goose chase, giving me detailed, yet nonsensical, explanations as to why app.js was the problem. The solution, as I figured out on my own, had nothing to do with app.js. Instead, it had to do with create_post.dart not properly retrieving and using the user ID from the PostgreSQL database, which lead to the express server throwing an error because there was no user with their corresponding ID in the PostgreSQL databse (it was initialized as 0 locally; we needed to update this to what the user ID actually is in the PostgreSQL database).

**Effect on deliverables :** I think ChatGPT was useful in teaching me how to implement images in the frontend and was helpful in writing JSDoc documentation, both of which which would be a huge time commitment if we didn't use ChatGPT. I think that the false leads ChatGPT gave me were a bit troublesome and wasted my time this sprint, though. 

**Result of goals / expectations :** AI met my expectations for the image server and documentation part of this project, but disappointed me heavily with the lack of toubleshooting capabilities. 

For the suggestions/blueprint, I feel like it did well. It performed as expected. 

For the JSDoc documentation, I had to do nothing else; ChatGPT did exactly as I asked and its documentation was very detailed and correct from what I saw. 

For the troubleshooting, it did quite terribly. I believe that AI would have performed better if I wrote logging for my servers + logging for the create_post.dart file before asking how to fix my code, though, so a portion of why AI performed poorly on this part is probably partially my fault. 

### Shibam
Goals/Expectations: My goals in this experiment was to test the effectiveness Deepseek especially 'DeepThink R1' for code generation and thinking. Initially, I wanted to find a bug and test how Deepseek would be able to solve it. I had coded most of my skeleton code of profile_page.dart and realized that I had used the placeholder "current_user" to showcase events by the current user. Since this was hardcoded for the specific 'current_user' string, it only showed events in the beginning when create post also created posts with the username of 'current_user' instead of the real username. However, I was unsure of how find the username of the current_user since it was not being currently stored. My first thought was creating a new variable which stores the username. So I wanted to see how deepseek would think about it and whether it would be in line with my own reasoning. 

AI Prompt: 
> Make sure profile_page.dart works for every user so that it is not only for the current placeholder username "current_user" please
Code attached:
profile_page.dart
```
import 'package:flutter/material.dart';
import '../main.dart';

// Profile screen displaying a list of events associated with the user.
class ProfileScreen extends StatelessWidget {
  final List<Event> events;

  const ProfileScreen({super.key, required this.events});

  // Navigation to the settings screen.
  void _navigateToSettingsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter events to only include those created by the current user.
    List<Event> userEvents = events.where((event) => event.username == 'current_user').toList();

    return Scaffold(
      // App bar includes a settings button.
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _navigateToSettingsScreen(context),
          ),
        ],
      ),
      // Display user posts in the same card format as the homepage.
      body: ListView.builder(
        itemCount: userEvents.length,
        itemBuilder: (context, index) {
          final event = userEvents[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: event.profileImageUrl.isNotEmpty
                        ? NetworkImage(event.profileImageUrl)
                        : const AssetImage('assets/placeholder.png') as ImageProvider,
                  ),
                  title: Text(event.username),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(event.text, style: const TextStyle(fontSize: 16)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8.0,
                    children: event.tags.map((tag) => Chip(label: Text(tag))).toList(),
                  ),
                ),
                if (event.imageUrl.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(event.imageUrl),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Placeholder content for settings management.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Change Username and Password Settings Here')),
    );
  }
}
```
global.dart (document where username should be stored)
```
// Class that holds a single variable, the user's ID. Exists once per user.
class Global {
  static int userId = 0;
}
```
login_register_page.dart (document where username can be intialized)
```
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';
import '../api_service.dart';
import 'global.dart';


// This is the page for the user to log in or create their account from. It greets the user upon opening the app
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();  
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  // Text fields for email and password
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  // Function for sending sign-in info to firebase
  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text, 
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  // Function for sending new account info to Firebase and Postgresql.
  // Firebase handles authentication, but we still need postgre to know what user is making a post.
  Future<void> createUserWithEmailAndPassword() async {
    try {
      // Send firebase the email and password to create an account with
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text, 
        password: _controllerPassword.text,
      );
      String username = _controllerEmail.text.split('@')[0];
      
      // Send username to postgre (201 means success)
      final response = await createUser(username, "", "");
      if (response.statusCode != 201) {
        throw Exception('Failed to create user on API');
      }

      final userData = jsonDecode(response.body);
      Global.userId = userData['id'];
    } on FirebaseAuthException catch (e) {
      // Check if there were any errors with firebase (invalid input, etc)
      setState(() {
        errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  Widget _title() {
    return const Text('GrinNet');
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      )
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : '$errorMessage');
  }

  // Button the user clicks to submit their info
  Widget _submitButton() {
    return ElevatedButton(
      onPressed: isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'Login' : 'Register'),
    );
  }

  // Button to switch between logging in and registering
  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'I want to create an account' : 'I already have an account'),
    );
  }

  // UI containing the input fields for users and submiting button
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _entryField('Email', _controllerEmail),
            _entryField('Password', _controllerPassword),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton(),
          ],
        ),
      ),
    );
  }
}
```
api_service.dart (communicates with our backend)
```
import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://localhost:3000';
// const String baseUrl = 'http://10.0.2.2:3000'; // Use this if running on Android emulator

// const String baseUrl = 'http://your-local-ip:3000'; // Otherwise, use this. 
// to get your IP, run "ipconfig (Windows)" or "ifconfig (Mac/Linux)"

/* ========================
   User-related Requests
   ======================== */

// Create a user
Future<http.Response> createUser(String username, String bioText, String profilePicture) {
  return http.post(
    Uri.parse('$baseUrl/users'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'username': username,
      'bioText': "",
      'profilePicture': profilePicture,
    }),
  );
}

// Ban a user
Future<http.Response> banUser(int userId) {
  return http.put(Uri.parse('$baseUrl/users/$userId/ban'));
}

// Warn a user
Future<http.Response> warnUser(int userId) {
  return http.put(Uri.parse('$baseUrl/users/$userId/warn'));
}

// Change bio
Future<http.Response> changeBio(int userId, String newBio) {
  return http.put(
    Uri.parse('$baseUrl/users/$userId/bio'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'newBio': newBio}),
  );
}

// Change profile picture
Future<http.Response> changeProfilePicture(int userId, String newProfilePicture) {
  return http.put(
    Uri.parse('$baseUrl/users/$userId/profile-picture'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'newProfilePicture': newProfilePicture}),
  );
}

// Delete user
Future<http.Response> deleteUser(int userId) {
  return http.delete(Uri.parse('$baseUrl/users/$userId'));
}


/* ========================
   Post-related Requests
   ======================== */

// Create a post
Future<http.Response> createPost(int creator, String postText, String postImage, List<String> postTags) {
  return http.post(
    Uri.parse('$baseUrl/posts'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'creator': creator,
      'postText': postText,
      'postImage': postImage,
      'postTags': postTags,
    }),
  );
}

// Terminate a post
Future<http.Response> terminatePost(int postId) {
  return http.put(Uri.parse('$baseUrl/posts/$postId/terminate'));
}

// Delete a post
Future<http.Response> deletePost(int postId) {
  return http.delete(Uri.parse('$baseUrl/posts/$postId'));
}

// API model for posts
class Post {
  final String creationDate;
  final String creationTime;
  final String postText;
  final String userProfilePicture;
  final String postTags;
  final String postPicture;
  final String posterUsername;

  Post({
    required this.creationDate,
    required this.creationTime,
    required this.postText,
    required this.userProfilePicture,
    required this.postTags,
    required this.postPicture,
    required this.posterUsername,
  });

  // Parse from JSON map
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      creationDate: json['creation_date'],
      creationTime: json['creation_time'],
      postText: json['post_text'],
      userProfilePicture: json['profile_picture'],
      postTags: json['post_tags'].toString(),
      postPicture: json['post_image'],
      posterUsername: json['username'], 
    );
  }
}

// Returns all current posts with associated user data as a List.
Future<List<Post>> getAllPosts() async {
  final response = await http.get(Uri.parse('$baseUrl/posts'));

  if (response.statusCode == 200) {
    // Parse the JSON list and return a list of Post objects
    List<dynamic> postsJson = jsonDecode(response.body);
    List<Post> posts = postsJson.map((json) => Post.fromJson(json)).toList();
    return posts;
  } else {
    throw Exception('Failed to load posts');
  }
}

/* ========================
   Report-related Requests
   ======================== */

// Report a post
Future<http.Response> reportPost({
  required int reportedUser,
  required String complaintText,
  required int postId,
  required int reporterUser,
}) {
  return http.post(
    Uri.parse('$baseUrl/reports'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'reportedUser': reportedUser,
      'complaintText': complaintText,
      'postId': postId,
      'reporterUser': reporterUser,
    }),
  );
}

// Dismiss a report
Future<http.Response> dismissReport(int reportId) {
  return http.delete(Uri.parse('$baseUrl/reports/$reportId'));
}

// Here's an example usage of these http requests from what I understand:

// final response = await createUser("john_doe", "Hi I’m John", "http://example.com/pfp.jpg");

// if (response.statusCode == 201) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text("User created successfully!")),
//   );
// } else {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text("Failed: ${jsonDecode(response.body)['error']}")),
//   );
// }
```
Deepseek Thoughts Output:

```
Okay, so the user wants to make sure that the profile_page.dart works for every user, not just the placeholder "current_user". Let me look at the code provided.

In the ProfileScreen widget, there's a line where they filter events by checking if event.username equals 'current_user'. That's the issue. Instead of hardcoding 'current_user', we need to get the actual logged-in user's username or ID.

Looking at the other files, in login_register_page.dart, when a user registers, they create a username from the email (split at '@'), and store the user's ID in Global.userId. However, the username isn't stored globally; only the user ID is. So we might need to retrieve the username from the backend using the user ID stored in Global.

Wait, but the Event class (probably defined elsewhere) has a username field. When events are fetched, each event should have the poster's username. The problem is that the profile page is filtering events based on the current user's username, which is currently hardcoded.

So the plan is: instead of comparing event.username to 'current_user', we need to compare it to the current user's actual username. But where is the current user's username stored?

Looking at the login process: When a user registers, they generate a username from the email (split at '@'), and send it to the backend via createUser. The backend might store this username. Then, when the user logs in, we probably need to fetch their username from the backend using their user ID, which is stored in Global.userId.

Wait, in the createUser function in login_register_page.dart, after creating the user in Firebase, they send a request to the backend to create a user with the username derived from the email. The response's body includes the user data, which includes the 'id', which is stored in Global.userId. But the username is not stored in Global. So the Global class only has userId, not the username.

Therefore, in the profile page, we can't directly get the current user's username from Global. We need to fetch the username using the userId from the backend.

But how? Because the events are fetched from the backend, each event has a posterUsername (as seen in the Post class in api_service.dart). The Event class (probably similar to Post) has a username field. So when events are loaded, each event already has the username of the user who posted it.

So the current user's username isn't stored in the app's state. Therefore, when the user logs in or registers, after getting the userId, we need to make an API call to get the user's details, including the username, and store that in a global variable.

Looking at the login process: In createUserWithEmailAndPassword, after creating the user, they get the userData from the response, which includes 'id' (stored in Global.userId). However, the createUser API call sends the username to the backend, but the response might not include the username. Wait, the createUser function in api_service.dart sends a POST to /users with username, bioText, and profilePicture. The backend probably returns the created user data, including the username. So in the login_register_page.dart, after creating the user, the response body (userData) might have the username. But in the code, they only extract userData['id'].

So maybe the response from createUser includes the username, but it's not stored in Global. So we need to adjust that.

In the login_register_page.dart's createUserWithEmailAndPassword function:

After creating the user, the response is parsed into userData. Currently, they only set Global.userId = userData['id']. If the userData includes the username, then we should also store that in a global variable, perhaps adding a static variable in the Global class.

So first, modify the Global class to include username. Let's check the existing Global class in global.dart:

class Global {

static int userId = 0;

}

We need to add a static String username. So:

class Global {

static int userId = 0;

static String username = '';

}

Then, in the login_register_page.dart, when creating the user, after getting userData, set both userId and username:

Global.userId = userData['id'];

Global.username = userData['username'];

But wait, does the createUser API response include the username? Looking at the createUser function in api_service.dart, the POST request sends the username, and the backend probably returns the created user object, which includes the username. So assuming the backend returns the user data including the username, we can set Global.username there.

Similarly, when a user logs in (signInWithEmailAndPassword), we need to fetch their username. However, in the current code, when a user logs in, the signInWithEmailAndPassword function only authenticates via Firebase, but doesn't fetch the user's data from the backend. So after Firebase authentication, we need to get the user's ID (from Global.userId?) and then fetch their username from the backend.

Wait, this is a problem. The Firebase user's UID is different from the backend's user ID. Wait, in the createUserWithEmailAndPassword function, after creating the Firebase user, they send a request to create the user in the backend, which returns a userData with 'id'. So the backend's user ID is stored in Global.userId. But how is the Firebase UID linked to the backend's user ID? It seems that when a user registers, they create a Firebase account and a backend user, and the backend's user ID is stored in Global.userId. However, when a user logs in via Firebase, how do we get the corresponding backend user ID?

Hmm, this is a potential issue. Because when a user logs in via Firebase, their Firebase UID is different from the backend's user ID. The current code assumes that the backend's user ID is known, but after login, there's no mechanism to retrieve the backend user's ID based on Firebase's UID. Therefore, this approach may not work for login.

Wait, in the createUserWithEmailAndPassword function, after creating the Firebase user, the code sends a request to the backend to create a user with the username derived from the email. The backend then returns an ID, which is stored in Global.userId. But when a user logs in via Firebase (signInWithEmailAndPassword), how is the backend's user ID retrieved? Because the Firebase UID isn't linked to the backend's user ID. So this is a flaw in the current setup.

Therefore, the current code works when a user registers, because they create both Firebase and backend users, but when logging in, there's no way to get the backend user ID. This is a problem because after login, the Global.userId would still be 0 (the default), which is incorrect.

So this is a critical issue. The code as written won't work for login because the backend user ID is not retrieved upon login. Therefore, when a user logs in, after Firebase authentication, the app needs to fetch the corresponding backend user's ID (and username) based on the Firebase UID or email.

But in the current code, during registration, the backend user is created with the email's username (split at '@'), and presumably, the email is stored in the backend user. So perhaps during login, after Firebase authentication, we can get the user's email from Firebase, then query the backend to find the user with that email (or username derived from email), and then retrieve their ID and username.

Alternatively, the backend might have a way to get the user by email. However, looking at the api_service.dart, there's no function to get a user by email or username. So perhaps the backend API needs to have an endpoint to get a user by email, which is not present in the current code. Therefore, the current setup is incomplete for handling logins.

This is a bigger issue, but given the problem statement is about the profile page, perhaps we can work around this by assuming that during registration, the backend user's ID is stored in Global.userId, and during login, the user's ID is somehow retrieved. However, given the current code's setup, when a user logs in, the Global.userId remains 0, which is incorrect.

But given the scope of the current problem, perhaps we can proceed under the assumption that the Global.userId is correctly set upon login. However, this is not the case in the current code. Therefore, the first step is to ensure that upon login, the user's backend ID is retrieved and stored in Global.userId.

But this requires changes beyond the profile_page.dart. Let me see:

When a user logs in via signInWithEmailAndPassword, the FirebaseAuth sign-in is done, but there's no code to fetch the backend user's ID. So after signing in, the code needs to query the backend to get the user's ID based on the email (since during registration, the username is derived from the email, and the email is known in Firebase).

Assuming that the backend has an endpoint to get a user by email or username, which isn't present in the current api_service.dart. So perhaps the backend's API has an endpoint like /users/by-email/{email}, but it's not implemented here.

Given that the user might not be able to modify the backend API, perhaps we need an alternative approach. Alternatively, during registration, the Firebase user's UID is sent to the backend as part of the user creation, allowing linking the two. But this would require modifying the createUser function in api_service.dart to include the Firebase UID.

But given the current code, perhaps the login_register_page.dart's signInWithEmailAndPassword function needs to, after successful Firebase login, get the user's email, then call an API endpoint to get the backend user by email, and set Global.userId and Global.username accordingly.

But since the current api_service.dart doesn't have such a function, this is a problem.

Given the time constraints and the problem's scope (focus on profile_page.dart), perhaps the user is using the username stored in the Event class (which comes from the backend) and the profile page is supposed to show events for the current user, whose username is stored somewhere.

Alternatively, maybe the current code has a way to track the current user's username, but it's not implemented.

Given that in the login_register_page.dart, during registration, the username is generated as the email's prefix and sent to the backend. The backend's response includes the user's ID but not the username. So the code currently doesn't store the username in Global.

Therefore, to get the current user's username, the app would need to fetch it from the backend using the user ID stored in Global.userId.

But again, the api_service.dart doesn't have a function to get a user by ID. However, looking at the API functions, there's a changeBio and changeProfilePicture which use the user ID. So perhaps there's an endpoint to get a user by ID.

Assuming that there's a GET /users/{userId} endpoint that returns the user's data, including username, then we can add a function in api_service.dart to fetch the user.

But since the user hasn't provided that, maybe we need to assume that such an endpoint exists or modify the code to include it.

Alternatively, during registration, the username is known (from splitting the email), so perhaps we can store that in Global.username at registration time.

Looking back at the createUserWithEmailAndPassword function in login_register_page.dart:

After creating the user in the backend, the username is generated as the email's prefix (split at '@'). So during registration, the username is known, and can be stored in Global.username. So in the code:

String username = _controllerEmail.text.split('@')[0];

...

Global.userId = userData['id'];

// Add this line:

Global.username = username;

That way, during registration, the Global.username is set. Then, in the profile page, we can use Global.username instead of 'current_user'.

However, during login, the username isn't set. Because when a user logs in, the signInWithEmailAndPassword function doesn't retrieve the username from the backend. So in this case, after a user logs in, the app needs to fetch the username from the backend using the user ID (which is stored in Global.userId), but how is Global.userId set during login?

Ah, this is the crux of the problem. During registration, Global.userId is set because the backend returns the user ID. But during login, after Firebase authentication, the app doesn't set Global.userId. Therefore, after login, Global.userId remains 0, which is incorrect.

So to fix this, during login, after Firebase authentication, the app needs to get the user's email from Firebase, query the backend to find the user with that email (or the derived username), then set Global.userId and Global.username accordingly.

But given the current backend setup, there's no API endpoint to get a user by email or username. So perhaps the code is designed such that the email's username (split at '@') is the same as the username in the backend, and during login, the app can generate the username again from the email and use that.

Alternatively, during login, after getting the email from FirebaseAuth, split it to get the username, then use that to fetch the user's ID from the backend.

But again, without an API endpoint to get a user by username, this isn't possible.

This suggests that the current code has a flaw in handling user login, which affects the profile page's functionality.

But given the problem's scope is to modify the profile page to work for any user, not just 'current_user', perhaps the immediate fix is to use the Global.username variable, which should be set during registration. However, during login, this variable is not set, leading to issues.

Alternatively, perhaps the Event class's username is the same as the email's prefix, so during login, the app can generate the username from the user's email (obtained from FirebaseAuth) and use that to filter events.

But this approach would require accessing the current user's email from FirebaseAuth, which is possible.

So, to proceed:

1. In the profile_page.dart, instead of filtering by 'current_user', we need to get the current user's username.

But how?

If during registration, the username is stored in Global.username, then during login, we need to set it as well.

But during login, after Firebase sign-in, we can get the user's email, split it to get the username, and set Global.username = that value.

However, this assumes that the username in the backend is exactly the email's prefix, which is how it's generated during registration. So during login, the username can be derived the same way.

Therefore, in the signInWithEmailAndPassword function in login_register_page.dart, after successful authentication, we can get the user's email, split it to get the username, and set Global.username.

But wait, the Firebase user's email can be accessed via FirebaseAuth.instance.currentUser?.email. So after signing in, perhaps we can do that.

But the current signInWithEmailAndPassword function doesn't do that. Let's see:

In the signInWithEmailAndPassword function:

try {

await Auth().signInWithEmailAndPassword(

email: _controllerEmail.text,

password: _controllerPassword.text,

);

} on FirebaseAuthException catch (e) {

...

}

After successful sign-in, the FirebaseAuth.instance.currentUser should be set. So in the signInWithEmailAndPassword function, after successful sign-in, we can get the email from _controllerEmail.text (since the user entered it), split it to get the username, and set Global.username = that username. Then, perhaps send a request to the backend to get the user's ID based on the username.

But again, without an API endpoint to get user by username, this isn't possible. Alternatively, during login, after getting the username, the app can set Global.username, and assume that the user ID is correctly retrieved elsewhere.

Alternatively, maybe during login, the app needs to call an API endpoint to get the user's ID based on the username (derived from email), and set Global.userId and Global.username accordingly.

But given the current code's setup, during registration, the backend user is created with the username derived from email, and the user ID is stored in Global. During login, the app doesn't do this, leading to incorrect Global.userId.

Therefore, the solution requires modifying the login process to fetch the user's ID from the backend, and set Global.userId and Global.username.

Assuming that the backend has an endpoint to get a user by username, which is /users/username/{username}, which returns the user's data including ID.

So adding a function in api_service.dart:

Future<http.Response> getUserByUsername(String username) {

return http.get(Uri.parse('$baseUrl/users/username/$username'));

}

Then, in the signInWithEmailAndPassword function, after successful Firebase login:

1. Get the email from _controllerEmail.text.

2. Split to get username.

3. Call getUserByUsername(username).

4. If successful, parse the response to get user ID and set Global.userId and Global.username.

But this requires modifying the login_register_page.dart's signInWithEmailAndPassword function.

However, since the user's question is focused on the profile_page.dart, perhaps we can find a workaround.

Alternatively, during login, the username can be derived from the email (as during registration), and stored in Global.username. Then, in the profile page, instead of using 'current_user', we use Global.username.

But how is Global.username set during login?

In the current code, during registration, after creating the user, the username is known (split from email) and stored in Global.username (if we modify the code as suggested earlier).

During login, the username can be derived from the email entered in the login form (_controllerEmail.text), split to get the username, and set Global.username = that value.

So in the signInWithEmailAndPassword function, after successful authentication:

String username = _controllerEmail.text.split('@')[0];

Global.username = username;

But this is only valid if the backend uses the same logic to generate usernames. If a user changes their username via some other method, this would break. But based on the current code, during registration, the username is derived from email, and there's no way to change it (the SettingsScreen is a placeholder), so this might be acceptable.

Therefore, in the signInWithEmailAndPassword function, after successful sign-in, we can set Global.username to the email's prefix.

So modifying the signInWithEmailAndPassword function:

Future<void> signInWithEmailAndPassword() async {

try {

await Auth().signInWithEmailAndPassword(

email: _controllerEmail.text,

password: _controllerPassword.text,

);

// After successful login, set the username from email

String username = _controllerEmail.text.split('@')[0];

Global.username = username;

// Also, need to fetch the user's ID from the backend based on username

// But without an API endpoint, this is not possible.

// So this approach is flawed.

} on FirebaseAuthException catch (e) {

setState(() {

errorMessage = e.message;

});

}

}

But without the user's ID, which is required for other parts of the app (like creating posts), this approach won't work. Hence, during login, the app needs to fetch the user's ID from the backend.

But without an API endpoint to get a user by username or email, this can't be done. This indicates a larger architectural issue.

Given the time constraints and the problem's scope, perhaps the immediate fix is to use the username derived from the email during login and registration and set it in Global.username, then use that in the profile page.

So steps:

1. In the Global class, add a static variable for username.

global.dart:



class Global {

static int userId = 0;

static String username = '';

}



2. In login_register_page.dart's createUserWithEmailAndPassword function, after getting userData, set Global.username:

...

Global.userId = userData['id'];

Global.username = username; // username was derived from email earlier

...

3. In the signInWithEmailAndPassword function, after successful login, set Global.username based on the email entered:

...

} on FirebaseAuthException catch (e) {

...

}

// After successful login

String username = _controllerEmail.text.split('@')[0];

Global.username = username;

But this assumes that the username in the backend matches the email's prefix. However, during login, we don't fetch the user's ID from the backend, so Global.userId remains 0. This is a problem because other parts of the app (like creating posts) rely on Global.userId.

But according to the api_service.dart's createPost function, it requires the creator's ID. So during post creation, the app uses Global.userId. Therefore, during login, we need to set Global.userId correctly.

Therefore, during login, after deriving the username from the email, we need to call an API endpoint to get the user's ID by username and set Global.userId.

Assuming there's an endpoint like /users/username/{username}, which returns the user's data including ID.

So adding a function in api_service.dart:

Future<http.Response> getUserByUsername(String username) async {

return await http.get(Uri.parse('$baseUrl/users/username/$username'));

}

Then, in the signInWithEmailAndPassword function:

After setting username from email:

final response = await getUserByUsername(username);

if (response.statusCode == 200) {

final userData = jsonDecode(response.body);

Global.userId = userData['id'];

Global.username = userData['username'];

} else {

// handle error

}

But this requires the backend to have such an endpoint. Since the user's code doesn't include this, it's an assumption.

Assuming that such an endpoint exists, the code can proceed.

But since the user hasn't provided that, this might not be feasible.

Given all these complexities and the original problem being about the profile_page.dart, perhaps the immediate solution is to use the Global.username variable, which is set during registration and login (via email split), and in the profile page, filter events where event.username == Global.username.

So modifying the profile_page.dart's line where it filters events:

Change:

List<Event> userEvents = events.where((event) => event.username == 'current_user').toList();

To:

List<Event> userEvents = events.where((event) => event.username == Global.username).toList();

But for this to work, Global.username must be set correctly.

Therefore, the steps are:

1. Add a static username variable to the Global class.

2. During registration, set Global.username to the derived username.

3. During login, set Global.username to the derived username from the email.

4. In the profile page, use Global.username to filter events.

Thus, the main changes are in login_register_page.dart and profile_page.dart.

Now, in the profile_page.dart, replace 'current_user' with Global.username.

Also, make sure to import global.dart in profile_page.dart.

So adding import statement in profile_page.dart:

import 'global.dart';

Then, in the build method:

List<Event> userEvents = events.where((event) => event.username == Global.username).toList();

But also need to handle the case where Global.username is empty or not set. However, assuming that the user is logged in, Global.username should be set.

Therefore, the final code for ProfileScreen in profile_page.dart would be:

...

import '../global.dart';

class ProfileScreen extends StatelessWidget {

...

@override

Widget build(BuildContext context) {

List<Event> userEvents = events.where((event) => event.username == Global.username).toList();

...

}

}
```
Actual Deepseek Output:
```
To modify the profile_page.dart to work for every user by using their actual username instead of the placeholder "current_user", follow these steps:

Step 1: Update the Global Class
Add a static username variable to store the current user's username globally.

global.dart

dart
class Global {
  static int userId = 0;
  static String username = '';
}
Step 2: Set Username During Registration
When a user registers, store their username in Global.username.

login_register_page.dart

dart
// Inside createUserWithEmailAndPassword function
String username = _controllerEmail.text.split('@')[0];
// After creating the user in the backend
Global.userId = userData['id'];
Global.username = username; // Add this line
Step 3: Set Username During Login
When a user logs in, derive the username from their email and store it in Global.username.

login_register_page.dart

dart
// Modify the signInWithEmailAndPassword function
Future<void> signInWithEmailAndPassword() async {
  try {
    await Auth().signInWithEmailAndPassword(
      email: _controllerEmail.text, 
      password: _controllerPassword.text,
    );
    // Set username from email after successful login
    String username = _controllerEmail.text.split('@')[0];
    Global.username = username;
  } on FirebaseAuthException catch (e) {
    setState(() {
      errorMessage = e.message;
    });
  }
}
Step 4: Update Profile Page to Use Global Username
Replace the hardcoded "current_user" with Global.username to filter events for the logged-in user.

profile_page.dart

dart
import 'package:flutter/material.dart';
import '../main.dart';
import '../global.dart'; // Add this import

class ProfileScreen extends StatelessWidget {
  final List<Event> events;

  const ProfileScreen({super.key, required this.events});

  // ... existing code ...

  @override
  Widget build(BuildContext context) {
    // Use Global.username to filter events
    List<Event> userEvents = events.where((event) => event.username == Global.username).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _navigateToSettingsScreen(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: userEvents.length,
        itemBuilder: (context, index) {
          // ... rest of the build method remains the same ...
        },
      ),
    );
  }
}
Notes:
Ensure Backend Compatibility: The backend should correctly associate events with the username stored in Global.username.

Handle User ID: For full functionality, ensure Global.userId is set correctly during login by fetching it from the backend using the username or email. This might require additional API endpoints.

Error Handling: Consider cases where Global.username might be empty and handle them appropriately (e.g., redirect to login).

By following these steps, the profile page will display events specific to the logged-in user based on their username stored globally.
```


This did completely fix the problem in the way I intended it to be. It was really interesting to see how DeepThink R1 showcased its thoughts about the code that I submitted it to it and made assumptions regarding certain code. Although I had prompted the AI with the files that I knew needed to be changed, it made the changes that I thought it would ask me to. It just made it more efficient for me to complete profile_page development. I also tested it out with just my profile_page.dart file and the same prompt and it had given me a more simple change but incomplete. 
```
  const ProfileScreen({
    super.key,
    required this.events,
    required this.username,  // Make it required
  });
  @override
  Widget build(BuildContext context) {
    // Use dynamic username for filtering
    List<Event> userEvents = events.where((event) => event.username == username).toList();
```

The use of AI to achieve my goals conformed to my expectations since it did as I thought it would. I was sure that we would need to add a username variable in our global file which would make it easier for every file to use that if needed. AI was very helpful as it fixed the bug that I had asked it to. It also was able to properly analyse and reach a solution that was considerate of the information that I had given to it. It was interesting since I also tested this later in a different chat with the same prompt and only the first file and it had just created a parameter for username and nothing else. Although this was a solution that could be implemented, it is not the one I had hoped Deepseek would answer with, since it would mean I would still have to code the username variable in global and create changes in login_register page for me to access it here. Giving Deepseek more information initially had made it understand how the code worked and able to add the variable where I wanted it to, along with other changes required for the code to work. From this experiment I learnt that AI conforms to my expectations only when I either explain it enough or give it enough background code to understand the problem completely.  

