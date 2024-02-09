import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:registration/constants/apikey.dart';
import 'package:registration/pages/UpdatePage.dart';
import 'package:http/http.dart' as http;
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
      body: Center(
        child: Column(children: [
          Row(
            children: [
              GestureDetector(
              onTap: () => navigateToUpdatePage(context),
              child: Text(
                'Username: $username (Click to Update)',
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(width: 10,),
            Text('Email: $email'),
            ],
          ),
          PostList(),
        ]),
      ),
    );
  }
}

class PostList extends StatefulWidget {

  const PostList({super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final storage = FlutterSecureStorage();
  List<dynamic> post = [];

  void get_posts() async {
    String? token = await storage.read(key: 'authToken');

    if (token == null){
      print('Token not found');
    }
    http.Response response = await http.get(
      Uri.parse(Post_apikey),
      headers:  <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
    );
    String? data = response.body;
    post = jsonDecode(data);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_posts();
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: post.length,
      itemBuilder: (context, index){
        return ListTile(
          title: Text(post[index]['title'] ??''),
          subtitle: Text(post[index]['content'] ??'')
        );
      },
    );
  }
}