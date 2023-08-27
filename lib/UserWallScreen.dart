import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'MessageDetailScreen.dart'; // Import the MessageDetailScreen

class UserWallScreen extends StatefulWidget {
  final dynamic user;

  UserWallScreen(this.user);

  @override
  _UserWallScreenState createState() => _UserWallScreenState();
}

class _UserWallScreenState extends State<UserWallScreen> {
  List<String> wallMessages = [];
  String userId = '';
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final TextEditingController messageController = TextEditingController();

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
    }
  }

  Future<void> _fetchWallMessages() async {
    try {
      final url =
          'http://127.0.0.1:8000/get_user_wall_messages/${widget.user['id']}';
      print('Fetching wall messages from: $url');

      final response = await http.get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        final List<dynamic> messages = jsonDecode(response.body);
        setState(() {
          wallMessages = messages.map((message) => _formatWallMessage(message)).toList();
        });
      } else {
        print('Failed to fetch wall messages');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String _formatWallMessage(dynamic message) {
    final posterFullName = message['poster_full_name'];
    final content = message['content'];
    return '$posterFullName:\n$content';
  }

  Future<void> _postWallMessage() async {
    final content = messageController.text;

    if (content.isNotEmpty) {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/post_wall_message'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'poster_id': userId,
          'receiver_id': widget.user['id'],
          'content': content,
        }),
      );

      if (response.statusCode == 200) {
        messageController.clear();
        _fetchWallMessages();
      } else {
        print('Failed to post message');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.user['full_name']}\'s Wall')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Messages on ${widget.user['full_name']}\'s wall:',
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
            SizedBox(height: 16),
            TextFormField(
              controller: messageController,
              decoration: InputDecoration(labelText: 'Post a message'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _postWallMessage,
              child: Text('Post Message'),
            ),
          ],
        ),
      ),
    );
  }
}
