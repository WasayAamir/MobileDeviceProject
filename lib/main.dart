import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'screens/settings_database.dart';
import 'screens/fitsync_home_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final settingsDatabase = SettingsDatabase();
  String themePreference = await settingsDatabase.getThemePreference() ?? 'light';

  runApp(FitsyncApp(initialTheme: themePreference));
}

class FitsyncApp extends StatefulWidget {
  final String initialTheme;

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
    _themeMode = widget.initialTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  void _toggleTheme(bool isDark) async {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
    await _settingsDatabase.saveThemePreference(isDark ? 'dark' : 'light');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(
            onToggleTheme: _toggleTheme, isDarkMode: _themeMode == ThemeMode.dark),
        '/home': (context) => FitsyncHomePage(
            username: '', onToggleTheme: _toggleTheme, isDarkMode: _themeMode == ThemeMode.dark),
        '/register': (context) => RegisterPage(),
        '/settings': (context) => SettingsPage(
            onToggleTheme: _toggleTheme, isDarkMode: _themeMode == ThemeMode.dark),
      },
    );
  }
}
