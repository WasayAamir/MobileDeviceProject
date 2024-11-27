import 'package:flutter/material.dart';

class LevelUpScreen extends StatelessWidget {
  final String username;
  final int level; // Add this
  final int currentExp; // Add this
  final int requiredExp; // Add this
  final Function(bool) onToggleTheme;
  final bool isDarkMode;
  final List<String> ribbons = ['assets/ribbon1.png']; // Paths for ribbon images to display

  LevelUpScreen({
    required this.username,
    required this.level, // Add this
    required this.currentExp, // Add this
    required this.requiredExp, // Add this
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leveling Screen'),
        backgroundColor: Colors.deepPurple, // Set the background color for the app bar
      ),
      backgroundColor: Colors.white, // Set the background color for the entire screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar and Experience Progress Indicator
            Stack(
              alignment: Alignment.center,
              children: [
                // Circular progress indicator showing user's current experience level
                CircularProgressIndicator(
                  value: currentExp / requiredExp, // Ratio of current experience to total experience
                  strokeWidth: 8.0, // Width of the progress circle
                  backgroundColor: Colors.grey.shade300, // Set background color for the circle
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent), // Color of the progress
                ),

                // User's Avatar
                CircleAvatar(
                  radius: 50, // Set the radius of the avatar
                  backgroundImage: AssetImage('assets/avatar.png'), // Replace with the path of the avatar image
                ),
              ],
            ),
            SizedBox(height: 20), // Add space between widgets

            // Display User's Level
            Text(
              'Lv. $level', // Current level of the user
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Display Experience Points
            Text(
              '$currentExp / $requiredExp EXP', // Current and total experience points
              style: TextStyle(color: Colors.grey.shade600),
            ),
            SizedBox(height: 20), // Add space between widgets

            // Display Username
            Text(
              username, // User's username
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20), // Add space between widgets

            // Medals Section
            Text(
              'Medals', // Title for the medals section
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Display Medals as a Row of Images
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ribbons.map((ribbon) {
                return Padding(
                  padding: const EdgeInsets.all(8.0), // Add space around each ribbon image
                  child: Image.asset(
                    ribbon,
                    width: 50, // Set width of the medal image
                  ), // Replace with the ribbon image path
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
