import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:registration/constants/apikey.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class UpdatePage extends StatefulWidget {
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final storage = FlutterSecureStorage();
  final TextEditingController updatedUsernameController = TextEditingController();
  final TextEditingController updatedEmailController = TextEditingController();

  @override
  void dispose() {
    updatedUsernameController.dispose();
    updatedEmailController.dispose();
    super.dispose();
  }
  void updateUserInfo({String updatedUsername = '', String updatedEmail = ''}) async{
    // Add your logic to update user information
    // This is just a placeholder, replace it with your actual implementation
    updatedUsername = updatedUsernameController.text;
    updatedEmail = updatedEmailController.text;

    String? token = await storage.read(key: 'authtoken');

    http.Response response = await http.patch(
      Uri.parse(get_apikey),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(<String, dynamic>{
          'username': updatedUsername,
          'email': updatedEmail,
        }),

    );

    // After updating, you might want to navigate back to the user profile or another page
    Navigator.pop(context); // This will pop the current page and return to the previous page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update User Information'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Update your information:'),
            TextField(
              controller: updatedUsernameController,
              decoration: InputDecoration(
                labelText: 'Updated Username',
              ),
            ),
            TextField(
              controller: updatedEmailController,
              decoration: InputDecoration(
                labelText: 'Updated Email',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: updateUserInfo,
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
