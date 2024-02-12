import 'package:flutter/material.dart';
import 'package:registration/pages/addProduct.dart';
import 'package:registration/widgets/post_details_container.dart';

class PostDetailsPage extends StatelessWidget {
  final int id;
  final String title;
  final String content;
  final String image;
  final List tags;
  const PostDetailsPage({super.key, required this.id, required this.title, required this.content, required this.image, required this.tags});

  void navigateToAddPostPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPostPage()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PostDetailsContainer(
          id: this.id,
          title: this.title,
          content: this.content,
          image: this.image,
          tags: this.tags
        ),
        ElevatedButton(
              onPressed: ()=> navigateToAddPostPage(context),
              child:const Text('Add Post'),
            )
      ],
    );
  }
}