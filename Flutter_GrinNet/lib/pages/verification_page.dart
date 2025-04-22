import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test2/widget_tree.dart';
import 'package:flutter/material.dart';
import '../auth.dart';

/// This class is the page that the user sees when their email has not been vertified.
/// It simply informs them that they have recieved an email and waits for an update from Firebase.
/// 
/// This code was created with the help of ChatGPT and the following tutorial:
/// https://www.youtube.com/watch?v=mnE9HHtxdGg&t=35s&ab_channel=ShahWali

class VerificationEmailPage extends StatefulWidget {
  const VerificationEmailPage({super.key});
  
  @override
  State<VerificationEmailPage> createState() => _VerificationEmailPage();
}

class _VerificationEmailPage extends State<VerificationEmailPage> {
  final _auth = Auth();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _auth.sendEmailVerificationLink();

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser?.emailVerified == true) {
        timer.cancel();
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) => const WidgetTree(),
          ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Verification')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'We send you a vertification email!',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  _auth.sendEmailVerificationLink();
                },
                child: const Text('Resend Email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}