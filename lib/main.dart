import 'package:flutter/material.dart';
import 'screens/fitsync_home_page.dart';
import 'screens/login_page.dart';

void main() {
  runApp(FitsyncApp());
}

class FitsyncApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.amber),
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      home: FitsyncHomePage(),
      routes: {
        '/login': (context) => LoginPage(),
      },
    );
  }
}