import 'package:flutter/material.dart';
import 'video_page.dart';

// This widget displays a list of workouts available for users
class WorkoutListPage extends StatelessWidget {
  // List of workouts containing data like title, image, video URL, etc.
  final List<Map<String, dynamic>> workouts;

  // Constructor to initialize the workouts list
  WorkoutListPage({required this.workouts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with title
      appBar: AppBar(
        title: Text('Workout Tutorials'), // Title of the app bar
        backgroundColor: Colors.deepPurple[400], // Background color of the app bar
      ),

      // Body of the page that contains the list of workouts
      body: ListView.builder(
        itemCount: workouts.length, // Number of items in the list
        itemBuilder: (context, index) {
          // Extract a single workout from the list
          final workout = workouts[index];

          // Return a ListTile for each workout
          return ListTile(
            leading: Image.network(workout['imageUrl']), // Display an image of the workout
            title: Text(workout['title']), // Display the title of the workout
            trailing: Icon(Icons.arrow_forward), // Icon to indicate navigation
            onTap: () {
              // When a workout is tapped, navigate to the corresponding video page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPage(
                    videoUrl: workout['videoUrl'], // URL of the workout video
                    title: workout['title'], // Title of the workout
                    sets: workout['sets'], // Number of sets for the workout
                    reps: workout['reps'], // Number of repetitions for the workout
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
