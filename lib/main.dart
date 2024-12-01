import 'package:firebase_core/firebase_core.dart';
import 'package:fitsync/firebase_api.dart';
import 'package:fitsync/screens/leveling_screen.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'screens/settings_database.dart';
import 'screens/fitsync_home_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firebase push notifications
  await FirebaseApi().initNotifications();

  // Get the user's theme preference from the settings Database
  final settingsDatabase = SettingsDatabase();
  String themePreference = await settingsDatabase.getThemePreference() ?? 'light';

  //Run FitSyncAPP
  runApp(FitsyncApp(initialTheme: themePreference));
}

class FitsyncApp extends StatefulWidget {
  final String initialTheme;

  //Constructor
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

    // Set up theme
    _themeMode = widget.initialTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  //Function to toggle between light and dark mode
  void _toggleTheme(bool isDark) async {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });

    //Save the theme to the SettingsDatabase
    await _settingsDatabase.saveThemePreference(isDark ? 'dark' : 'light');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,

      //Make it so that the first page to appear is login
      initialRoute: '/login',

      routes: {
        // Login Page Route
        '/login': (context) => LoginPage(
          onToggleTheme: _toggleTheme,
          isDarkMode: _themeMode == ThemeMode.dark,
        ),

        // Home Page Route
        '/home': (context) => FitsyncHomePage(
          username: '',
          level: 1,
          currentExp: 0,
          requiredExp: 100,
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

        // LevelUp Screen Route
        '/level': (context) => LevelUpScreen(
          username: '',
          level: 1,
          currentExp: 0,
          requiredExp: 100,
          onToggleTheme: _toggleTheme,
          isDarkMode: _themeMode == ThemeMode.dark,
        ),
      },
    );
  }
}