import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_register_page.dart';
import 'package:provider/provider.dart';
import '../Theme_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';



class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = false;
  String? username;
  File? _profileImage;

@override
void initState() {
  super.initState();
  try {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      username = user?.displayName ?? user?.email?.split('@')[0] ?? 'Username';
    });
  } catch (e) {
    // In widget test (no Firebase), fallback username for testing
    username = 'Username';
  }
}


  void _navigateTo(String route) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Navigate to $route")),
    );
  }

  void _showChangePasswordDialog() {
  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPassword,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Current Password"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPassword,
              obscureText: true,
              decoration: const InputDecoration(labelText: "New Password"),
            ),
            const SizedBox(height: 10),
            const Text(
              "Remember: Password must be at least 6 characters.",
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("Update"),
            onPressed: () async {
              Navigator.of(context).pop();
              await _changePassword(
                currentPassword.text,
                newPassword.text,
              );
            },
          ),
        ],
      );
    },
  );
}

// Pop up dialog for deleting account
// This dialog will ask for the password to confirm the deletion
// and will delete the account if the password is correct
// It will also log out the user and navigate to the login page
void _showDeleteAccountDialog() {
  final TextEditingController _passwordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Delete Account"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Please confirm your password to delete your account. This action is irreversible."),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog first
              await DeleteAccount(_passwordController.text);
            },
          ),
        ],
      );
    },
  );
}

Future<void> _pickProfileImage() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  
  if (pickedFile != null) {
    setState(() {
      _profileImage = File(pickedFile.path);
    });
  }
}



Future<void> _changePassword(String currentPassword, String newPassword) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null || user.email == null) return;

  try {
    // Reauthenticate first
    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(cred);

    // Then update password
    await user.updatePassword(newPassword);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password updated successfully!")),
    );
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${e.message}")),
    );
  }
}


Future<void> DeleteAccount(String password) async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.email != null) {
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(cred);

      // ADD CODE TO DELETE USER DATA FROM DATABASE HERE
      await user.delete();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${e.message}")),
    );
  }
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
                   backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!) // Use the selected image
                     : const AssetImage('images/BlankProfile.png') as ImageProvider, // Default image
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
                      onPressed: _pickProfileImage,
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
      value: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark,
      onChanged: (value) {
      Provider.of<ThemeProvider>(context, listen: false).toggleTheme(value);
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
      onTap: _showChangePasswordDialog,
    ),
    ListTile(
      title: const Text("Privacy Policy"),
      trailing: const Icon(Icons.arrow_forward_ios),
  
    ),
    ListTile(
      title: const Text("Delete Account"),
      trailing: const Icon(Icons.arrow_forward_ios),
      leading: const Icon(Icons.delete_forever, color: Colors.red),
       onTap: () => _showDeleteAccountDialog(),
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