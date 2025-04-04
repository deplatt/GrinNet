import 'package:flutter/material.dart';

void main() {
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
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventFeedScreen()),
    );
  }

  void _signUp() {
    // Implement sign-up functionality
  }

  void _adminLogin() {
    // Implement admin login functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GrinNet Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text('Login')),
            ElevatedButton(onPressed: _signUp, child: Text('Sign Up')),
            TextButton(onPressed: _adminLogin, child: Text('Admin Login')),
          ],
        ),
      ),
    );
  }
}

class Event {
  final String username;
  final String imageUrl;
  final String text;
  final List<String> tags;

  Event({required this.username, required this.imageUrl, required this.text, required this.tags});
}

class EventFeedScreen extends StatefulWidget {
  @override
  _EventFeedScreenState createState() => _EventFeedScreenState();
}

class _EventFeedScreenState extends State<EventFeedScreen> {
  final List<Event> events = [
    Event(
      username: 'mukhopad2',
      imageUrl: 'https://via.placeholder.com/150',
      text: 'Join us for Bollywood Gardner at Main Hall Basement!',
      tags: ['Music', 'Culture'],
    ),
    Event(
      username: 'sportsguy101',
      imageUrl: 'https://via.placeholder.com/150',
      text: 'Basketball Game: Grinnell vs. Iowa Hawks',
      tags: ['Sports', 'Gaming'],
    ),
    Event(
      username: 'bhandari2',
      imageUrl: 'https://via.placeholder.com/150',
      text: 'Art Exhibition at JRC',
      tags: ['Art', 'Exhibition'],
    ),
    Event(
      username: 'platt',
      imageUrl: 'https://via.placeholder.com/150',
      text: 'Prof Talk: Ethics of AI',
      tags: ['Technology', 'Talk'],
    ),
    Event(
      username: 'saso',
      imageUrl: 'https://via.placeholder.com/150',
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
            child: ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                Event event = filteredEvents[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(event.imageUrl),
                        ),
                        title: Text(event.username),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(event.text, style: TextStyle(fontSize: 16)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 8.0,
                          children:
                              event.tags
                                  .map((tag) => Chip(label: Text(tag)))
                                  .toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
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

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  void _submitPost() {
    if (_textController.text.isEmpty || _tagsController.text.isEmpty || _imageUrlController.text.isEmpty || _usernameController.text.isEmpty) {
      return;
    }

    List<String> tags = _tagsController.text.split(',').map((tag) => tag.trim()).toList();

    final newEvent = Event(
      username: _usernameController.text,
      imageUrl: _imageUrlController.text,
      text: _textController.text,
      tags: tags,
    );

    Navigator.pop(context, newEvent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            TextField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Post Text'),
            ),
            TextField(
              controller: _tagsController,
              decoration: InputDecoration(labelText: 'Tags (comma-separated)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _submitPost, child: Text('Submit Post')),
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
