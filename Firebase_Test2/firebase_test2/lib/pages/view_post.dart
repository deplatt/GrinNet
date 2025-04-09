// view_post.dart
// This file defines the ViewPostScreen widget that shows the full details of an event post.

import 'package:flutter/material.dart';
import '../main.dart'; // Import the file that contains the Event model.

/// A stateless widget that displays a full view of a single event post.
class ViewPostScreen extends StatelessWidget {
  // The Event object to display
  final Event event;

  /// Constructor for ViewPostScreen. The 'event' parameter is required.
  const ViewPostScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar displays the username and includes a back button.
      appBar: AppBar(
        title: Text(event.username),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          // Tapping the back arrow pops the view off the navigation stack.
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // The main content area is scrollable.
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the event image if available.
            if (event.imageUrl.isNotEmpty)
              Center(
                child: Image.network(
                  event.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 16.0),
            // The Wrap widget displays the event's category tags using Chips.
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: event.tags.map((tag) => Chip(label: Text(tag))).toList(),
            ),
            SizedBox(height: 16.0),
            // The event description text, shown in a larger font for improved readability.
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