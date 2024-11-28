import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LevelUpScreen extends StatelessWidget {
  final String username;
  final Function(bool) onToggleTheme;
  final bool isDarkMode;

  LevelUpScreen({
    required this.username,
    required this.onToggleTheme,
    required this.isDarkMode,
    required int level,
    required int currentExp,
    required int requiredExp,
  });

  final List<String> avatarOptions = [
    'lib/assets/avatar1.png',
    'lib/assets/avatar2.jpg',
    'lib/assets/avatar3.jpg',
    'lib/assets/avatar4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Leveling Screen'),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Fitsync Authentication')
            .where('Username', isEqualTo: username)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No data found for user: $username",
                style: TextStyle(color: theme.colorScheme.error),
              ),
            );
          }

          final userData = snapshot.data!.docs.first.data() as Map<String, dynamic>;
          final int currentExp = userData['currentExp'] ?? 0;
          final int level = userData['Level'] ?? 1;
          final String currentAvatar = userData['avatar'] ?? 'assets/avatar1.png'; // Default avatar
          final int requiredExp = 100;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                    GestureDetector(
                      onTap: () => _showAvatarDialog(context, currentAvatar),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(currentAvatar),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Lv. $level',
                  style: theme.textTheme.titleLarge,
                ),
                Text(
                  '$currentExp / $requiredExp EXP',
                  style: theme.textTheme.bodyMedium,
                ),
                SizedBox(height: 20),
                Text(
                  username,
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // Function to show avatar selection dialog
  void _showAvatarDialog(BuildContext context, String currentAvatar) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Avatar'),
          content: SingleChildScrollView(
            child: Column(
              children: avatarOptions.map((avatarPath) {
                return GestureDetector(
                  onTap: () async {
                    await _updateAvatar(avatarPath); // Update avatar in Firestore
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(avatarPath),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  // Function to update avatar in Firestore
  Future<void> _updateAvatar(String newAvatar) async {
    try {
      await FirebaseFirestore.instance
          .collection('Fitsync Authentication')
          .where('Username', isEqualTo: username)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          var userDoc = querySnapshot.docs.first;
          userDoc.reference.update({
            'avatar': newAvatar,
          });
        }
      });
    } catch (e) {
      print("Error updating avatar: $e");
    }
  }
}
