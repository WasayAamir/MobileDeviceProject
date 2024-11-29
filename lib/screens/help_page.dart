import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  //FAQ section
  final List<Map<String, String>> faqData = [
    {
      'question': 'How do I track my level?',
      'answer': 'You can track your progress on the leveling screen by clicking the account button on the top right of your homepage.',
    },
    {
      'question': 'How do I change my workout plan?',
      'answer': 'You can select a new workout from the homepage or visit the "Workout Tutorials" section in the drawer to explore different exercises.',
    },
    {
      'question': 'What is the Friends Leaderboard?',
      'answer': 'The Friends Leaderboard shows your ranking compared to your friends based on your workout level and xp.',
    },
    {
      'question': 'How do I watch workout tutorials?',
      'answer': 'You can click on any workout tutorial image on the homepage, and a dialog will appear asking if you want to watch the tutorial video.',
    },
    {
      'question': 'How can I switch between light and dark mode?',
      'answer': 'You can change the mode of the app by going to "Settings" page and switching on the toggle.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(
        title: Text('Help'),
        backgroundColor: Colors.deepPurple[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //FAQ Section
            Expanded(
              child: ListView(
                children: faqData.map((faq) {
                  return ExpansionTile(
                    //Questions
                    title: Text(
                      faq['question']!,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      //Answers
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
            //Divider for footer section
            Divider(),

            //Footer app info
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //App name
                  Text(
                    'FitSync',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  //Version Info
                  Text(
                    'Version 1.0.0',
                    textAlign: TextAlign.center,
                  ),
                  //Copyright Info
                  Text(
                    '© 2024 - FitSyncCo Ltd.',
                    textAlign: TextAlign.center,
                  ),
                  //Description
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
