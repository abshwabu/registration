// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, unused_field, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:registration/constants/apikey.dart';
import 'package:registration/pages/UserProfilePage.dart';
import 'package:registration/pages/login.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _isMounted = true;
  final storage = FlutterSecureStorage();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _isMounted = false;
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
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
        http.Response securedResponse = await http.get(
          Uri.parse(get_apikey),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token $token',
          },
        );
        print(securedResponse.body);

        // Handle securedResponse as needed

        setState(() {
          // Update the UI or perform any other actions
        });
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
              builder: (context) => UserProfilePage(
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

  Future<void> registerUser({String username = '', String password = '', String email = ''}) async {
    try {
      http.Response response = await http.post(
        Uri.parse(register_apikey), // Adjust the API endpoint as needed
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'username': username,
          'password': password,
          'email': email,
        }),
      );

      if (response.statusCode == 201) {
        // Registration successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful!'),
            duration: Duration(seconds: 3),
          ),
        );

        _postUser(username: username, password: password);
        // Modify the code to handle the login logic based on your requirements
        // _postUser(username: username, password: password);

        setState(() {
          // Update the UI or perform any other actions
        });
      } else {
        // Registration failed
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
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration page'),
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
                  labelText: 'Username',
                  hintText: 'Enter your username',
                  icon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              Gap(10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  icon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              Gap(10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  icon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              Gap(10),
              ElevatedButton(
                onPressed: () => registerUser(
                  username: usernameController.text,
                  password: passwordController.text,
                  email: emailController.text,
                ),
                child: Text('Register'),
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
