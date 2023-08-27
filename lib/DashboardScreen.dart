import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'MyWallScreen.dart'; // Import the MyWallScreen
import 'UsersListScreen.dart'; // Import the UsersListScreen

class DashboardScreen extends StatelessWidget {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  void _logout(BuildContext context) async {
    await _storage.delete(key: 'auth_token');
    Navigator.pop(context); // Go back to the Home Screen
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          actions: [
            IconButton(
              onPressed: () {
                _logout(context);
              },
              icon: Icon(Icons.logout),
            ),
          ],
          automaticallyImplyLeading: false, // Remove default back button
          bottom: TabBar(
            tabs: [
              Tab(text: 'My Wall'),
              Tab(text: 'Users List'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyWallScreen(), // Replace with your MyWallScreen
            UserListScreen(), // Replace with your UsersListScreen
          ],
        ),
      ),
    );
  }
}
