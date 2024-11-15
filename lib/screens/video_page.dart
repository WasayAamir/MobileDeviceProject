import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// Stateful widget to display video and workout details
class VideoPage extends StatefulWidget {
  final String videoUrl; // URL of the YouTube video to play
  final String title; // Title of the video/workout
  final int sets; // Number of sets for the workout
  final int reps; // Number of repetitions for the workout

  // Constructor to initialize the video page with necessary data
  VideoPage({
    required this.videoUrl,
    required this.title,
    required this.sets,
    required this.reps,
  });

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late YoutubePlayerController _controller; // Controller for the YouTube player

  @override
  void initState() {
    super.initState();

    // Extract the video ID from the provided video URL
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    // Initialize the YouTube player controller with the video ID
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: YoutubePlayerFlags(
        autoPlay: true, // Automatically play the video when loaded
        mute: false, // Video will not be muted by default
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the YouTube player controller to release resources
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with the workout title as its label
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple,
      ),

      // Main content of the video page
      body: Padding(
        padding: const EdgeInsets.all(16.0), // General padding for the content
        child: Column(
          children: [
            // YouTube Player widget to play the video
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true, // Show video progress bar
              progressIndicatorColor: Colors.blueAccent, // Set progress bar color
            ),

            SizedBox(height: 20), // Space between the video and the workout details

            // Workout Details Section Title
            Text(
              'Workout Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10), // Space between the title and the details table

            // Table displaying workout sets and repetitions
            Table(
              border: TableBorder.all(color: Colors.black), // Add border to the table
              children: [
                // Header row for Sets and Reps
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Sets',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Reps',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                // Data row for the provided sets and reps
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${widget.sets}', // Display the number of sets
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${widget.reps}', // Display the number of reps
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
