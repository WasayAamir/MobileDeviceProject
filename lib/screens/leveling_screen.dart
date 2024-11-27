import 'package:flutter/material.dart';

class LevelUpScreen extends StatelessWidget {
  final String username;
  final int level;
  final int currentExp;
  final int requiredExp;
  final Function(bool) onToggleTheme;
  final bool isDarkMode;
  final List<String> ribbons = ['assets/ribbon1.png'];

  LevelUpScreen({
    required this.username,
    required this.level,
    required this.currentExp,
    required this.requiredExp,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    // Use ThemeData for colors
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Leveling Screen'),
        backgroundColor: Colors.deepPurple[400],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar and Experience Progress Indicator
            Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: currentExp / requiredExp,
                  strokeWidth: 8.0,
                  backgroundColor: theme.dividerColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.secondary,
                  ),
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/avatar.png'),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Display User's Level
            Text(
              'Lv. $level',
              style: theme.textTheme.titleLarge, // Updated from headline6
            ),

            // Display Experience Points
            Text(
              '$currentExp / $requiredExp EXP',
              style: theme.textTheme.bodyMedium, // Updated from bodyText2
            ),
            SizedBox(height: 20),

            // Display Username
            Text(
              username,
              style: theme.textTheme.titleMedium, // Updated from subtitle1
            ),
            SizedBox(height: 20),

            // Medals Section
            Text(
              'Medals',
              style: theme.textTheme.titleLarge, // Updated from headline6
            ),

            // Display Medals as a Row of Images
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ribbons.map((ribbon) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    ribbon,
                    width: 50,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
