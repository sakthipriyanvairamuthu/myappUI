import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LoginScreen.dart';
import 'SignupScreen.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatelessWidget {
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _signup(BuildContext context) async {
    final String employeeId = employeeIdController.text;
    final String fullName = fullNameController.text;
    final String password = passwordController.text;

    final Map<String, dynamic> requestBody = {
      'employee_id': employeeId,
      'full_name': fullName,
      'password': password,
    };

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/signup'), // Replace with your backend URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    print('Request Body: $requestBody'); // Check the request body being sent

    if (response.statusCode == 200) {
      // Successfully signed up, navigate back to main.dart (Home Screen)
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      // Handle signup failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: employeeIdController,
              decoration: InputDecoration(labelText: 'Employee ID'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _signup(context);
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
