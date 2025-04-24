import 'package:firebase_test2/auth.dart';
import 'package:flutter/material.dart';


// Starter code made with the help of ChatGPT

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter your grinnell.edu email',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final email = emailController.text;
                  if (email.length < 13 || email.substring(email.length - 13) != "@grinnell.edu") {
                    // TODO: Add snackbar to say invalid email

                  }
                  else {
                    // TODO: Handle send email logic
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("A recovery email has been sent to $email")));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Send Email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
