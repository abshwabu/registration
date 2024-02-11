// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:registration/constants/apikey.dart';
import 'package:registration/pages/registration.dart';
// import 'package:registration/pages/UserProfilePage.dart';
import 'package:registration/pages/userDashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isMounted = true;
  final storage = FlutterSecureStorage();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    fetchAll();
    super.initState();
  }

  @override
  void dispose() {
    _isMounted = false;
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> fetchAll() async {
    try {
      http.Response response = await http.get(Uri.parse(get_apikey));
      var data = response.body;
      var str = jsonDecode(data);
      if (_isMounted) {
        print(str);
      }
    } catch (e) {
      if (_isMounted) {
        print(e);
      }
    }
  }

  Future<void> _postUser({String username = '', String password = ''}) async {
    try {
      http.Response response = await http.post(
        Uri.parse(create_apikey),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'username': username,
          'password': password,
          'email': 'john.doe@example.com',
        }),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response to extract the token
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        String token = jsonResponse['token'];

        // Store the token securely
        await storage.write(key: 'authToken', value: token);

        // Use the token in future requests
        // Fetch user details using the token
        http.Response userResponse = await http.get(
          Uri.parse(get_apikey),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token $token',
          },
        );

        if (userResponse.statusCode == 200) {
          // Parse user details
          Map<String, dynamic> userJson = json.decode(userResponse.body);
          String fetchedUsername = userJson['username'];
          String fetchedEmail = userJson['email'];

          // Navigate to the user profile page with the fetched details
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserDashboard(
                username: fetchedUsername,
                email: fetchedEmail,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error fetching user details: ${userResponse.statusCode} - ${userResponse.body}'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.statusCode} - ${response.body}'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void navigateToLoginPage() {
    // Navigate to the login page (assuming LoginPage is your login page)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login page'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'username',
                  hintText: 'username',
                  icon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              Gap(10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'password',
                  hintText: 'password',
                  icon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              Gap(10),
              ElevatedButton(
                onPressed: () => _postUser(
                  username: usernameController.text,
                  password: passwordController.text,
                ),
                child: Text('Login'),
              ),
              Gap(10),
              GestureDetector(
                onTap: navigateToLoginPage,
                child: Text(
                  'Already have an account? Log in.',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
