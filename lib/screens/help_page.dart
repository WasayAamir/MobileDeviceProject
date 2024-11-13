import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  // List of questions and answers for the FAQ section
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
        backgroundColor: Colors.deepPurple[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // FAQ Section
            Expanded(
              child: ListView(
                children: faqData.map((faq) {
                  return ExpansionTile(
                    title: Text(faq['question']!,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(faq['answer']!,
                            style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            // Footer Section
            Divider(), // Divider to separate FAQ section from footer
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'FitSync',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Version 1.0.0',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Â© 2024 - FitSyncCo Ltd.',
                    textAlign: TextAlign.center,
                  ),
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
