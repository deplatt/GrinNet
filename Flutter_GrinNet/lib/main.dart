import 'widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'pages/create_post.dart';
import 'pages/view_post.dart';

// Before running the app, we first check that we are connected to Firebase
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(GrinNetApp());
}

class GrinNetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GrinNet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WidgetTree(),
    );
  }
}

class Event {
  final String username;
  final String imageUrl;  // Event's image
  final String profileImageUrl; // User's profile picture
  final String text;
  final List<String> tags;

  Event({
    required this.username,
    required this.imageUrl,
    required this.profileImageUrl,
    required this.text,
    required this.tags,
  });
}

class EventFeedScreen extends StatefulWidget {
  @override
  _EventFeedScreenState createState() => _EventFeedScreenState();
}
class _EventFeedScreenState extends State<EventFeedScreen> {
  final List<Event> events = [
    // removing placeholder images to ensure image is only displayed if it exists.
    // image exists check on line 234
    Event(
      username: 'mukhopad2',
      imageUrl: '',
      profileImageUrl: '',
      text: 'Join us for Bollywood Gardner at Main Hall Basement!',
      tags: ['Music', 'Culture'],
    ),
    Event(
      username: 'sportsguy101',
      imageUrl: '',
      profileImageUrl: '',
      text: 'Basketball Game: Grinnell vs. Iowa Hawks',
      tags: ['Sports', 'Gaming'],
    ),
    Event(
      username: 'bhandari2',
      imageUrl: '',
      profileImageUrl: '',
      text: 'Art Exhibition at JRC',
      tags: ['Art', 'Exhibition'],
    ),
    Event(
      username: 'platt',
      imageUrl: '',
      profileImageUrl: '',
      text: 'Prof Talk: Ethics of AI',
      tags: ['Technology', 'Talk'],
    ),
    Event(
      username: 'saso',
      imageUrl: '',
      profileImageUrl: '',
      text: 'Diwali',
      tags: ['Culture', 'Music', 'Dance'],
    ),
  ];

  String searchQuery = '';

  void _navigateToCreatePostScreen() async {
    final newEvent = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePostScreen()),
    );

    if (newEvent != null) {
      setState(() {
        events.insert(0, newEvent);
      });
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
    // Filter the events based on the search query.
    List<Event> filteredEvents = events.where((event) {
      return event.text.toLowerCase().contains(searchQuery.toLowerCase()) ||
          event.tags.any((tag) => tag.toLowerCase().contains(searchQuery.toLowerCase())) || 
          event.username.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Events'),
      ),
      body: Column(
        children: [
          // Search input to filter events.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Events',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            // ListView.builder displays the list of filtered event cards.
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
                        // ListTile shows the user's avatar and username.
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(event.profileImageUrl),
                          ),
                          title: Text(event.username),
                        ),
                        // Display the event's description text.
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(event.text, style: TextStyle(fontSize: 16)),
                        ),
                        // Display the category tags as Chips.
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            spacing: 8.0,
                            children: event.tags.map((tag) => Chip(label: Text(tag))).toList(),
                          ),
                        ),
                        // If an image URL is provided, display the image.
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
      // A bottom navigation bar with buttons for additional actions.
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Icon(Icons.add), onPressed: _navigateToCreatePostScreen),
            IconButton(icon: Icon(Icons.refresh), onPressed: () => setState(() {})),
            IconButton(icon: Icon(Icons.person), onPressed: _navigateToProfileScreen),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final List<Event> events;

  ProfileScreen({required this.events});

  void _navigateToSettingsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(icon: Icon(Icons.settings), onPressed: () => _navigateToSettingsScreen(context)),
        ],
      ),
      body: ListView(
        children: events.map((event) => ListTile(
          title: Text(event.text),
          subtitle: Text('Posted by ${event.username}'),
        )).toList(),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(child: Text('Change Username and Password Settings Here')),
    );
  }
}
