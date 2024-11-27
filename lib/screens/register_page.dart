import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Registration Page for Users to Sign Up
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers to handle input from the registration form fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  // GlobalKey to manage form validation
  final _formKey = GlobalKey<FormState>();

  // Variable to check email availability
  bool _isEmailAvailable = true;

  // Reference to Firestore collection for user data
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('Fitsync Authentication');

  // Function to check if the email already exists in Firestore
  Future<void> _checkEmailExists() async {
    final querySnapshot = await usersCollection
        .where('Email', isEqualTo: _emailController.text)
        .get();

    setState(() {
      _isEmailAvailable = querySnapshot.docs.isEmpty; // If no documents match, email is available
    });
  }

  // Email validation function
  String? _validateEmail() {
    final email = _emailController.text;
    if (email.isEmpty) {
      return 'Please enter your email'; // Check if email is empty
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return 'Enter a valid email address'; // Validate email format
    }
    if (!_isEmailAvailable) {
      return 'Email already exists'; // Check if email is already registered
    }
    return null; // Return null if email is valid
  }

  // Password validation function
  String? _validatePassword() {
    final password = _passwordController.text;
    if (password.isEmpty) {
      return 'Password cannot be empty'; // Check if password is empty
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$').hasMatch(password)) {
      return 'Password must contain an uppercase, a lowercase, a number, and a symbol, or your password is less than 8 characters';
    }
    return null; // Return null if password meets requirements
  }

  // Confirm password validation function
  String? _validateConfirmPassword() {
    if (_confirmPasswordController.text != _passwordController.text) {
      return 'Passwords do not match'; // Ensure passwords are identical
    }
    return null; // Return null if passwords match
  }

  // Username validation function
  String? _validateUsername() {
    final username = _usernameController.text;
    if (username.isEmpty) {
      return 'Please enter a username'; // Ensure username is not empty
    }
    return null; // Return null if username is valid
  }

  // First name validation function
  String? _validateFirstName() {
    if (_firstNameController.text.isEmpty) {
      return 'Please enter your first name'; // Ensure first name is provided
    }
    return null; // Return null if first name is valid
  }

  // Last name validation function
  String? _validateLastName() {
    if (_lastNameController.text.isEmpty) {
      return 'Please enter your last name'; // Ensure last name is provided
    }
    return null; // Return null if last name is valid
  }

  // Function to show error messages using a Snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Function to validate all fields and submit if valid
  Future<void> _validateAndSubmit() async {
    // First check if the email exists
    await _checkEmailExists();

    // Perform validation checks for each input field
    final firstNameError = _validateFirstName();
    final lastNameError = _validateLastName();
    final emailError = _validateEmail();
    final usernameError = _validateUsername();
    final passwordError = _validatePassword();
    final confirmPasswordError = _validateConfirmPassword();

    // Show the first validation error encountered
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

    // If all validations pass, save data to Firestore
    try {
      await usersCollection.add({
        'Email': _emailController.text,
        'Firstname': _firstNameController.text,
        'Lastname': _lastNameController.text,
        'Username': _usernameController.text,
        'Password': _passwordController.text,
        'Level': 1, // Initialize level to 1
        'currentExp': 0,   // Initialize experience to 0
        'requiredExp': 10,   // Initialize experience to 0
      });

      // Show a success Snackbar message
      _showErrorSnackbar("Registration successful!");

      // Navigate to the login page instead of the home page
      Navigator.pushNamed(context, '/login');
    } catch (e) {
      _showErrorSnackbar("Error saving data: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.deepPurple, // Set background color for AppBar
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // First Name Field
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name', // Label for first name
                  ),
                ),
                SizedBox(height: 20), // Space between fields

                // Last Name Field
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name', // Label for last name
                  ),
                ),
                SizedBox(height: 20), // Space between fields

                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20), // Space between fields

                // Username Field
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                SizedBox(height: 20), // Space between fields

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true, // Hide the password text
                ),
                SizedBox(height: 20), // Space between fields

                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true, // Hide the password text
                ),
                SizedBox(height: 20), // Space between fields

                // Sign Up Button
                ElevatedButton(
                  onPressed: _validateAndSubmit, // Trigger the submit function
                  child: Text('Sign Up'),
                ),
                SizedBox(height: 400), // Placeholder for spacing
              ],
            ),
          ),
        ),
      ),
    );
  }
}
