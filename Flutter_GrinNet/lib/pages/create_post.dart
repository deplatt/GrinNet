import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../api_service.dart';
import 'global.dart';
import 'package:intl/intl.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> allTags = [
    'Sports', 'Culture', 'Games', 'SEPCs', 'Dance', 'Music', 'Food', 'Social', 'Misc'
  ];
  final Set<String> selectedTags = {};

  File? _selectedImage;
  DateTime? _selectedEventDate;

  // Pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Pick event date from calendar
  Future<void> _pickEventDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedEventDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _submitPost() async {
    if (Global.userId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User ID not set. Please log in again.")),
      );
      return;
    }

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty || selectedTags.isEmpty || _selectedEventDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields, select tags, and set a date.")),
      );
      return;
    }

    final postText = '$title\n\n$description';
    final int currentUserId = Global.userId;
    String postImagePath = '';

    // Upload image if one is selected
    if (_selectedImage != null) {
      try {
        final filename = await uploadImage(_selectedImage!);
        if (filename == null) {
          throw Exception('Image upload failed');
        }
        postImagePath = 'uploads/$filename';
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to upload image: $e")),
        );
        return;
      }
    }

    try {
      print("Trying to submit post. Global.userId = $currentUserId");

      final response = await createPost(
        currentUserId,
        postText,
        postImagePath,
        selectedTags.map((tag) => tag.toLowerCase()).toList(),  // <-- LOWERCASE TAGS
        _selectedEventDate!.toIso8601String(),
      );

      if (response != null && response.statusCode == 201) {
        Navigator.pop(context, true); // signal that a post was created
      } else {
        final status = response?.statusCode ?? 'unknown';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to create post (status $status)")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error creating post: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String eventDateLabel = _selectedEventDate == null
        ? 'Select Event Date'
        : 'Event Date: ${DateFormat.yMMMd().format(_selectedEventDate!)}';

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
                    Text('Image selected', style: TextStyle(color: Colors.green)),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickEventDateTime,
                child: Text(eventDateLabel),
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
