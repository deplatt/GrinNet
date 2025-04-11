import 'package:flutter/material.dart';
import '../main.dart';

// This is the screen that shows a post in greater detail
// when the user clicks on a post in the homepage
class ViewPostScreen extends StatelessWidget {
  final Event event;

  const ViewPostScreen({super.key, required this.event});

  // Displays the post name, description, and tags
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.username),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // If there is an image, display it
            if (event.imageUrl.isNotEmpty)
              Center(
                child: Image.network(
                  event.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 16.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: event.tags.map((tag) => Chip(label: Text(tag))).toList(),
            ),
            SizedBox(height: 16.0),
            Text(
              event.text,
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}