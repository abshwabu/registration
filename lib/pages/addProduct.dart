import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:registration/constants/apikey.dart';


class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final storage = FlutterSecureStorage();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }
  Future<void> _addPost({String title = '', String content = '', String tags = '', String image = ''}) async {
    var token = storage.read(key: 'authToken');
    http.Response response =await http.post(Uri.parse(Post_apikey),
    headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
    body: jsonEncode(<String, dynamic>{
      'title': title,
      'content': content,
      'tags': tags,
      'image': image,
    })
    );
    if(response.statusCode == 200) {
      try {
        print('success');
      } catch (e){
        print(e);
      }
    } else {
      print(response.statusCode);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Content',
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            _image != null
                ? Image.file(
                    _image!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  )
                : SizedBox(
                    height: 100,
                    width: 100,
                    child: Placeholder(),
                  ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _pickImage(ImageSource.gallery);
              },
              child: Text('Pick Image'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _tagsController,
              decoration: InputDecoration(
                labelText: 'Tags (comma separated)',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _addPost(title: _tagsController.text, content: _contentController.text, tags: _tagsController.text, image: _image.toString(),),
              child: Text('Add Post'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }
}
