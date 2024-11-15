import 'package:flutter/material.dart';

// Stateful widget to represent the settings page of the application
class SettingsPage extends StatefulWidget {
  // Function to toggle between dark and light mode
  final Function(bool) onToggleTheme;

  // Boolean to keep track of the current theme mode (dark or light)
  final bool isDarkMode;

  // Constructor to accept necessary parameters for theme toggle and current theme mode
  SettingsPage({required this.onToggleTheme, required this.isDarkMode});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _isDarkMode; // Local state to keep track of the theme setting

  @override
  void initState() {
    super.initState();
    // Initialize the local theme state with the value provided by the parent widget
    _isDarkMode = widget.isDarkMode;
  }

  // Function to handle the theme change
  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value; // Update local state for UI
      widget.onToggleTheme(value); // Trigger the app-wide theme change through the callback function
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar for the settings page
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.deepPurple,
      ),

      // Main body of the settings page
      body: ListView(
        padding: EdgeInsets.all(16.0), // Padding for the ListView
        children: [
          // List tile to represent the dark mode toggle switch
          ListTile(
            title: Text('Dark Mode'),
            trailing: Switch(
              value: _isDarkMode, // Display the current theme mode status
              onChanged: _toggleTheme, // Call the function when the switch is toggled
            ),
          ),
          // Additional settings options can be added here
        ],
      ),
    );
  }
}
