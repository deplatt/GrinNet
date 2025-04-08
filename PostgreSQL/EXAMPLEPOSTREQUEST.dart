import 'dart:convert';
import 'package:http/http.dart' as http;

// MAKE SURE TO ADD http: ^0.13.4 TO DEPENDANCIES


Future<void> createUser(String username, String password, String bioText, String profilePicture) async {
  final url = Uri.parse('http://SERVER_IP:5432/users');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'username': username,
      'password': password,
    //   'bioText': bioText,
    //   'profilePicture': profilePicture,
    }),
  );

  if (response.statusCode == 201) { // 201 is success response in flutter
    // Handle success
    final userData = jsonDecode(response.body);
    print('User created: $userData');
  } else {
    // Handle error
    final errorData = jsonDecode(response.body);
    print('Error: ${errorData['error']}');
  }
}
