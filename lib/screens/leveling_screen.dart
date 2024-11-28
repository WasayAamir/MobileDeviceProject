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
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/avatar.png'),
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

                Text(
                  'Medals',
                  style: theme.textTheme.titleLarge,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/ribbon1.png', width: 50),
                    Image.asset('assets/ribbon1.png', width: 50),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
