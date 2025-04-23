import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';
import '../api_service.dart';
import 'global.dart';


class LoginPage extends StatefulWidget {
  final Auth? auth; // <-- Accept Auth object for testing

  const LoginPage({super.key, this.auth}); // <-- Optional named parameter

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await (widget.auth ?? Auth()).signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await (widget.auth ?? Auth()).createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );

      String username = _controllerEmail.text.split('@')[0];

      final response = await createUser(username, "", "");
      if (response.statusCode != 201) {
        throw Exception('Failed to create user on API');
      }

      final userData = jsonDecode(response.body);
      Global.userId = userData['id'];
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  Widget _title() {
    return const Text('GrinNet');
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      )
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : '$errorMessage');
  }

  // Button the user clicks to submit their info
  Widget _submitButton() {
    return ElevatedButton(
      onPressed: isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'Login' : 'Register'),
    );
  }

  // Button to switch between logging in and registering
  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'I want to create an account' : 'I already have an account'),
    );
  }

  // UI containing the input fields for users and submiting button
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _entryField('Email', _controllerEmail),
            _entryField('Password', _controllerPassword),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton(),
          ],
        ),
      ),
    );
  }
}
