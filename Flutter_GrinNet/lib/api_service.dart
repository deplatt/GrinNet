import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:flutter/foundation.dart';

final String baseUrl = kIsWeb
    ? 'http://localhost:3000'
    : Platform.isAndroid
        ? 'http://10.0.2.2:3000'
        : 'http://localhost:3000';

final String imageBaseUrl = kIsWeb
    ? 'http://localhost:4000'
    : Platform.isAndroid
        ? 'http://10.0.2.2:4000'
        : 'http://localhost:4000';

/* ========================
   User-related Requests
   ======================== */

// Create a user
Future<http.Response> createUser(String username, String bioText, String profilePicture) {
  return http.post(
    Uri.parse('$baseUrl/users'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'username': username,
      'bioText': "",
      'profilePicture': profilePicture,
    }),
  );
}

// Ban a user
Future<http.Response> banUser(int userId) {
  return http.put(Uri.parse('$baseUrl/users/$userId/ban'));
}

// Warn a user
Future<http.Response> warnUser(int userId) {
  return http.put(Uri.parse('$baseUrl/users/$userId/warn'));
}

// Change bio
Future<http.Response> changeBio(int userId, String newBio) {
  return http.put(
    Uri.parse('$baseUrl/users/$userId/bio'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'newBio': newBio}),
  );
}

// Change profile picture
Future<http.Response> changeProfilePicture(int userId, String newProfilePicture) {
  return http.put(
    Uri.parse('$baseUrl/users/$userId/profile-picture'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'newProfilePicture': newProfilePicture}),
  );
}

// Delete user
Future<http.Response> deleteUser(int userId) {
  return http.delete(Uri.parse('$baseUrl/users/$userId'));
}


/* ========================
   Post-related Requests
   ======================== */

// Create a post
Future<http.Response?> createPost(
  int userId,
  String postText,
  String imagePath,
  List<String> tags,
  String eventDate, // must be an ISO string
) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'creator': userId,
        'postText': postText,
        'postImage': imagePath,
        'postTags': tags,
        'eventDate': eventDate,
      }),
    );
    return response;
  } catch (e) {
    print('Error in createPost: $e');
    return null;
  }
}


// Terminate a post
Future<http.Response> terminatePost(int postId) {
  return http.put(Uri.parse('$baseUrl/posts/$postId/terminate'));
}

// Delete a post
Future<http.Response> deletePost(int postId) {
  return http.delete(Uri.parse('$baseUrl/posts/$postId'));
}

// API model for posts
class Post {
  final String creationDate;
  final String creationTime;
  final String postText;
  final String userProfilePicture;
  final String postTags;
  final String postPicture;
  final String posterUsername;

  Post({
    required this.creationDate,
    required this.creationTime,
    required this.postText,
    required this.userProfilePicture,
    required this.postTags,
    required this.postPicture,
    required this.posterUsername,
  });

  // Parse from JSON map
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      creationDate: json['creation_date'],
      creationTime: json['creation_time'],
      postText: json['post_text'],
      userProfilePicture: json['profile_picture'],
      postTags: json['post_tags'].toString(),
      postPicture: json['post_image'],
      posterUsername: json['username'], 
    );
  }
}

// Returns all current posts with associated user data as a List.
Future<List<Post>> getAllPosts() async {
  final response = await http.get(Uri.parse('$baseUrl/posts'));

  if (response.statusCode == 200) {
    // Parse the JSON list and return a list of Post objects
    List<dynamic> postsJson = jsonDecode(response.body);
    List<Post> posts = postsJson.map((json) => Post.fromJson(json)).toList();
    return posts;
  } else {
    throw Exception('Failed to load posts');
  }
}

/* ========================
   Report-related Requests
   ======================== */

// Report a post
Future<http.Response> reportPost({
  required int reportedUser,
  required String complaintText,
  required int postId,
  required int reporterUser,
}) {
  return http.post(
    Uri.parse('$baseUrl/reports'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'reportedUser': reportedUser,
      'complaintText': complaintText,
      'postId': postId,
      'reporterUser': reporterUser,
    }),
  );
}

// Dismiss a report
Future<http.Response> dismissReport(int reportId) {
  return http.delete(Uri.parse('$baseUrl/reports/$reportId'));
}

/* ========================
   Image-related Requests
   ======================== */

Future<String?> uploadImage(File imageFile) async {
  try {
    final uri = Uri.parse('$imageBaseUrl/upload');
    final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
    final mimeParts = mimeType.split('/');

    // Read image bytes manually
    final Uint8List imageBytes = await imageFile.readAsBytes();

    final request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: imageFile.path.split('/').last,
        contentType: MediaType(mimeParts[0], mimeParts[1]),
      ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['filename']; // Only the filename (e.g., resized-...)
    } else {
      print("Image upload failed: ${response.statusCode} ${response.body}");
      return null;
    }
  } catch (e) {
    print("Image upload exception: $e");
    return null;
  }
}