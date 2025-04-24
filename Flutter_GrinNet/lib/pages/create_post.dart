import 'package:flutter/material.dart';
import 'dart:io';
import '../main.dart';
import 'package:image_picker/image_picker.dart';
import '../api_service.dart';
import 'global.dart';


/// This class is a screen that allows the user to create a new event post.
///
/// The user is able to input a title and description for the event, select one 
/// or more tags from a predefined list, and optionally upload an image from their
/// device. Upon submission, the post data is sent to the backend server for storage
/// and visible in the home page.
///
/// Preconditions:
/// - The user must be logged in and have a valid `Global.userId`.
///
/// Postconditions:
/// - A new post is submitted if all required fields are filled.
/// - If submission is successful, the user is navigated back with the new post as result.
/// - If submission fails, an error message is shown.
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

/// State class for [CreatePostScreen] responsible for managing the user interaction.
class _CreatePostScreenState extends State<CreatePostScreen> {
  /// Controller for the event title input field.
  final TextEditingController _titleController = TextEditingController();

  /// Controller for the event description input field.
  final TextEditingController _descriptionController = TextEditingController();

  /// A predefined list of available tags for the user to select.
  final List<String> allTags = [
    'Sports', 'Culture', 'Games', 'SEPCs', 'Dance', 'Music', 'Food', 'Social', 'Misc'
  ];

  /// Set of tags selected by the user for the current post.
  final Set<String> selectedTags = {};

  /// The image file selected by the user, if any.
  File? _selectedImage;

  /// Opens the gallery for the user to pick an image.
  ///
  /// Preconditions:
  /// - Device permissions must allow gallery access.
  ///
  /// Postconditions:
  /// - If an image is picked, [_selectedImage] is set and UI is updated.
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }
  /// Submits the post to the backend server.
  ///
  /// Preconditions:
  /// - [_titleController], [_descriptionController] must not be empty.
  /// - [selectedTags] must contain at least one tag.
  ///
  /// Postconditions:
  /// - If submission succeeds, a new [Event] is created and returned via Navigator.
  /// - If submission fails, an error message is displayed.
  ///
  /// Exceptions:
  /// - Displays an error SnackBar if an exception occurs during network communication.
  void _submitPost() async {

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    // Make sure there is a title, description, and at least one tag
    if (title.isEmpty || description.isEmpty || selectedTags.isEmpty) return;

    final postText = '$title\n\n$description';
    final int currentUserId = Global.userId;
    try {
      // Send the data to the backend
      final response = await createPost(
        currentUserId,
        postText,
        _selectedImage != null ? _selectedImage!.path : '',
        selectedTags.toList(),
      );

      // 201 refers to the success code
      if (response.statusCode == 201) {
        final newEvent = Event(
          username: 'current_user', // Placeholder
          imageUrl: _selectedImage != null ? _selectedImage!.path : '',
          profileImageUrl: '',
          text: postText,
          tags: selectedTags.toList(),
        );
        
        // Go back to the previous screen
        Navigator.pop(context, newEvent);
      } else {
        // If the post creation failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to create post")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  /// Handles the user interface for the post creation page.
  ///
  /// UI Components:
  /// - Text fields for event title and description.
  /// - A set of selectable tags via [FilterChip].
  /// - An image upload button and status text.
  /// - A submit button that calls [_submitPost].
  ///
  /// Postconditions:
  /// - Allows the user to input and submit a new event post.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Event Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input field for event title
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Event Title'),
              ),
              SizedBox(height: 10),
              // Input field for event description
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Event Description'),
                maxLines: 4,
              ),
              SizedBox(height: 20),
              // Section for selecting tags
              Text('Select Tags:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: allTags.map((tag) {
                  final isSelected = selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedTags.add(tag);
                        } else {
                          selectedTags.remove(tag);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
               // Row for image upload button and image status
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Upload Image'),
                  ),
                  SizedBox(width: 10),
                  if (_selectedImage != null)
                    Text(
                      'Image selected',
                      style: TextStyle(color: Colors.green),
                    )
                ],
              ),
              SizedBox(height: 20),
              // Submit button centered on the screen
              Center(
                child: ElevatedButton(
                  onPressed: _submitPost,
                  child: Text('Post'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






  

