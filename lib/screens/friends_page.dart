import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//friends page class
class FriendsPage extends StatefulWidget {
  final String username;
  //constructor
  FriendsPage({required this.username});

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

    //fetch data using username
    _fetchFriendsData();
  }

  //fetch data for friends, requests, sent requests by username.
  void _fetchFriendsData() {
    FirebaseFirestore.instance
    //collection in firestore
        .collection('Fitsync Authentication')
        .where('Username', isEqualTo: widget.username)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      print('Fetched snapshot: ${snapshot.docs.length}');
      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data() as Map<String, dynamic>;
        print('User data: $data');
        //
        setState(() {
          friends = List<String>.from(data['friends'] ?? []);
          sentRequests = List<String>.from(data['sentRequest'] ?? []);
          approved = List<String>.from(data['receivedRequests'] ?? []);
        });
      }//if no user found
      else {
        print('No user with username: ${widget.username}');
      }
    });
  }

  //friend request
  void _sendFriendRequest(String username) async {
    final collectionRef = FirebaseFirestore.instance.collection('Fitsync Authentication');

    try {
      //find document
      var querySnapshot = await collectionRef.where('Username', isEqualTo: username).get();

      if (querySnapshot.docs.isNotEmpty) {
        var recipientDoc = querySnapshot.docs.first;
        var recipientData = recipientDoc.data() as Map<String, dynamic>;

        //received requests list
        List<String> receivedRequests = List<String>.from(recipientData['receivedRequests'] ?? []);

        //don't send duplicates
        if (receivedRequests.contains(widget.username)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Request already sent to $username.")),
          );
          return;
        }

        //add user name to received
        receivedRequests.add(widget.username);
        await collectionRef.doc(recipientDoc.id).update({
          'receivedRequests': receivedRequests,
        });


        final currentUserDoc = await collectionRef.where('Username', isEqualTo: widget.username).get();
        if (currentUserDoc.docs.isNotEmpty) {
          var currentUserData = currentUserDoc.docs.first.data() as Map<String, dynamic>;
          List<String> sentRequests = List<String>.from(currentUserData['sentRequest'] ?? []);

          //no duplicates
          if (!sentRequests.contains(username)) {
            sentRequests.add(username);

            await collectionRef.doc(currentUserDoc.docs.first.id).update({
              'sentRequest': sentRequests,
            });

            setState(() {
              this.sentRequests = List<String>.from(sentRequests); // Sync local state with Firestore
            });
            //inform friend request sent
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Friend request sent to $username.")),
            );
          }
        }
      } else {//if no user
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




  //accepting friend request
  void _acceptFriendRequest(String username) async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection('Fitsync Authentication');

      //Query current user's document
      var currentUserQuery = await collectionRef.where('Username', isEqualTo: widget.username).get();
      if (currentUserQuery.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Current user not found.")),
        );
        return;
      }

      var currentUserDoc = currentUserQuery.docs.first;
      var currentUserData = currentUserDoc.data() as Map<String, dynamic>;

      //Query sender's document
      var senderQuery = await collectionRef.where('Username', isEqualTo: username).get();
      if (senderQuery.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User $username not found.")),
        );
        return;
      }

      var senderDoc = senderQuery.docs.first;
      var senderData = senderDoc.data() as Map<String, dynamic>;

      //updating users friends and received requests
      List<String> userFriends = List<String>.from(currentUserData['friends'] ?? []);
      List<String> userReceivedRequests = List<String>.from(currentUserData['receivedRequests'] ?? []);

      if (userReceivedRequests.contains(username)) {
        userFriends.add(username);
        userReceivedRequests.remove(username);

        await collectionRef.doc(currentUserDoc.id).update({
          'friends': userFriends,
          'receivedRequests': userReceivedRequests,
        });

        List<String> senderFriends = List<String>.from(senderData['friends'] ?? []);
        senderFriends.add(widget.username);

        List<String> senderSentRequests = List<String>.from(senderData['sentRequest'] ?? []);
        senderSentRequests.removeWhere((request) => request == widget.username);

        await collectionRef.doc(senderDoc.id).update({
          'friends': senderFriends,
          'sentRequest': senderSentRequests,
        });

        //syncing local state with firestore
        setState(() {
          approved.remove(username);
          friends.add(username);
          sentRequests = List<String>.from(senderSentRequests);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$username added to your friends list.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No request found from $username.")),
        );
      }
    } catch (e) {
      print("Error accepting friend request: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed accepting friend request. Please try again.")),
      );
    }
  }



  //unsending friend request
  void _unsendFriendRequest(String username) async {
    final collectionRef = FirebaseFirestore.instance.collection('Fitsync Authentication');

    try {
      //find document of recipient
      var recipientQuery = await collectionRef.where('Username', isEqualTo: username).get();

      if (recipientQuery.docs.isNotEmpty) {
        var recipientDoc = recipientQuery.docs.first;
        var recipientData = recipientDoc.data() as Map<String, dynamic>;

        List<String> receivedRequests = List<String>.from(recipientData['receivedRequests'] ?? []);
        receivedRequests.remove(widget.username);
        await collectionRef.doc(recipientDoc.id).update({
          'receivedRequests': receivedRequests,
        });

        var currentUserQuery = await collectionRef.where('Username', isEqualTo: widget.username).get();
        if (currentUserQuery.docs.isNotEmpty) {
          var currentUserData = currentUserQuery.docs.first.data() as Map<String, dynamic>;
          List<String> sentRequests = List<String>.from(currentUserData['sentRequest'] ?? []);
          sentRequests.remove(username);

          await collectionRef.doc(currentUserQuery.docs.first.id).update({
            'sentRequest': sentRequests,
          });
         //updating local state
          setState(() {
            this.sentRequests.remove(username);
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
      //app bar friends
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
            Tab(text: 'Approve'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          //Friends Tab
          _buildFriendsList(friends, "No friends added yet.", false),
          //requests tab
          _buildFriendsList(
            sentRequests,
            "No sent requests.",
            true,
            onAction: _unsendFriendRequest,
            buttonText: "Unsend",
          ),

          //approve tab
          _buildFriendsList(
            approved,
            "No approved requests.",
            true,
            onAction: _acceptFriendRequest,
            buttonText: "Approve",
          ),
        ],
      ),

    );
  }

  Widget _buildFriendsList(
      List<String> list, String emptyMessage, bool isActionable,
      {void Function(String username)? onAction, String buttonText = "Action"}) {
    if (list.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    //take out duplicates
    final uniqueList = list.toSet().toList();

    return ListView.builder(
      itemCount: uniqueList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(uniqueList[index]),
          trailing: isActionable
              ? ElevatedButton(
            onPressed: () => onAction?.call(uniqueList[index]),
            child: Text(buttonText),
          )
              : null,
        );
      },
    );
  }



  //dialog for adding friend
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