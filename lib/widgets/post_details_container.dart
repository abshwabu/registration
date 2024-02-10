import 'package:flutter/material.dart';

class PostDetailsContainer extends StatelessWidget {
  final int id;
  final String title;
  final String content;
  final List tags;
  final String image;
  const PostDetailsContainer({super.key, required this.id, required this.title, required this.content, required this.tags, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Post'),
        backgroundColor: Colors.green,
      ),
      body: Container(
            width: double.infinity,
            height: 500,
            decoration:const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5)
              )
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(
                    title,
                    style:const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal
                    ),),
                    Image.network(image)
                ],
              ),
            ),
          ),
    );
  }
}