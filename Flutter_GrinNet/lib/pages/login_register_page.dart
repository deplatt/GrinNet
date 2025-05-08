import 'package:firebase_test2/api_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forgot_pass_page.dart';
import '../auth.dart';
import '../widget_tree.dart';

// This is the page for the user to log in or create their account from. It greets the user upon opening the app
class LoginPage extends StatefulWidget {
  final Auth? auth;
  const LoginPage({super.key, this.auth});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;
  bool isLoading = false;
  String errorMessage = '';
  bool hidePass = true;

  // Text fields for email and password
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();

  void toggleLoginMode() {
    setState(() {
      isLogin = !isLogin;
      errorMessage = '';
    });
  }

  void setError(String message) {
    setState(() {
      errorMessage = message;
      isLoading = false;
    });
  }

  // Function for sending sign-in info to firebase. Changed to make it to where it uses the widget tree.
  Future<void> handleLogin() async {
    setState(() => isLoading = true);
    try {
      await (widget.auth ?? Auth()).signInWithEmailAndPassword(
        email: _controllerEmail.text.trim(),
        password: _controllerPassword.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const WidgetTree()));
    } on FirebaseAuthException catch (e) {
      setError('Login failed: ${e.message}');
    } catch (e) {
      setError('Unexpected error: $e');
    }
  }

  // Function to handle registering as a user.
  Future<void> handleRegister() async {
    setState(() => isLoading = true);
    final email = _controllerEmail.text.trim();
    final password = _controllerPassword.text.trim();

    if (!email.endsWith('@grinnell.edu')) {
      setError('Please use your @grinnell.edu email.');
      return;
    }

    try {
      // Step 1: Create Firebase user
      await (widget.auth ?? Auth()).createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 2: Call Express backend to store the user in Postgres
      final username = email.split('@')[0];
      final response = await createUser(username, "", ""); // default bio/pfp
      if (response.statusCode != 201) {
        throw Exception('Backend user creation failed: ${response.body}');
      }

      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const WidgetTree()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        setError('This email is already registered. Please log in.');
      } else {
        setError('Registration failed: ${e.message}');
      }
    } catch (e) {
      setError('Unexpected error: $e');
    }
  }

    // A generic field for the user to enter text
  Widget _entryField(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      )
    );
  }

  // A more specialized field for the user to specifically enter their password
  Widget _passField(String title, TextEditingController controller,) {
    return TextFormField(
      obscureText: hidePass,
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        suffixIcon: IconButton(
          padding: const EdgeInsetsDirectional.only(end: 12.0),
          icon: hidePass ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
          onPressed: () {
            setState(() {
              hidePass = !hidePass;
            });
          }
        )
      )
    );
  }

  // Button to switch between logging in and registering
  Widget _forgotPasswordButton() {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
      },
      child: Text(isLogin? "Forgot Password?": ""),
    );
  }

  // UI containing the input fields for users and submiting button
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GrinNet')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _entryField("Email", _controllerEmail),
              const SizedBox(height: 10),
              _passField('Password', _controllerPassword),
              Align(alignment: Alignment.centerRight, child: _forgotPasswordButton()),
              const SizedBox(height: 10),
              if (errorMessage.isNotEmpty)
                Text(errorMessage, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: isLoading ? null : (isLogin ? handleLogin : handleRegister),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : Text(isLogin ? 'Login' : 'Create Account'),
              ),
              TextButton(
                onPressed: toggleLoginMode,
                child: Text(isLogin ? 'I want to create an account' : 'I already have an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
