import 'package:firebase_core/firebase_core.dart';
import 'package:fitsync/firebase_api.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'screens/settings_database.dart';
import 'screens/fitsync_home_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/settings_page.dart';

void main() async {
  // Ensures widgets are properly bound before initializing Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firebase push notifications
  await FirebaseApi().initNotifications();

  // Initialize the settings database to get the user's theme preference
  final settingsDatabase = SettingsDatabase();
  String themePreference = await settingsDatabase.getThemePreference() ?? 'light';

  // Launch the main application with the theme preference
  runApp(FitsyncApp(initialTheme: themePreference));
}

class FitsyncApp extends StatefulWidget {
  final String initialTheme;

  // Constructor to initialize the application with an initial theme
  FitsyncApp({required this.initialTheme});

  @override
  _FitsyncAppState createState() => _FitsyncAppState();
}

class _FitsyncAppState extends State<FitsyncApp> {
  late ThemeMode _themeMode;
  final SettingsDatabase _settingsDatabase = SettingsDatabase();

  @override
  void initState() {
    super.initState();

    // Set theme based on user's preference (dark or light mode)
    _themeMode = widget.initialTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  // Function to toggle the theme between dark and light modes
  void _toggleTheme(bool isDark) async {
    setState(() {
      // Set the theme mode based on user's toggle
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });

    // Save the user's theme preference to the database
    await _settingsDatabase.saveThemePreference(isDark ? 'dark' : 'light');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Light and dark theme configurations
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode, // Apply the current theme mode

      // Set the initial route to the login page
      initialRoute: '/login',

      // Define the routes in the application
      routes: {
        // Login Page Route
        '/login': (context) => LoginPage(
          onToggleTheme: _toggleTheme,
          isDarkMode: _themeMode == ThemeMode.dark,
        ),

        // Home Page Route
        '/home': (context) => FitsyncHomePage(
          username: '',
          onToggleTheme: _toggleTheme,
          isDarkMode: _themeMode == ThemeMode.dark,
        ),

        // Register Page Route
        '/register': (context) => RegisterPage(),

        // Settings Page Route
        '/settings': (context) => SettingsPage(
          onToggleTheme: _toggleTheme,
          isDarkMode: _themeMode == ThemeMode.dark,
        ),
      },
    );
  }
}
