import 'package:flutter/material.dart';

class PostContainer extends StatelessWidget {
  final int id;
  final String title;
  final Function onPressed;
  final List tags;

  const PostContainer({super.key, required this.id, required this.title, required this.onPressed, required this.tags});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: ()=> onPressed(),
        child: Container(
          width: double.infinity,
          height: 150,
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
              ],
            ),
          ),
        ),
    );
  }
}