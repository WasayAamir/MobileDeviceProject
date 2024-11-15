import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  // FAQ section containing questions and answers
  final List<Map<String, String>> faqData = [
    {
      'question': 'How do I track my progress?',
      'answer': 'You can track your progress on the homepage under "Progress on Goals". Each goal has a progress bar that shows your current progress.',
    },
    {
      'question': 'How do I change my workout plan?',
      'answer': 'You can select a new workout from the homepage or visit the "Workout Tutorials" section in the drawer to explore different exercises.',
    },
    {
      'question': 'What is the Friends Leaderboard?',
      'answer': 'The Friends Leaderboard shows your ranking compared to your friends based on your workout progress and achievements.',
    },
    {
      'question': 'How do I watch workout tutorials?',
      'answer': 'You can click on any workout tutorial image on the homepage, and a dialog will appear asking if you want to watch the tutorial video.',
    },
    {
      'question': 'How can I contact support?',
      'answer': 'For any issues or questions, please contact us through the "Settings" page.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
        backgroundColor: Colors.deepPurple[400], // Background color for the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // General padding for the body
        child: Column(
          children: [
            // FAQ Section
            Expanded(
              child: ListView(
                children: faqData.map((faq) {
                  return ExpansionTile(
                    // Question Text
                    title: Text(
                      faq['question']!,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      // Answer Text with padding
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          faq['answer']!,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),

            // Footer Section
            Divider(), // Divider to visually separate the FAQ section from the footer

            // Footer with app information
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Application Name
                  Text(
                    'FitSync',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  // Version Information
                  Text(
                    'Version 1.0.0',
                    textAlign: TextAlign.center,
                  ),
                  // Copyright Information
                  Text(
                    '© 2024 - FitSyncCo Ltd.',
                    textAlign: TextAlign.center,
                  ),
                  // Short Description
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'This app helps people with their fitness goals.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
