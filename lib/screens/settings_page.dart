import 'package:flutter/material.dart';

// Settings class that holds the light/dark mode
class SettingsPage extends StatefulWidget {
  // Toggle between light and dark mode
  final Function(bool) onToggleTheme;

  // Keeps track of the current mode
  final bool isDarkMode;

  // Constructor accepts parameters for theme toggle and current theme
  SettingsPage({required this.onToggleTheme, required this.isDarkMode});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _isDarkMode; // Local state to keep track of the theme

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  // Function handles the theme change
  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value; // Update local state for UI
      widget.onToggleTheme(value); //changes the theme of the whole app
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.deepPurple,
      ),


      body: ListView(
        padding: EdgeInsets.all(16.0), // Padding for the ListView
        children: [

          ListTile(
            title: Text('Dark Mode'),
            trailing: Switch(
              value: _isDarkMode, // Display the current theme mode status
              onChanged: _toggleTheme,
            ),
          ),
        ],
      ),
    );
  }
}
