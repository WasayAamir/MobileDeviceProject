import 'package:flutter/material.dart';
import '../widgets/slide_widget.dart';
import '../widgets/progress_bar.dart';

class FitsyncHomePage extends StatefulWidget {
  @override
  _FitsyncHomePageState createState() => _FitsyncHomePageState();
}

class _FitsyncHomePageState extends State<FitsyncHomePage> {
  bool isSideNavOpen = false;

  // Dialog function to confirm workout
  void _showWorkoutDialog(BuildContext context, String workoutName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(workoutName),
          content: Text('Do you want to do this workout?'),
          actions: [
            TextButton(
              onPressed: () {
                // 'No' action - Dismiss dialog
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                // 'Yes' action - Proceed with workout
                Navigator.of(context).pop();
                // Additional action can be added here if needed
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitsync Homepage'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.people),
            onPressed: () {
              // Handle friend's list
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Navigate to Login Page
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text('Fitsync Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: Text('Workouts'),
              onTap: () {
                // Handle navigation to Workouts
              },
            ),
            ListTile(
              title: Text('Tutorials'),
              onTap: () {
                // Handle navigation to Tutorials
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                // Handle navigation to Settings
              },
            ),
            ListTile(
              title: Text('Help'),
              onTap: () {
                // Handle navigation to Help
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Level: 13', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('WasayAamir', style: TextStyle(fontSize: 20)),
              ],
            ),
            SizedBox(height: 20),
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: () => _showWorkoutDialog(context, "Crunch's Tutorial"),
                    child: SlideWidgetWithImage(
                      title: "Crunch's Tutorial",
                      imageUrl: 'https://www.spotebi.com/wp-content/uploads/2014/10/crunches-exercise-illustration.jpg',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showWorkoutDialog(context, "Push-Ups Tutorial"),
                    child: SlideWidgetWithImage(
                      title: "Push-Ups Tutorial",
                      imageUrl: 'https://tostpost.com/images/2018-Mar/28/da1c83d1c74739e363b38856d0a5b66b/1.jpg',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showWorkoutDialog(context, "Sit-Ups Tutorial"),
                    child: SlideWidgetWithImage(
                      title: "Sit-Ups Tutorial",
                      imageUrl: 'https://www.cdn.spotebi.com/wp-content/uploads/2014/10/squat-exercise-illustration.jpg',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showWorkoutDialog(context, "Bicep Curls Tutorial"),
                    child: SlideWidgetWithImage(
                      title: 'Bicep Curls Tutorial',
                      imageUrl: 'https://i.pinimg.com/originals/8f/40/fd/8f40fdace543223c4043dfd1adf36cf6.png',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showWorkoutDialog(context, "Leg Curls Tutorial"),
                    child: SlideWidgetWithImage(
                      title: 'Leg Curls Tutorial',
                      imageUrl: 'https://th.bing.com/th/id/R.5f2642f47b331e04d7b144b6813325c1?rik=OqYVd7pXpK4DiA&riu=http%3a%2f%2fworkoutlabs.com%2fwp-content%2fuploads%2fwatermarked%2fSeated_Leg_curl.png&ehk=8M7eWzedvaSSyv8JYhrI98Ld4WwTjo9hiw7Up8a4Ei4%3d&risl=&pid=ImgRaw&r=0',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Progress on Goals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        ProgressBar(label: 'Goal 1', value: 0.7),
                        SizedBox(height: 10),
                        ProgressBar(label: 'Goal 2', value: 0.4),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Friend's Leaderboard", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text('1. Friend 1 - Score'),
                        Text('2. Friend 2 - Score'),
                        Text('3. Friend 3 - Score'),
                        Text('4. Friend 4 - Score'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Stay consistent and earn rewards!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
