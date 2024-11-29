import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//clas register page
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //controllers input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  //GlobalKey
  final _formKey = GlobalKey<FormState>();

  //checking email availibility
  bool _isEmailAvailable = true;

  //firestore collection
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('Fitsync Authentication');

  //checking if email already exists
  Future<void> _checkEmailExists() async {
    final querySnapshot = await usersCollection
        .where('Email', isEqualTo: _emailController.text)
        .get();

    setState(() {
      _isEmailAvailable = querySnapshot.docs.isEmpty;
    });
  }

  //making sure email is validate
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

  //validate password, making sure all conditions match
  String? _validatePassword() {
    final password = _passwordController.text;
    if (password.isEmpty) {
      return 'Password cannot be empty';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$').hasMatch(password)) {
      return 'Password must contain an uppercase, a lowercase, a number, and a symbol, or your password is less than 8 characters';
    }
    return null;
  }

  //confirm password
  String? _validateConfirmPassword() {
    if (_confirmPasswordController.text != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  //validate username
  String? _validateUsername() {
    final username = _usernameController.text;
    //if username empty then enter username
    if (username.isEmpty) {
      return 'Please enter a username';
    }
    return null;
  }

  //validate first name
  String? _validateFirstName() {
    if (_firstNameController.text.isEmpty) {
      return 'Please enter your first name';
    }
    return null;
  }

  //validate last name
  String? _validateLastName() {
    if (_lastNameController.text.isEmpty) {
      return 'Please enter your last name';
    }
    return null;
  }

  //snackbar error msg
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  //validate it all and submit
  Future<void> _validateAndSubmit() async {
    //check email exists
    await _checkEmailExists();

    //validate all
    final firstNameError = _validateFirstName();
    final lastNameError = _validateLastName();
    final emailError = _validateEmail();
    final usernameError = _validateUsername();
    final passwordError = _validatePassword();
    final confirmPasswordError = _validateConfirmPassword();

    //Show the first validation error encountered
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

    //save data to firebase
    try {
      await usersCollection.add({
        'Email': _emailController.text,
        'Firstname': _firstNameController.text,
        'Lastname': _lastNameController.text,
        'Username': _usernameController.text,
        'Password': _passwordController.text,
        //initilize
        'Level': 1,
        'currentExp': 0,
        'requiredExp': 100,
      });

      //snackbar
      _showErrorSnackbar("Registration successful!");

      //go to login page
      Navigator.pushNamed(context, '/login');
    } catch (e) {
      _showErrorSnackbar("Error saving data: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
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
                    //first name
                    labelText: 'First Name',
                  ),
                ),
                SizedBox(height: 20),

                // Last Name Field
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    //last name
                    labelText: 'Last Name',
                  ),
                ),
                SizedBox(height: 20),
                //email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),

                //Username
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                SizedBox(height: 20),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),

                //confirming password
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),

                //sign up
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
