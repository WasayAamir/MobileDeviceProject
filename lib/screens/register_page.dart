import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isEmailAvailable = true;

  // Firestore instance
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('Fitsync Authentication');

  // Check if the email already exists in Firestore
  Future<void> _checkEmailExists() async {
    final querySnapshot = await usersCollection
        .where('Email', isEqualTo: _emailController.text)
        .get();

    setState(() {
      _isEmailAvailable = querySnapshot.docs.isEmpty;
    });
  }

  // Email validation function
  String? _validateEmail() {
    final email = _emailController.text;
    if (email.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return 'Enter a valid email address';
    }
    if (!_isEmailAvailable) {
      return 'Email already exists';
    }
    return null;
  }

  // Password validation function
  String? _validatePassword() {
    final password = _passwordController.text;
    if (password.isEmpty) {
      return 'Password cannot be empty';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
        .hasMatch(password)) {
      return 'Password must contain an uppercase, a lowercase, a number, and a symbol, or your password is less than 8 characters';
    }
    return null;
  }

  // Confirm password validation function
  String? _validateConfirmPassword() {
    if (_confirmPasswordController.text != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Username validation function
  String? _validateUsername() {
    final username = _usernameController.text;
    if (username.isEmpty) {
      return 'Please enter a username';
    }
    return null;
  }

  // First name validation function
  String? _validateFirstName() {
    if (_firstNameController.text.isEmpty) {
      return 'Please enter your first name';
    }
    return null;
  }

  // Last name validation function
  String? _validateLastName() {
    if (_lastNameController.text.isEmpty) {
      return 'Please enter your last name';
    }
    return null;
  }

  // Show error messages as Snackbars
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _validateAndSubmit() async {
    await _checkEmailExists();

    final firstNameError = _validateFirstName();
    final lastNameError = _validateLastName();
    final emailError = _validateEmail();
    final usernameError = _validateUsername();
    final passwordError = _validatePassword();
    final confirmPasswordError = _validateConfirmPassword();

    if (firstNameError != null) {
      _showErrorSnackbar(firstNameError);
      return;
    }
    if (lastNameError != null) {
      _showErrorSnackbar(lastNameError);
      return;
    }
    if (emailError != null) {
      _showErrorSnackbar(emailError);
      return;
    }
    if (usernameError != null) {
      _showErrorSnackbar(usernameError);
      return;
    }
    if (passwordError != null) {
      _showErrorSnackbar(passwordError);
      return;
    }
    if (confirmPasswordError != null) {
      _showErrorSnackbar(confirmPasswordError);
      return;
    }

    // Save data to Firestore if all validations pass
    try {
      await usersCollection.add({
        'Email': _emailController.text,
        'Firstname': _firstNameController.text,
        'Lastname': _lastNameController.text,
        'Username': _usernameController.text,
        'Password': _passwordController.text,
      });

      _showErrorSnackbar("Registration successful!");

      // Optionally, navigate to the home page or another screen
      Navigator.pushNamed(context, '/home'); // Adjust route as needed
    } catch (e) {
      _showErrorSnackbar("Error saving data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.blue[200], // Background color
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _validateAndSubmit,
                  child: Text('Sign Up'),
                ),
                SizedBox(height: 400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}