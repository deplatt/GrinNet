import 'package:flutter/material.dart';
import '../main.dart';
import '../api_service.dart';
import '../auth.dart';
import 'global.dart';
import 'dart:convert';
import '../widget_tree.dart';

/// Profile Screen displays authenticated user's profile information and their events.
/// 
/// [events] - List of all events in the system used to filter user-specific events
/// 
/// Features:
/// - User profile header with avatar and bio
/// - List of events created by the user
/// - Settings navigation
/// - Loading state handling
class ProfileScreen extends StatefulWidget {
  final List<Event> events;

  const ProfileScreen({super.key, required this.events});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;  // Stores fetched user data from API
  bool isLoading = true;           // Tracks loading state of user data

  @override
  void initState() {
    super.initState();
    _fetchUserData();  // Initiate user data fetch when widget initializes
  }

  /// Fetches user data from API using the globally stored user ID
  /// Handles both success and error states, updates loading status
  Future<void> _fetchUserData() async {
    try {
      final response = await getUser(Global.userId);
      if (response.statusCode == 200) {
        setState(() {
          userData = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  /// Navigates to Settings screen using MaterialPageRoute
  void _navigateToSettingsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter events to only include those created by the current user
    List<Event> userEvents = widget.events
        .where((event) => event.username == Global.username)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          // Settings icon button
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _navigateToSettingsScreen(context),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())  // Loading state
          : SingleChildScrollView(  // Content when data is loaded
              child: Column(
                children: [
                  // Profile Header Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16)),
                    ),
                    child: Column(
                      children: [
                        // Profile Avatar
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: (userData?['profilePicture']?.isNotEmpty ?? false)
                              ? NetworkImage(userData!['profilePicture'])
                              : const AssetImage('assets/placeholder.png') as ImageProvider,
                        ),
                        const SizedBox(height: 16),
                        // Username Display
                        Text(
                          Global.username,
                          style: const TextStyle(
                              fontSize: 24, 
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        // Bio Display
                        Text(
                          userData?['bioText'] ?? 'No bio provided',
                          style: const TextStyle(
                              fontSize: 16, 
                              color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  // Events List Header
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Your Events', 
                        style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold)),
                  ),
                  // Events List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userEvents.length,
                    itemBuilder: (context, index) {
                      final event = userEvents[index];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Event Header with User Avatar
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: event.profileImageUrl.isNotEmpty
                                    ? NetworkImage(event.profileImageUrl)
                                    : const AssetImage('assets/placeholder.png') 
                                        as ImageProvider,
                              ),
                              title: Text(event.username),
                            ),
                            // Event Description
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(event.text, 
                                  style: const TextStyle(fontSize: 16)),
                            ),
                            // Event Tags
                            if (event.tags.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Wrap(
                                  spacing: 8,
                                  children: event.tags.map((tag) => Chip(
                                    label: Text(tag),
                                    backgroundColor: Colors.grey[800],
                                  )).toList(),
                                ),
                              ),
                            // Event Image
                            if (event.imageUrl.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  event.imageUrl,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

/// Simple Settings Screen placeholder 
/// 
/// Currently displays static text. Should be expanded to include:
/// - Username/password changes
/// - Profile management features
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