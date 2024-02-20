import 'package:flutter/material.dart';

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
    return  PostDetailsContainer(
        id: id,
        title: title,
        content: content,
        image: image.isNotEmpty?image:'No image',
        tags: tags,
      );
  }
}
