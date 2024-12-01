import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final int level;
  final int currentExp;
  final int requiredExp;
  final Function(bool) onToggleTheme;
  final bool isDarkMode;

  FitsyncHomePage({
    required this.username,
    required this.level,
    required this.currentExp,
    required this.requiredExp,
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

  late int currentExp;
  late int level;
  final int requiredExp = 100;

  @override
  void initState() {
    super.initState();
    // Initialize local variables with widget values
    currentExp = widget.currentExp;
    level = widget.level;
    _fetchWeeklyChallenges();
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
              onPressed: () => Navigator.of(context).pop(),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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

  void _showAddWorkoutDialog() {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedWorkout = ""; // Track the selected workout

        return AlertDialog(
          title: Text('Select Your Workout'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min, // Minimize dialog size
                children: [
                  for (var workout in [
                    "Crunch's +5XP",
                    "Push-ups +5XP",
                    "Sit ups +5XP",
                    "Bicep curls +5XP",
                    "Leg curls +5XP"
                  ])
                    RadioListTile<String>(
                      title: Text(workout),
                      value: workout,
                      groupValue: selectedWorkout,
                      onChanged: (value) {
                        setState(() {
                          selectedWorkout = value!;
                        });
                      },
                    ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (selectedWorkout.isNotEmpty) {
                  Navigator.of(context).pop();

                  // Add 5 EXP
                  int newExp = currentExp + 5;

                  // Level-up logic
                  if (newExp >= requiredExp) {
                    int newLevel = level + 1;
                    newExp = newExp - requiredExp; // Carry over extra EXP if any

                    // Update Firestore with the new level and EXP
                    await _updateFirestore(newLevel, newExp);

                    setState(() {
                      level = newLevel;
                      currentExp = newExp;
                    });

                    // Show level-up dialog
                    _showLevelUpDialog(newLevel);
                  } else {
                    // Just update EXP in Firestore
                    await _updateFirestore(level, newExp);

                    setState(() {
                      currentExp = newExp;
                    });
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select a workout!")),
                  );
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  //Update the firestore with the newlevel and and updatedExp
  Future<void> _updateFirestore(int newLevel, int newExp) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Fitsync Authentication')
          .where('Username', isEqualTo: widget.username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;

        await FirebaseFirestore.instance
            .collection('Fitsync Authentication')
            .doc(doc.id)
            .update({
          'Level': newLevel,
          'currentExp': newExp,
        });
      }
    } catch (e) {
      print("Error updating Firestore: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update Firestore!')),
      );
    }
  }

  //Function to display the level up dialog
  void _showLevelUpDialog(int newLevel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You leveled up to Level $newLevel!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchFriendsData(List<String> friendsUsernames) async {
    List<Map<String, dynamic>> friendsData = [];
    for (var username in friendsUsernames) {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Fitsync Authentication')
          .where('Username', isEqualTo: username)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        friendsData.add(querySnapshot.docs.first.data() as Map<String, dynamic>);
      }
    }
    return friendsData;
  }


  @override
  Widget build(BuildContext context) {
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
                MaterialPageRoute(builder: (context) => FriendsPage(username: widget.username)),
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
                    username: widget.username,
                    level: widget.level,
                    currentExp: widget.currentExp,
                    requiredExp: widget.requiredExp,
                    onToggleTheme: widget.onToggleTheme,
                    isDarkMode: widget.isDarkMode,
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
                // Go the WorkoutList page
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
                // Go the Settings page
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
                // Go the Help page
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
            //Show the user's level and username
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Use StreamBuilder to show the level
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Fitsync Authentication')
                      .where('Username', isEqualTo: widget.username)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Text(
                        'Level: N/A',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      );
                    }

                    // Get the level
                    final userDoc = snapshot.data!.docs.first;
                    final level = userDoc['Level'] ?? 'N/A';

                    return Text(
                      'Level: $level',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    );
                  },
                ),

                // Show username
                Text(
                  widget.username,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),

            SizedBox(height: 20),

            //List of the workout tutorials
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
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
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

                                  SizedBox(height: 10),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: weeklyChallenges.length,
                                      itemBuilder: (context, index) {
                                        final challenge = weeklyChallenges[index];
                                        return Dismissible(
                                          key: UniqueKey(),
                                          direction: DismissDirection.endToStart,
                                          onDismissed: (direction) async {
                                            setState(() {
                                              //Remove challenge when the user swipes it
                                              weeklyChallenges.removeAt(index);
                                            });

                                            // Increase XP by 10
                                            int newExp = currentExp + 10;

                                            //Check for level
                                            if (newExp >= requiredExp) {
                                              int newLevel = level + 1;
                                              newExp = newExp - requiredExp;

                                              // Update Firestore with new level and XP
                                              await _updateFirestore(newLevel, newExp);

                                              setState(() {
                                                level = newLevel;
                                                currentExp = newExp;
                                              });

                                              // Show level-up dialog
                                              _showLevelUpDialog(newLevel);
                                            } else {
                                              // Update only XP in Firestore
                                              await _updateFirestore(level, newExp);

                                              setState(() {
                                                currentExp = newExp;
                                              });
                                            }

                                            //Show a confirmation SnackBar
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Completed ${challenge['title']}! +10 XP'),
                                              ),
                                            );
                                          },
                                          background: Container(
                                            color: Colors.green,
                                            alignment: Alignment.centerRight,
                                            padding: EdgeInsets.symmetric(horizontal: 20),
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.white,
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
                      child: SizedBox(
                        height: 300,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Friend's Leaderboard",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              FutureBuilder<QuerySnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('Fitsync Authentication')
                                    .where('Username', isEqualTo: widget.username)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  }

                                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                    return Center(
                                      child: Text(
                                        "User data not found.",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    );
                                  }

                                  final userDocId = snapshot.data!.docs.first.id;

                                  return StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('Fitsync Authentication')
                                        .doc(userDocId)
                                        .snapshots(),
                                    builder: (context, userSnapshot) {
                                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                                        return Center(child: CircularProgressIndicator());
                                      }

                                      if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                                        return Center(
                                          child: Text(
                                            "No user data available.",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        );
                                      }

                                      final currentUserData = userSnapshot.data!.data() as Map<String, dynamic>;
                                      final currentUser = {
                                        'Username': currentUserData['Username'] ?? 'Unknown User',
                                        'Level': currentUserData['Level'] ?? 1,
                                      };

                                      final friendsList = List<String>.from(currentUserData['friends'] ?? []);

                                      if (friendsList.isEmpty) {
                                        return Text(
                                          "No friends added yet.",
                                          style: TextStyle(fontSize: 16),
                                        );
                                      }

                                      return FutureBuilder<List<Map<String, dynamic>>>(
                                        future: _fetchFriendsData(friendsList),
                                        builder: (context, friendsSnapshot) {
                                          if (friendsSnapshot.connectionState == ConnectionState.waiting) {
                                            return Center(child: CircularProgressIndicator());
                                          }

                                          if (!friendsSnapshot.hasData || friendsSnapshot.data!.isEmpty) {
                                            return Text(
                                              "No data available for friends.",
                                              style: TextStyle(fontSize: 16),
                                            );
                                          }

                                          final friendsData = friendsSnapshot.data!;

                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: (friendsData
                                                .map((friend) => {
                                              'Username': friend['Username'],
                                              'Level': friend['Level'] ?? 1,
                                            })
                                                .toList()
                                              ..add(currentUser)
                                              ..sort((a, b) => (b['Level'] as int).compareTo(a['Level'] as int)))
                                                .asMap()
                                                .entries
                                                .map<Widget>((entry) {
                                              int index = entry.key;
                                              var friend = entry.value;
                                              return Text(
                                                "${index + 1}. ${friend['Username']} - Level ${friend['Level']}",
                                                style: TextStyle(fontSize: 16),
                                              );
                                            }).toList(),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            //Add workout
            Expanded(
              child: GestureDetector(
                onTap: _showAddWorkoutDialog,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        spreadRadius: 2,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _showAddWorkoutDialog,
                        child: Icon(
                          Icons.add_circle_outline,
                          size: 60,
                          color: Colors.deepPurple[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Add Completed Workout",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[700],
                        ),
                      ),
                    ],
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