import 'package:firebase_test2/auth.dart';
import 'package:firebase_test2/pages/login_register_page.dart';
import 'package:flutter/material.dart';
import 'main.dart';

/// This class provides instructions for which page the app should go to when 
/// the user attempts to sign in or register an account.
/// 
/// This code started from the following tutorial:
/// https://www.youtube.com/watch?v=rWamixHIKmQ&ab_channel=FlutterMapp

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
     final Auth _auth = Auth();
    return StreamBuilder(
      // Check with firebase to see if the user is authenticated
      stream: _auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // If the user logged in sucessfully, go to the homepage
          return EventFeedScreen();
        } else {
          // If the user didn't log in successfully, keep them at the sign-in page
          return LoginPage(auth: _auth);
        }
      },
    );
  }
}
