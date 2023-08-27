import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'MessageDetailScreen.dart'; // Import the MessageDetailScreen

class MyWallScreen extends StatefulWidget {
  @override
  _MyWallScreenState createState() => _MyWallScreenState();
}

class _MyWallScreenState extends State<MyWallScreen> {
  List<String> wallMessages = [];
  String userId = '';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _fetchUserId();
    _fetchWallMessages();
  }

  Future<void> _fetchUserId() async {
    String? storedUserId = await _storage.read(key: 'user_id');
    if (storedUserId != null) {
      setState(() {
        userId = storedUserId;
      });
      print('User ID: $userId');
    }
  }

  Future<void> _fetchWallMessages() async {
    try {
      final url = 'http://127.0.0.1:8000/get_user_wall_messages/$userId';
      print('Fetching wall messages from: $url');

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> messages = jsonDecode(response.body);
        setState(() {
          wallMessages = messages
              .map((message) =>
                  "${message['poster_full_name']}:\n${message['content']}")
              .toList();
        });
      } else {
        print('Failed to fetch wall messages');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wall'),
        automaticallyImplyLeading: false, // Remove default back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Messages posted on your wall:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of messages horizontally
                  crossAxisSpacing: 8, // Space between messages horizontally
                  mainAxisSpacing: 8, // Space between messages vertically
                ),
                itemCount: wallMessages.length,
                itemBuilder: (context, index) {
                  final randomColor = Colors.primaries[index % Colors.primaries.length];
                  final lightColor = Color.alphaBlend(Colors.white.withOpacity(0.5), randomColor);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MessageDetailScreen(message: wallMessages[index]),
                        ),
                      );
                    },
                    child: Container(
                      color: lightColor,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          wallMessages[index],
                          style: TextStyle(
                            color: Colors.black, // Use black color for text
                            fontSize: 16, // Set the font size to 16
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
