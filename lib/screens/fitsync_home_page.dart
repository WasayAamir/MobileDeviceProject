import 'package:flutter/material.dart';
import '../widgets/slide_widget.dart';
import '../widgets/progress_bar.dart';

class FitsyncHomePage extends StatefulWidget {
  @override
  _FitsyncHomePageState createState() => _FitsyncHomePageState();
}

class _FitsyncHomePageState extends State<FitsyncHomePage> {
  bool isSideNavOpen = false;

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
                  SlideWidgetWithImage(
                    title: "Crunch's Tutorial",
                    imageUrl: 'https://www.spotebi.com/wp-content/uploads/2014/10/crunches-exercise-illustration.jpg',
                  ),
                  SlideWidget(title: 'Widget 2'),
                  SlideWidget(title: 'Widget 3'),
                  SlideWidget(title: 'Widget 4'),
                  SlideWidget(title: 'Widget 5'),
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