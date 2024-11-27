import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Local lists to manage friends, sent requests, and approved requests
  List<String> friends = ["JohnDoe", "JaneSmith"];
  List<String> sentRequests = ["AliceWonder"];
  List<String> approved = ["BobMiller"];
  List<String> allUsers = ["JohnDoe", "JaneSmith", "AliceWonder", "BobMiller", "HarryPotter"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  // Send a friend request
  void _sendFriendRequest(String username) {
    if (!allUsers.contains(username)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User $username does not exist")),
      );
      return;
    }

    if (friends.contains(username)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$username is already your friend")),
      );
      return;
    }

    if (sentRequests.contains(username)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request already sent to $username")),
      );
      return;
    }

    setState(() {
      sentRequests.add(username);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Friend request sent to $username")),
    );
  }

  // Accept a friend request and move it to the approved list
  void _acceptFriendRequest(String username) {
    if (!sentRequests.contains(username)) return;

    setState(() {
      sentRequests.remove(username);
      approved.add(username);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Friend request from $username approved")),
    );
  }

  // Move an approved friend to the friends list
  void _addFriendFromApproved(String username) {
    if (!approved.contains(username)) return;

    setState(() {
      approved.remove(username);
      friends.add(username);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$username has been added to your friends list")),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddFriendDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
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
          _buildFriendsList(sentRequests, "No sent requests.", true, onAcceptRequest: _acceptFriendRequest),

          // Approved Tab
          _buildFriendsList(approved, "No approved requests.", true, onAcceptRequest: _addFriendFromApproved),
        ],
      ),
    );
  }

  Widget _buildFriendsList(
      List<String> list,
      String emptyMessage,
      bool isActionable, {
        void Function(String username)? onAcceptRequest,
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
            onPressed: () => onAcceptRequest?.call(list[index]),
            child: Text("Accept"),
          )
              : null,
        );
      },
    );
  }
}
