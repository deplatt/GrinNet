import 'package:flutter/material.dart';
import 'dart:io';
import '../main.dart';
import 'package:image_picker/image_picker.dart';
import '../api_service.dart';
import 'global.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {

  // Text boxes for inputting the title and description of the post
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  // Available tags
  final List<String> allTags = [
    'Sports', 'Culture', 'Games', 'SEPCs', 'Dance', 'Music', 'Food', 'Social', 'Misc'
  ];

  // Tracks which tags the user has selected
  final Set<String> selectedTags = {};

  File? _selectedImage;

  // Allows the user to pick an image from their computer
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

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

  // Handles the UI of this page. Includes buttons for creating the post and attaching images,
  // as well as fields for text input
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
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Event Title'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Event Description'),
                maxLines: 4,
              ),
              SizedBox(height: 20),
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
