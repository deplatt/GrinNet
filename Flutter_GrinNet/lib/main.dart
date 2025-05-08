import 'widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'pages/create_post.dart';
import 'pages/view_post.dart';
import 'pages/login_register_page.dart';
import 'api_service.dart';
import 'pages/profile_page.dart';

// The main entry point for the application
// Before running the app, we first check that we are connected to Firebase
Future<void> main() async {
  // Ensuring that the widgets and Firebase are initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();
  // Initializing Firebase with the current platform's options.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Runs the main app widget.
  runApp(GrinNetApp());
}

// Main app widget which sets up the overall MaterialApp.
class GrinNetApp extends StatelessWidget {
  const GrinNetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GrinNet',
      // Sets the app to use a dark theme with a black background.
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.grey[900],
        appBarTheme: AppBarTheme(backgroundColor: Colors.grey[850]),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.grey[800]!,
          labelStyle: TextStyle(color: Colors.white),
          selectedColor: Colors.blueGrey,
          secondarySelectedColor: Colors.blueGrey,
        ),
      ),
      // Sets the starting point of the app to WidgetTree.
      home: const WidgetTree(),
    );
  }
}

// Event model representing a post in the event feed.
class Event {
  final String username;
  final String imageUrl;    // Event's image
  final String profileImageUrl;  // User's profile picture
  final String text;        // Event description text.
  final List<String> tags;       // List of tags associated with the event.
  final int postId;         // postId for report feature
  final int userId;         // userId for report feature


  Event({
    required this.username,
    required this.imageUrl,
    required this.profileImageUrl,
    required this.text,
    required this.tags,
    required this.postId,
    required this.userId,
  });
}

// Stateful widget that manages and displays the event feed.
class EventFeedScreen extends StatefulWidget {
  const EventFeedScreen({super.key});

  @override
  _EventFeedScreenState createState() => _EventFeedScreenState();
}

class _EventFeedScreenState extends State<EventFeedScreen> {
  List<Event> events = [];
  // holds the current search query text
  String searchQuery = '';
  Set<String> selectedTags = {}; // Tracks selected tags for filtering

  // Our predefined list of tags 
  final List<String> allTags = [
    'Sports', 'Culture', 'Games', 'SEPCs', 'Dance', 'Music', 'Food', 'Social', 'Misc'
  ];

  Future<void> _loadPosts() async {
    try {
      List<Post> posts = await getAllPosts();
      List<Event> loadedEvents = posts.map((post) {
        List<String> tags = post.postTags.split(',');
        return Event(
          username: post.posterUsername,
          imageUrl: post.postPicture.isNotEmpty ? '$imageBaseUrl/${post.postPicture}' : '',
          profileImageUrl: post.userProfilePicture.isNotEmpty ? '$imageBaseUrl/${post.userProfilePicture}' : '',
          text: post.postText,
          tags: tags,
          postId: post.post_id,
          userId: post.creator,
        );
      }).toList();

      setState(() {
        events = loadedEvents;
      });
    } catch (e) {
      print("Error loading posts: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  

  void _navigateToCreatePostScreen() async {
    final didCreatePost = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePostScreen()),
    );

    if (didCreatePost == true) {
      // Show loading indicator while waiting
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Short delay to give backend time to save image + data
      await Future.delayed(Duration(seconds: 1));

      // Refresh posts from backend
      await _loadPosts();

      // Dismiss loading indicator
      Navigator.pop(context);
    }
  }

  void _navigateToProfileScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen(events: events)),
    );
  }

  @override
  Widget build(BuildContext context) {
     // Filter events based on search query and selected tags
    List<Event> filteredEvents = events.where((event) {
      // Check if event matches search query
      bool matchesSearch = event.text.toLowerCase().contains(searchQuery.toLowerCase()) ||
          event.tags.any((tag) => tag.toLowerCase().contains(searchQuery.toLowerCase())) ||
          event.username.toLowerCase().contains(searchQuery.toLowerCase());
      
      // Check if event has any selected tags (if tags are selected)
      bool matchesTags = selectedTags.isEmpty || 
          event.tags.any((tag) => selectedTags.contains(tag));
      
      return matchesSearch && matchesTags;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Events'),
      ),
      // Main screen body containing search, list of event cards, etc.
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Events',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              // Update search query as the user types.
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          // Tag Filter Chips
          SizedBox(
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: allTags.map((tag) {
                  bool isSelected = selectedTags.contains(tag);
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: FilterChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (selected) => setState(() {
                        if (selected) {
                          selectedTags.add(tag);
                        } else {
                          selectedTags.remove(tag);
                        }
                      }),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                Event event = filteredEvents[index];
                // We wrap the event card in an InkWell for touch detection.
                // When we wrap a widget in an Inkwell, our event card in this instance,
                // it makes the entire card react visually and functionally when the user 
                // clicks on it, which allows us to navigate to the view_post page for that event.
                return InkWell(
                  onTap: () {
                    // When tapped, navigate to the ViewPostScreen,
                    // passing the tapped event as an argument.
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewPostScreen(event: event)),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            // Displays profile image from network or a placeholder if unavailable.
                            backgroundImage: event.profileImageUrl.isNotEmpty
                                ? NetworkImage(event.profileImageUrl)
                                : AssetImage('assets/placeholder.png') as ImageProvider,
                          ),
                          title: Text(event.username),
                        ),
                        // Display event description text.
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(event.text, style: TextStyle(fontSize: 16)),
                        ),
                        // Display tags as chips.
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            spacing: 8.0,
                            children: event.tags.map((tag) => Chip(label: Text(tag))).toList(),
                          ),
                        ),
                        // If an image URL is provided, display the image below the description.
                        if (event.imageUrl.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(event.imageUrl),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Bottom navigation bar containing actions for creating posts, refreshing feed, and profile navigation.
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Icon(Icons.add), onPressed: _navigateToCreatePostScreen),
            IconButton(icon: Icon(Icons.refresh), onPressed: _loadPosts),
            IconButton(icon: Icon(Icons.person), onPressed: _navigateToProfileScreen),
          ],
        ),
      ),
    );
  }
}
