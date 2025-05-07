import 'dart:convert';

import 'package:firebase_test2/api_service.dart';
import 'package:firebase_test2/auth.dart';
import 'package:firebase_test2/pages/global.dart';
import 'package:firebase_test2/pages/login_register_page.dart';
import 'package:firebase_test2/pages/verification_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

/// This class provides instructions for which page the app should go to when 
/// the user attempts to sign in or register an account.
/// 
/// This code started from the following tutorial:
/// https://www.youtube.com/watch?v=rWamixHIKmQ&ab_channel=FlutterMapp
class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  /// Indicates whether data is still loading (e.g., user info fetch).
  bool _loading = true;

  /// Flags if an error occurred during user ID fetching.
  bool _hasError = false;

  /// Indicates whether the user's email has been verified.
  bool _emailVerified = false;

  @override
  void initState() {
    super.initState();
    _initializeUserState(); // Begin loading user info on init.
  }

  /// Initializes the user's state by checking authentication, verifying the email,
  /// and fetching the user ID from the backend using their username.
  Future<void> _initializeUserState() async {
    setState(() {
      _loading = true;
      _hasError = false;
    });

    final user = Auth().currentUser;
    if (user == null) {
      setState(() => _loading = false);
      return;
    }

    try {
      // Reload user info to get the latest email verification status.
      await user.reload();
      final refreshedUser = Auth().currentUser;

      if (refreshedUser == null) {
        setState(() => _loading = false);
        return;
      }

      // Save email verification status and extract username.
      _emailVerified = refreshedUser.emailVerified;
      final username = refreshedUser.email!.split('@')[0];
      Global.username = username;

      // Query backend to fetch user ID by username.
      final uri = Uri.parse('$baseUrl/users?username=$username');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);

        // If the response is well-formed, extract user ID.
        if (userData is Map && userData.containsKey('id')) {
          Global.userId = userData['id'];
          setState(() {
            _loading = false;
          });
        } else {
          throw Exception('Malformed user data: $userData');
        }
      } else {
        throw Exception('User fetch failed with status ${response.statusCode}');
      }
    } catch (e) {
      print("User fetch failed: $e");
      setState(() {
        _hasError = true;
        _loading = false;
      });
    }
  }

  /// Signs the user out and resets global state. Used when user chooses to
  /// return to the login screen after a failed fetch or logout.
  Future<void> _returnToLogin() async {
    await Auth().signOut();
    Global.userId = 0;
    Global.username = "";
    if (mounted) {
      setState(() {
        _hasError = false;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // If the user logged in sucessfully, go to the homepage
          return EventFeedScreen();
        } else {
          // If the user didn't log in successfully, keep them at the sign-in page
          return const LoginPage();
        }

        // If user's email is not verified, show verification prompt.
        if (!_emailVerified) {
          return const VerificationEmailPage();
        }

        // If user ID is successfully fetched, show the main feed.
        if (Global.userId != 0) {
          return const EventFeedScreen();
        }

        // If there was an error fetching user ID, show retry screen.
        if (_hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "User ID fetch failed. Try again or return to login.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _initializeUserState,
                      child: const Text("Retry"),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: _returnToLogin,
                      child: const Text("Return to Login Screen"),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Default fallback screen while waiting for valid state.
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
