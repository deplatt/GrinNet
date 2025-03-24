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
      theme: ThemeData(primarySwatch: Colors.blue),
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
    // need to impleement actual login functionality
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventFeedScreen()),
    );
  }

  void _signUp() {
    // need to implement sign-up functionality
  }

  void _adminLogin() {
    // need to implement admin login functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GrinNET')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Text(
              'Welcome to GrinNET, a social media app made for Grinnellians by Grinnellians!',
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text('Login')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _signUp, child: Text('Sign Up')),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _adminLogin, child: Text('Admin Login')),
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

  Event({
    required this.username,
    required this.imageUrl,
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

  @override
  Widget build(BuildContext context) {
    List<Event> filteredEvents =
        events.where((event) {
          return event.text.toLowerCase().contains(searchQuery.toLowerCase()) ||
              event.tags.any(
                (tag) => tag.toLowerCase().contains(searchQuery.toLowerCase()),
              ) ||
              event.username.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Campus Events')),
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
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {}, // have to implement post creation
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {}, // have to implement refresh functionality
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {}, // have to implement profile navigation
            ),
          ],
        ),
      ),
    );
  }
}
