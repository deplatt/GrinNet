import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://localhost:3000';
// const String baseUrl = 'http://10.0.2.2:3000'; // Use this if running on Android emulator

// const String baseUrl = 'http://your-local-ip:3000'; // Otherwise, use this. 
// to get your IP, run "ipconfig (Windows)" or "ifconfig (Mac/Linux)"

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
Future<http.Response> createPost(int creator, String postText, String postImage, List<String> postTags) {
  return http.post(
    Uri.parse('$baseUrl/posts'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'creator': creator,
      'postText': postText,
      'postImage': postImage,
      'postTags': postTags,
    }),
  );
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
  final int post_id;
  final int creator;

  Post({
    required this.creationDate,
    required this.creationTime,
    required this.postText,
    required this.userProfilePicture,
    required this.postTags,
    required this.postPicture,
    required this.posterUsername,
    required this.post_id,
    required this.creator,
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
      post_id: json['post_id'],
      creator: json['creator'],
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



// Here's an example usage of these http requests from what I understand:

// final response = await createUser("john_doe", "Hi I’m John", "http://example.com/pfp.jpg");

// if (response.statusCode == 201) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text("User created successfully!")),
//   );
// } else {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text("Failed: ${jsonDecode(response.body)['error']}")),
//   );
// }