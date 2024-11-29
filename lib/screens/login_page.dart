import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'fitsync_home_page.dart';

//class login page
class LoginPage extends StatelessWidget {
  //toggle for light/dark mode
  final Function(bool) onToggleTheme;
  final bool isDarkMode;

  //Constructor
  LoginPage({required this.onToggleTheme, required this.isDarkMode});

  //controllers for username and password
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //handling login
  Future<void> _login(BuildContext context) async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showErrorSnackbar(context, 'Please enter both username and password');
      return;
    }
    //checking if username/password exists and matches
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Fitsync Authentication')
        .where('Username', isEqualTo: username)
        .where('Password', isEqualTo: password)
        .get();

    //go to homepage if correct
    if (querySnapshot.docs.isNotEmpty) {
      final userDoc = querySnapshot.docs.first;
      final userData = userDoc.data();
      // get some user data
      final level = userData['Level'] ?? 'N/A';
      final currentExp = userData['currentExp'] ?? 0;
      final requiredExp = userData['requiredExp'] ?? 0;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FitsyncHomePage(
            username: username,
            level: level,
            currentExp: currentExp,
            requiredExp: requiredExp,
            onToggleTheme: onToggleTheme,
            isDarkMode: isDarkMode,
          ),
        ),
      );
    } else {
      //error snackbar
      _showErrorSnackbar(context, 'Login information does not exist');
    }
  }

  //displaying error
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
      //appbar
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Username Input
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            //Password Input
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              //hiding password text
              obscureText: true,
            ),
            SizedBox(height: 20),

            //login and register buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //login
                ElevatedButton(
                  //login when pressed
                  onPressed: () => _login(context),
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                ),

                //register
                TextButton(
                  onPressed: () {
                    //go to register page
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text('Register'),
                ),
              ],
            ),

            Spacer(),
            //divider for footer
            Divider(),

            //Footer space
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //title
                    Text(
                      'FitSync',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    //Version Info
                    Text(
                      'Version 1.0.0',
                      textAlign: TextAlign.center,
                    ),
                    Text('Â© 2024 - FitSyncCo Ltd.',
                      textAlign: TextAlign.center,),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      //discription
                      child: Text('This app helps people with their fitness goals.',
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