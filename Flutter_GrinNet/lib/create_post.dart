import 'package:flutter/material.dart';
import 'dart:io';
import 'main.dart';
import 'package:image_picker/image_picker.dart';

// CreatePostScreen class which takes the user to create post page.
class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // Tags based on what we decided
  final List<String> allTags = [
    'Sports', 'Culture', 'Games', 'SEPCs', 'Dance', 'Music', 'Food', 'Social', 'Misc'
  ];
  final Set<String> selectedTags = {};
  File? _selectedImage;

  // asynchronous function, waiting for user to pick image, if no image is picked, nothing happens, post is posted with placeholder image.
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // _submitPost()
  void _submitPost() {
    // uses text controllers to find event title and description.
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    if (title.isEmpty || description.isEmpty || selectedTags.isEmpty) return;
    // returns no post if either title, description or tag is empty

    // new event
    final newEvent = Event(
      username: 'current_user', // Replace with actual user if available
      // if image picked then use that based on async function, else placeholder image!
      imageUrl: _selectedImage != null ? _selectedImage!.path : 'https://via.placeholder.com/150',
      // profile image according to the user, placeholder for now!
      profileImageUrl: 'https://via.placeholder.com/150',
      text: '$title\n\n$description',
      tags: selectedTags.toList(),
    );

    Navigator.pop(context, newEvent);
  }
  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Title
      appBar: AppBar(title: Text('Create Event Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Title
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Event Title'),
              ),
              SizedBox(height: 10),
              // Event Description
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Event Description'),
                maxLines: 4,
              ),
              SizedBox(height: 20),
              // Tags
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
              // Button for uploading image
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
              // submit post button
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
