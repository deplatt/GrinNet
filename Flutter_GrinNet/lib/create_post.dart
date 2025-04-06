import 'package:flutter/material.dart';
import 'main.dart'; // To access the Event class

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  final List<String> availableTags = [
    'sports',
    'culture',
    'games',
    'SEPCs',
    'dance',
    'music',
    'food',
    'social',
    'misc',
  ];

  List<String> selectedTags = [];

  void _toggleTag(String tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        selectedTags.add(tag);
      }
    });
  }

  void _submitPost() {
    if (_textController.text.isEmpty ||
        _imageUrlController.text.isEmpty ||
        selectedTags.isEmpty) {
      return;
    }

    final newEvent = Event(
      username: 'current_user', // Replace with actual user if available
      imageUrl: _imageUrlController.text,
      text: _textController.text,
      tags: selectedTags,
    );

    Navigator.pop(context, newEvent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            TextField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Post Text'),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Select Tags:', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: availableTags.map((tag) {
                  final isSelected = selectedTags.contains(tag);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: FilterChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (_) => _toggleTag(tag),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitPost,
              child: Text('Submit Post'),
            ),
          ],
        ),
      ),
    );
  }
}
