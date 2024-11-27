import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/slide_widget.dart';
import 'package:http/http.dart' as http;
import 'leveling_screen.dart';
import 'workout_list_page.dart';
import 'video_page.dart';
import 'help_page.dart';
import 'settings_page.dart';
import 'friends_page.dart';

class FitsyncHomePage extends StatefulWidget {
  final String username;
  final int level; // Add this
  final int currentExp; // Add this
  final int requiredExp; // Add this
  final Function(bool) onToggleTheme;
  final bool isDarkMode;

  FitsyncHomePage({
    required this.username,
    required this.level, // Add this
    required this.currentExp, // Add this
    required this.requiredExp, // Add this
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  _FitsyncHomePageState createState() => _FitsyncHomePageState();
}

class _FitsyncHomePageState extends State<FitsyncHomePage> {
  final String apiUrl = "https://my-json-server.typicode.com/Rahil2804/MockAPI/weekly_challenges";
  List<Map<String, dynamic>> weeklyChallenges = [];

  final List<Map<String, dynamic>> workouts = [
    {
      'title': "Crunch's Tutorial",
      'imageUrl': 'https://www.spotebi.com/wp-content/uploads/2014/10/crunches-exercise-illustration.jpg',
      'videoUrl': 'https://www.youtube.com/watch?v=yzg6OTbsmcQ',
      'sets': 3,
      'reps': 15,
    },
    {
      'title': "Push-Ups Tutorial",
      'imageUrl': 'https://tostpost.com/images/2018-Mar/28/da1c83d1c74739e363b38856d0a5b66b/1.jpg',
      'videoUrl': 'https://www.youtube.com/watch?v=_l3ySVKYVJ8',
      'sets': 4,
      'reps': 20,
    },
    {
      'title': "Sit-Ups Tutorial",
      'imageUrl': 'https://www.cdn.spotebi.com/wp-content/uploads/2014/10/squat-exercise-illustration.jpg',
      'videoUrl': 'https://www.youtube.com/watch?v=jDwoBqPH0jk&ab_channel=Howcast',
      'sets': 3,
      'reps': 12,
    },
    {
      'title': "Bicep Curls Tutorial",
      'imageUrl': 'https://i.pinimg.com/originals/8f/40/fd/8f40fdace543223c4043dfd1adf36cf6.png',
      'videoUrl': 'https://www.youtube.com/watch?v=ykJmrZ5v0Oo&ab_channel=Howcast',
      'sets': 4,
      'reps': 10,
    },
    {
      'title': "Leg Curls Tutorial",
      'imageUrl': 'https://th.bing.com/th/id/R.5f2642f47b331e04d7b144b6813325c1?rik=OqYVd7pXpK4DiA&riu=http%3a%2f%2fworkoutlabs.com%2fwp-content%2fuploads%2fwatermarked%2fSeated_Leg_curl.png&ehk=8M7eWzedvaSSyv8JYhrI98Ld4WwTjo9hiw7Up8a4Ei4%3d&risl=&pid=ImgRaw&r=0',
      'videoUrl': 'https://www.youtube.com/watch?v=Orxowest56U&ab_channel=RenaissancePeriodization',
      'sets': 4,
      'reps': 12,
    },
  ];

  //final int level = 13;
  //final int currentExp = 50;
  //final int requiredExp = 100;

  @override
  void initState() {
    super.initState();
    _fetchWeeklyChallenges(); // Fetching weekly challenges when the widget is initialized
  }

  // Function to fetch weekly challenges from the provided API URL
  Future<void> _fetchWeeklyChallenges() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          weeklyChallenges = data.map((challenge) => {
            'id': challenge['id'],
            'title': challenge['title'],
            'description': challenge['description'],
          }).toList();
        });
      } else {
        throw Exception("Failed to load challenges");
      }
    } catch (e) {
      print(e); // Print error if fetching challenges fails
    }
  }

  // Function to show a dialog when user taps on a workout
  void _showWorkoutDialog(BuildContext context, Map<String, dynamic> workout) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(workout['title']),
          content: Text('Do you want to do this workout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Dismiss dialog
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPage(
                      videoUrl: workout['videoUrl'],
                      title: workout['title'],
                      sets: workout['sets'],
                      reps: workout['reps'],
                    ),
                  ),
                );
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int currentExp = widget.currentExp;
    int requiredExp = widget.requiredExp;
    int level = widget.level;
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitsync Homepage'),
        backgroundColor: Colors.deepPurple[400],
        actions: [
          IconButton(
            icon: Icon(Icons.people),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => FriendsPage()
                  ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LevelUpScreen(
                    username: widget.username,          // Pass the username
                    level: widget.level,                // Pass the level
                    currentExp: widget.currentExp,      // Pass the current experience
                    requiredExp: widget.requiredExp,    // Pass the required experience
                    onToggleTheme: widget.onToggleTheme, // Pass the theme toggle function
                    isDarkMode: widget.isDarkMode,      // Pass the dark mode status
                  ),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple[400],
              ),
              child: Text(
                'Fitsync Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: Text('Workout Tutorials'),
              onTap: () {
                // Navigate to the workout list page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutListPage(workouts: workouts),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                // Navigate to the settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(
                      onToggleTheme: widget.onToggleTheme,
                      isDarkMode: widget.isDarkMode,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Help'),
              onTap: () {
                // Navigate to the help page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying the user's level and username at the top
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Level: $level',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.username,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Horizontal list of workout tutorial widgets
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: workouts.map((workout) {
                  return GestureDetector(
                    onTap: () => _showWorkoutDialog(context, workout),
                    child: SlideWidgetWithImage(
                      title: workout['title'],
                      imageUrl: workout['imageUrl'],
                      videoUrl: workout['videoUrl'],
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),

            // Weekly challenges and friend's leaderboard side by side
            Expanded(
              child: Row(
                children: [
                  // Weekly Challenges Section
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Weekly Challenges',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: weeklyChallenges.length,
                              itemBuilder: (context, index) {
                                final challenge = weeklyChallenges[index];
                                return Dismissible(
                                  key: UniqueKey(), // Ensure each key is unique
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    setState(() {
                                      // Remove the challenge from the list when swiped
                                      weeklyChallenges.removeAt(index);
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${challenge['title']} dismissed'),
                                      ),
                                    );
                                  },
                                  background: Container(
                                    color: Colors.green,
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Card(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    child: ListTile(
                                      title: Text(challenge['title']),
                                      subtitle: Text(challenge['description']),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),

                  // Friend's Leaderboard Section
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.yellow[800],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Friend's Leaderboard",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text('1. Friend 1 - Score'),
                          Text('2. Friend 2 - Score'),
                          Text('3. Friend 3 - Score'),
                          Text('4. Friend 4 - Score'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // User experience level and progress section
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Level $level",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(widget.username, style: TextStyle(fontSize: 20)),
                    SizedBox(height: 8),
                    Stack(
                      children: [
                        Container(
                          height: 10.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      "$currentExp / $requiredExp EXP",
                      style: TextStyle(fontSize: 12.0, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}