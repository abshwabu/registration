import 'package:flutter/material.dart';

class PostDetailsPage extends StatelessWidget {
  final id;
  final title;
  final content;
  final image;
  final tags;
  const PostDetailsPage({super.key, required this.id, required this.title, required this.content, required this.image, required this.tags});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}