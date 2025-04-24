import 'package:flutter/material.dart';
import '../main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_register_page.dart';



class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String? username;

  @override
  void initState() {
  super.initState();
  final user = FirebaseAuth.instance.currentUser;
  setState(() {
    username = user?.displayName ?? user?.email?.split('@')[0] ?? 'Username';
  });
}

  void _navigateTo(String route) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Navigate to $route")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
  padding: const EdgeInsets.all(16.0),
  children: [
    // ==== PROFILE SECTION ====
    Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Pic
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('assets/placeholder.png'), // Replace with user image
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.camera_alt, size: 18, color: Colors.blue),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Change profile picture")),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Username
             Text(
              username ?? 'Loading...',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // Bio
            TextField(
              maxLength: 200,
              maxLines: 2,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Short Bio',
                hintText: 'Tell us about yourself...',
              ),
              onChanged: (text) {
                // Save bio
              },
            ),
          ],
        ),
      ),
    ),

    const SizedBox(height: 24),

    // ==== GENERAL SECTION ====
    const Text("General", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

    const SizedBox(height: 12),

    SwitchListTile(
      title: const Text("Dark Mode"),
      value: _isDarkMode,
      onChanged: (value) {
        setState(() {
          _isDarkMode = value;
        });
      },
    ),
    SwitchListTile(
      title: const Text("Enable Notifications"),
      value: _notificationsEnabled,
      onChanged: (value) {
        setState(() {
          _notificationsEnabled = value;
        });
      },
    ),
    ListTile(
      title: const Text("Change Password"),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Navigate to Change Password")),
        );
      },
    ),
    ListTile(
      title: const Text("Delete Account"),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => _navigateTo("/language-settings"),
    ),
    ListTile(
      title: const Text("Privacy Policy"),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => _navigateTo("/privacy-policy"),
    ),
    ListTile(
      title: const Text("Log Out"),
      leading: const Icon(Icons.logout, color: Colors.red),
      onTap: () async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Logout failed: $e")),
    );
  }
},
),
  ],
),
);
  }
}