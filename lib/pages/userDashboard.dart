import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:registration/constants/apikey.dart';
import 'package:registration/models/post_details.dart';
import 'package:registration/models/posts.dart';
import 'package:registration/pages/UpdatePage.dart';
import 'package:http/http.dart' as http;
import 'package:registration/pages/postDetails.dart';
import 'package:registration/widgets/post_container.dart';
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

          Row(
            mainAxisSize: MainAxisSize.max,
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
  List<Post> posts = [];

  void get_posts() async {
  String? token = await storage.read(key: 'authToken');

  if (token == null){
    print('Token not found');
  }
  try {
  http.Response response = await http.get(
    Uri.parse(Post_apikey),
    headers:  <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    },
  );
  var data = json.decode(response.body);
  print('Response data: $data'); // Print response data for debugging
  List<Post> fetchedPosts = [];
  data.forEach((post){
    Post p = Post(
      id: post['id'],
      title: post['title'],
      tags: post['tags'],
    );
    fetchedPosts.add(p);
  });
  setState(() {
    posts = fetchedPosts; // Update the posts list with fetched posts
  });
  print('Posts: $posts');
   } catch(e){
    print('error: $e');
   } // Print posts list for debugging
}

  void get_post_details(var id) async{
    String? token = await storage.read(key: 'authToken');

    http.Response response = await http.get(Uri.parse(Post_apikey+"/"+id),
    headers:  <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
    );
    if(response.statusCode==200){
      var data = json.decode(response.body);
      PostDetails details = PostDetails(id: data['id'], title: data['title'], content: data['content'], image: data['image'], tags: data['tags']);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => PostDetailsPage(id: details.id, title: details.title, content: details.content, image: details.image, tags: details.tags)
      ));
    }
    print(response.statusCode);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

      get_posts();

  }
  @override
Widget build(BuildContext context) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: posts.map((e) => PostContainer(
          id: e.id,
          title: e.title,
          onPressed: ()=> get_post_details(e.id.toString()) ,
          tags: e.tags)).toList(),
      ),
    ),
  );
}

}