import 'package:flutter/material.dart';

class LevelUpScreen extends StatelessWidget {
  final String username = 'suf1009';
  final int level = 15;
  final int currentExp = 205;
  final int totalExp = 510;
  final List<String> ribbons = ['assets/ribbon1.png']; // Add paths for ribbon images

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Leveling Screen'),
          backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar and Exp Progress
            Stack(
              alignment: Alignment.center,
              children: [
                // Exp Circle
                CircularProgressIndicator(
                  value: currentExp / totalExp,
                  strokeWidth: 8.0,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
                // Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/avatar.png'), // Replace with avatar path
                ),
              ],
            ),
            SizedBox(height: 20),
            // Level and Exp Text
            Text(
              'Lv. $level',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '$currentExp / $totalExp EXP',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            SizedBox(height: 20),
            // Username
            Text(
              username,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            // Ribbons Section
            Text(
              'Medals',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ribbons.map((ribbon) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(ribbon, width: 50), // Replace with ribbon icon
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
