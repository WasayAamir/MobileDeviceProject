import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeeklyChallengesPage extends StatefulWidget {
  @override
  _WeeklyChallengesPageState createState() => _WeeklyChallengesPageState();
}

class _WeeklyChallengesPageState extends State<WeeklyChallengesPage> {
  List<Map<String, dynamic>> _challenges = [];
  final String apiUrl =
      "https://my-json-server.typicode.com/Rahil2804/MockAPI/weekly_challenges"; // Replace with your JSON API link

  @override
  void initState() {
    super.initState();
    _fetchChallenges(); // Load challenges from the API when the page loads
  }

  // Fetch challenges from the API
  Future<void> _fetchChallenges() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _challenges = data
              .map((challenge) => {
            'id': challenge['id'],
            'title': challenge['title'],
            'description': challenge['description'],
            'isCompleted': challenge['isCompleted'],
          })
              .toList();
        });
      } else {
        throw Exception("Failed to load challenges");
      }
    } catch (e) {
      print(e);
      // Handle error appropriately (e.g., show a Snackbar or error widget)
    }
  }

  // Toggle challenge completion
  Future<void> _toggleCompletion(int id, bool isCompleted) async {
    // Since we can't change the remote mock API data,
    // let's just simulate toggling the completion locally.
    setState(() {
      final index = _challenges.indexWhere((challenge) => challenge['id'] == id);
      if (index != -1) {
        _challenges[index]['isCompleted'] = isCompleted ? 0 : 1;
      }
    });
  }

  // Delete a challenge (Only locally, as we're working with a mock API)
  Future<void> _deleteChallenge(int id) async {
    setState(() {
      _challenges.removeWhere((challenge) => challenge['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Challenges'),
        backgroundColor: Colors.deepPurple[400],
      ),
      body: _challenges.isEmpty
          ? Center(child: Text('No challenges available.'))
          : ListView.builder(
        itemCount: _challenges.length,
        itemBuilder: (context, index) {
          final challenge = _challenges[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: ListTile(
              title: Text(challenge['title']),
              subtitle: Text(challenge['description']),
              trailing: IconButton(
                icon: Icon(
                  challenge['isCompleted'] == 1
                      ? Icons.check_circle
                      : Icons.check_circle_outline,
                  color: challenge['isCompleted'] == 1
                      ? Colors.green
                      : Colors.grey,
                ),
                onPressed: () {
                  _toggleCompletion(
                      challenge['id'], challenge['isCompleted'] == 1);
                },
              ),
              onLongPress: () {
                _deleteChallenge(challenge['id']);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Since we're using a mock API, adding new challenges is simulated only locally
          setState(() {
            _challenges.add({
              'id': _challenges.length + 1, // Temporary ID for demonstration
              'title': 'New Challenge',
              'description': 'Complete 30 squats each day this week',
              'isCompleted': 0,
            });
          });
        },
        backgroundColor: Colors.deepPurple[400],
        child: Icon(Icons.add),
      ),
    );
  }
}
