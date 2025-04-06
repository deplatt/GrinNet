import 'package:firebase_test2/auth.dart';
import 'package:firebase_test2/pages/home_page.dart';
import 'package:firebase_test2/pages/login_register_page.dart';
import 'package:flutter/material.dart';
import 'main.dart';


class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges, 
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return EventFeedScreen();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
