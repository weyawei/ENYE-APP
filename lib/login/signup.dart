import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> signup(String username, String password) async {
    final url = 'https://your-domain.com/signup.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // Handle successful signup
      // Parse the response (e.g., JSON) to extract relevant data
      // Store necessary session-related information in Flutter's local storage
    } else {
      // Handle signup failure
      // Display appropriate error message to the user
    }
  }

  void _handleSignup() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    signup(username, password)
        .then((_) {
      // Navigate to the next screen or perform any other necessary actions
    })
        .catchError((error) {
      // Handle any error that occurred during the signup process
      // Display appropriate error message to the user
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _handleSignup,
              child: Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }
}
