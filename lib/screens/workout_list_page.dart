import 'package:flutter/material.dart';
import 'video_page.dart';

//class WorkListPage
class WorkoutListPage extends StatelessWidget {
  //list of workouts
  final List<Map<String, dynamic>> workouts;

  //initialize workouts list
  WorkoutListPage({required this.workouts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title
        title: Text('Workout Tutorials'),
        backgroundColor: Colors.deepPurple[400],
      ),

      //list workouts
      body: ListView.builder(
        //number of workouts
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          //workout index
          final workout = workouts[index];

          //return ListTil for workout
          return ListTile(
            leading: Image.network(workout['imageUrl']),
            title: Text(workout['title']),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              //on tap to go to video page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPage(
                    //url of video
                    videoUrl: workout['videoUrl'],
                    //title, sets, and reps of workout
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
