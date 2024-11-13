import 'package:flutter/material.dart';
import 'video_page.dart';

class WorkoutListPage extends StatelessWidget {
  final List<Map<String, dynamic>> workouts;

  WorkoutListPage({required this.workouts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Tutorials'),
        backgroundColor: Colors.deepPurple[400],
      ),
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return ListTile(
            leading: Image.network(workout['imageUrl']),
            title: Text(workout['title']),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
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
          );
        },
      ),
    );
  }
}
