import 'package:flutter/material.dart';

class MessageDetailScreen extends StatelessWidget {
  final String message;

  MessageDetailScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Detail'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(16.0),
            alignment: message.length > 100 ? Alignment.topLeft : Alignment.centerLeft, // Adjust the condition as needed
            child: Text(
              message,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
