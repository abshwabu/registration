import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:registration/constants/apikey.dart';

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

        // Optionally, you can automatically log in the user after registration
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
            ],
          ),
        ),
      ),
    );
  }
}
