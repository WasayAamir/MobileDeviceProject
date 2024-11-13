import 'package:flutter/material.dart';
import '../screens/video_page.dart';

class SlideWidget extends StatelessWidget {
  final String title;

  SlideWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class SlideWidgetWithImage extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String videoUrl;

  SlideWidgetWithImage({
    required this.title,
    required this.imageUrl,
    required this.videoUrl,
  });

  // Function to show workout dialog
  void _showWorkoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text('Do you want to do this workout?'),
          actions: [
            TextButton(
              onPressed: () {
                // Dismiss dialog
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to Video Page if 'Yes' is pressed
                Navigator.of(context).pop();  // Close dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPage(
                      videoUrl: videoUrl,
                      title: title,
                      sets: 3, // Example value for sets
                      reps: 15, // Example value for reps
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
    return GestureDetector(
      onTap: () {
        _showWorkoutDialog(context);  // Show the dialog on tap
      },
      child: Container(
        width: 150,
        margin: EdgeInsets.only(right: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.black54,
            padding: EdgeInsets.all(4),
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
