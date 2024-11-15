import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'fitsync_home_page.dart';

// Login Page Widget
class LoginPage extends StatelessWidget {
  // Props for managing theme toggle and dark mode state
  final Function(bool) onToggleTheme;
  final bool isDarkMode;

  // Constructor
  LoginPage({required this.onToggleTheme, required this.isDarkMode});

  // Controllers to capture user input for username and password
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to handle the login process
  Future<void> _login(BuildContext context) async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Validate input fields
    if (username.isEmpty || password.isEmpty) {
      _showErrorSnackbar(context, 'Please enter both username and password');
      return;
    }

    // Query Firestore to check if the username and password match a record
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Fitsync Authentication')
        .where('Username', isEqualTo: username)
        .where('Password', isEqualTo: password)
        .get();

    // If credentials are correct, navigate to the home page
    if (querySnapshot.docs.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FitsyncHomePage(
            username: username,
            onToggleTheme: onToggleTheme,
            isDarkMode: isDarkMode,
          ),
        ),
      );
    } else {
      // Show error message if login fails
      _showErrorSnackbar(context, 'Login information does not exist');
    }
  }

  // Function to display an error message
  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.deepPurple, // Set the background color of the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding for the entire body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Username Input Field
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username', // Label for the text field
                border: OutlineInputBorder(), // Outline border for better visibility
              ),
            ),
            SizedBox(height: 20), // Add space between input fields

            // Password Input Field
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password', // Label for the text field
                border: OutlineInputBorder(), // Outline border for better visibility
              ),
              obscureText: true, // Hide text for security reasons
            ),
            SizedBox(height: 20), // Add space between input fields

            // Row for Login and Register buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Login Button
                ElevatedButton(
                  onPressed: () => _login(context), // Trigger login when pressed
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                ),

                // Register Button
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register'); // Navigate to register page
                  },
                  child: Text('Register'),
                ),
              ],
            ),

            Spacer(), // Pushes the divider and footer to the bottom

            // Divider to separate the form from the footer section
            Divider(),

            // Footer Section
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // App Title
                    Text(
                      'FitSync',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    // Version Information
                    Text(
                      'Version 1.0.0',
                      textAlign: TextAlign.center,
                    ),
                    // Copyright Information
                    Text(
                      '© 2024 - FitSyncCo Ltd.',
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'This app helps people with their fitness goals.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
