import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  final String username;
  final String email;

  UserProfilePage({required this.username, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Username: $username'),
            SizedBox(height: 10),
            Text('Email: $email'),
          ],
        ),
      ),
    );
  }
}
