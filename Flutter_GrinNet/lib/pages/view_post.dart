import 'package:flutter/material.dart';
import '../main.dart';
// importing the report post function already defined in api_service.dart
import '../api_service.dart' ;

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

            SizedBox(height: 24.0),  // space before report button

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent, // signal a destructive action
                ),
                child: Text('Report User'),
                onPressed: () async {
                  // Call the existing reportPost() helper
                  final response = await reportPost(
                    reportedUser:    event.userId, /* TODO: put the reported user's ID here */
                    complaintText:   'Inappropriate content',   // or prompt user
                    postId:          event.postId, /* TODO: put this post's ID here */
                    reporterUser:    1, /* TODO: put current user's ID here */
                  );

                  // Give user feedback
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        response.statusCode == 201
                          ? 'Report submitted successfully.'
                          : 'Failed to submit report.',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}