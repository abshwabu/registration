import 'package:flutter/material.dart';
import 'package:registration/pages/UpdatePage.dart';

class UserDashboard extends StatelessWidget {
  final String username;
  final String email;
  const UserDashboard({super.key,required this.username,required this.email});

  void navigateToUpdatePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdatePage(username: username, email: email,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
        backgroundColor: Colors.green,
      ),
    );
  }
}