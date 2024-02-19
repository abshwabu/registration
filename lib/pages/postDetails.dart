import 'package:flutter/material.dart';
import 'package:registration/pages/addProduct.dart';
import 'package:registration/widgets/post_details_container.dart';

class PostDetailsPage extends StatelessWidget {
  final int id;
  final String title;
  final String content;
  final String image;
  final List tags;
  const PostDetailsPage({
    Key? key,
    required this.id,
    required this.title,
    required this.content,
    required this.image,
    required this.tags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: PostDetailsContainer(
        id: id,
        title: title,
        content: content,
        image: image,
        tags: tags,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the add post page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPostPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
