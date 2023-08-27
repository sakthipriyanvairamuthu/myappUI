import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'UserWallScreen.dart'; // Import the UserWallScreen

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<dynamic> users = []; // List to store users
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Fetch users when the screen initializes
  }

  Future<void> _fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/get_all_users'), // Replace with your backend URL
      );

      if (response.statusCode == 200) {
        final List<dynamic> fetchedUsers = jsonDecode(response.body);
        setState(() {
          users = fetchedUsers;
        });
      } else {
        // Handle error when fetching users
        print('Failed to fetch users');
      }
    } catch (error) {
      // Handle any network or parsing errors
      print('Error: $error');
    }
  }

  void _navigateToUserWall(dynamic user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserWallScreen(user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        automaticallyImplyLeading: false, // Remove default back button
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final userId = user['id'];
          final fullName = user['full_name'];
          final employeeId = user['employee_id'];

          return ListTile(
            title: Text('$fullName - $employeeId'),
            onTap: () {
              _navigateToUserWall(user); // Navigate to user's wall
            },
          );
        },
      ),
    );
  }
}
