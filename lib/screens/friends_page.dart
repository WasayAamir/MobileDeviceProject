import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsPage extends StatefulWidget {
  final String username; // Use username directly

  FriendsPage({required this.username}); // Constructor to accept username

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<String> friends = [];
  List<String> sentRequests = [];
  List<String> approved = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Fetch data for the user using their username
    _fetchFriendsData();
  }

  // Fetch data for friends, sent requests, and approved requests based on username
  void _fetchFriendsData() {
    FirebaseFirestore.instance
        .collection('Fitsync Authentication') // Firestore collection
        .where('Username', isEqualTo: widget.username) // Query by username
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      print('Fetched snapshot: ${snapshot.docs.length}'); // Debugging line
      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data() as Map<String, dynamic>;
        print('User data: $data'); // Debugging line
        setState(() {
          friends = List<String>.from(data['friends'] ?? []);
          sentRequests = List<String>.from(data['sentRequest'] ?? []);
          approved = List<String>.from(data['receivedRequests'] ?? []);
        });
      } else {
        print('No user found with username: ${widget.username}'); // Debugging line
      }
    });
  }

  // Send a friend request
  void _sendFriendRequest(String username) async {
    final collectionRef = FirebaseFirestore.instance.collection('Fitsync Authentication');

    try {
      // Find the recipient's document
      var querySnapshot = await collectionRef.where('Username', isEqualTo: username).get();

      if (querySnapshot.docs.isNotEmpty) {
        var recipientDoc = querySnapshot.docs.first;
        var recipientData = recipientDoc.data() as Map<String, dynamic>;

        // Get the recipient's `receivedRequests` list
        List<String> receivedRequests = List<String>.from(recipientData['receivedRequests'] ?? []);

        // Avoid duplicate requests
        if (receivedRequests.contains(widget.username)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Request already sent to $username.")),
          );
          return;
        }

        // Add the current user's username to the recipient's `receivedRequests`
        receivedRequests.add(widget.username);
        await collectionRef.doc(recipientDoc.id).update({
          'receivedRequests': receivedRequests,
        });

        // Add the recipient's username to the current user's `sentRequest`
        final currentUserDoc = await collectionRef.where('Username', isEqualTo: widget.username).get();
        if (currentUserDoc.docs.isNotEmpty) {
          var currentUserData = currentUserDoc.docs.first.data() as Map<String, dynamic>;
          List<String> sentRequests = List<String>.from(currentUserData['sentRequest'] ?? []);
          sentRequests.add(username);

          await collectionRef.doc(currentUserDoc.docs.first.id).update({
            'sentRequest': sentRequests,
          });

          setState(() {
            this.sentRequests.add(username); // Update local state
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Friend request sent to $username.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User $username not found.")),
        );
      }
    } catch (e) {
      print("Error sending friend request: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }


  // Accept a friend request and move it to the approved list
  void _acceptFriendRequest(String username) async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection('Fitsync Authentication');

      // Query the current user's document
      var currentUserQuery = await collectionRef.where('Username', isEqualTo: widget.username).get();
      if (currentUserQuery.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Current user not found.")),
        );
        return;
      }

      var currentUserDoc = currentUserQuery.docs.first;
      var currentUserData = currentUserDoc.data() as Map<String, dynamic>;

      // Query the sender's document
      var senderQuery = await collectionRef.where('Username', isEqualTo: username).get();
      if (senderQuery.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User $username not found.")),
        );
        return;
      }

      var senderDoc = senderQuery.docs.first;
      var senderData = senderDoc.data() as Map<String, dynamic>;

      // Update current user's "friends" and "receivedRequests"
      List<String> userFriends = List<String>.from(currentUserData['friends'] ?? []);
      List<String> userReceivedRequests = List<String>.from(currentUserData['receivedRequests'] ?? []);

      if (userReceivedRequests.contains(username)) {
        userFriends.add(username);
        userReceivedRequests.remove(username);

        await collectionRef.doc(currentUserDoc.id).update({
          'friends': userFriends,
          'receivedRequests': userReceivedRequests,
        });

        // Update sender's "friends"
        List<String> senderFriends = List<String>.from(senderData['friends'] ?? []);
        senderFriends.add(widget.username);

        await collectionRef.doc(senderDoc.id).update({
          'friends': senderFriends,
        });

        setState(() {
          approved.remove(username);
          friends.add(username);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$username has been added to your friends list.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No request found from $username.")),
        );
      }
    } catch (e) {
      print("Error accepting friend request: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to accept friend request. Please try again.")),
      );
    }
  }

  // Unsend a friend request and remove it from Firestore and local state
  void _unsendFriendRequest(String username) async {
    final collectionRef = FirebaseFirestore.instance.collection('Fitsync Authentication');

    try {
      // Find the recipient's document
      var recipientQuery = await collectionRef.where('Username', isEqualTo: username).get();

      if (recipientQuery.docs.isNotEmpty) {
        var recipientDoc = recipientQuery.docs.first;
        var recipientData = recipientDoc.data() as Map<String, dynamic>;

        // Remove the current user's username from the recipient's `receivedRequests`
        List<String> receivedRequests = List<String>.from(recipientData['receivedRequests'] ?? []);
        receivedRequests.remove(widget.username);
        await collectionRef.doc(recipientDoc.id).update({
          'receivedRequests': receivedRequests,
        });

        // Remove the recipient's username from the current user's `sentRequest`
        var currentUserQuery = await collectionRef.where('Username', isEqualTo: widget.username).get();
        if (currentUserQuery.docs.isNotEmpty) {
          var currentUserData = currentUserQuery.docs.first.data() as Map<String, dynamic>;
          List<String> sentRequests = List<String>.from(currentUserData['sentRequest'] ?? []);
          sentRequests.remove(username);

          await collectionRef.doc(currentUserQuery.docs.first.id).update({
            'sentRequest': sentRequests,
          });

          setState(() {
            this.sentRequests.remove(username); // Update local state
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Friend request to $username unsent.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User $username not found.")),
        );
      }
    } catch (e) {
      print("Error unsending friend request: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
        backgroundColor: Colors.deepPurple[400],
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddFriendDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
          tabs: [
            Tab(text: 'Friends'),
            Tab(text: 'Sent Requests'),
            Tab(text: 'Approved'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Friends Tab
          _buildFriendsList(friends, "No friends added yet.", false),

          // Sent Requests Tab
          _buildFriendsList(
            sentRequests,
            "No sent requests.",
            true,
            onAction: _unsendFriendRequest, // Action: Unsend
            buttonText: "Unsend",          // Button Text: Unsend
          ),

          // Approved Tab
          _buildFriendsList(
            approved,
            "No approved requests.",
            true,
            onAction: _acceptFriendRequest, // Action: Approve
            buttonText: "Approve",           // Button Text: Approve
          ),
        ],
      ),

    );
  }

  Widget _buildFriendsList(
      List<String> list,
      String emptyMessage,
      bool isActionable, {
        void Function(String username)? onAction, // Generic action for button
        String buttonText = "Action",            // Customizable button text
      }) {
    if (list.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(list[index]),
          trailing: isActionable
              ? ElevatedButton(
            onPressed: () => onAction?.call(list[index]),
            child: Text(buttonText), // Use the custom button text
          )
              : null,
        );
      },
    );
  }


  // Show a dialog to send a new friend request
  void _showAddFriendDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String friendUsername = '';
        return AlertDialog(
          title: Text('Add Friend'),
          content: TextField(
            onChanged: (value) {
              friendUsername = value;
            },
            decoration: InputDecoration(hintText: 'Enter username'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _sendFriendRequest(friendUsername);
              },
              child: Text('Send Request'),
            ),
          ],
        );
      },
    );
  }
}