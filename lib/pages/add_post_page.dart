import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_blog_app/models/blog_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../services/blog_services.dart';

class AddPostPage extends ConsumerStatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends ConsumerState<AddPostPage> {
  TextEditingController _quoteController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  var items = [
    'Science',
    'Politics',
    'Sports',
    'Fashion',
    'Travelling',
    'Others',
  ];
  late String dropdownvalue = items[0];

  File? _image;

  Future _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      File img = File(image.path);

      setState(() {
        _image = img;
      });
    } catch (e) {}
  }

  Future<String> _downloadImage() async {
    try {
      final DateTime now = DateTime.now();
      final storageRef = FirebaseStorage.instance.ref();
      String _path = _image!.path + now.toString();

      final imageRef = storageRef.child(_path);
      String? downloadUrl;

      await imageRef.putFile(_image!);

      return await imageRef.getDownloadURL();
    } catch (e) {
      throw e;
    }
  }

  Future<bool> _handleAddPost(User? _user, WidgetRef ref) async {
    final downloadUrl = await _downloadImage();

    // "https://assets.weforum.org/community/image/3v8PB95CCSn86e5fowthRAybW4ajSY18z2FfVPi2spk.jpeg";

    if (downloadUrl != null) {
      final result = ref.read(blogProvider).addBlog(
          _user?.uid,
          _titleController.text,
          _quoteController.text,
          downloadUrl,
          dropdownvalue);

      _titleController.text = "";
      _quoteController.text = "";
      return result;
    }

    return false;

    /*  final result = ref.read(blogProvider).addBlog(
        _user?.uid,
        _titleController.text,
        _quoteController.text,
           downloadUrl);
    return result;*/
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).asData?.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Blogify"),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: (() => _pickImage()),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1),
                        borderRadius: BorderRadius.zero),
                    child: _image == null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Add a image",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                const Icon(
                                  Icons.photo,
                                  size: 15,
                                )
                              ],
                            ),
                          )
                        : Image.file(_image!, fit: BoxFit.fill),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    scrollController: _scrollController,
                    controller: _titleController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Write header",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    scrollController: _scrollController,
                    controller: _quoteController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Write a quote...",
                      border: OutlineInputBorder(),
                    ),
                    minLines: 3,
                    maxLines: 30,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButton(
                    value: dropdownvalue,
                    items: items
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    onChanged: ((String? value) {
                      setState(() {
                        dropdownvalue = value!;
                      });
                    })),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      var res = _handleAddPost(user, ref);
                    },
                    child: Text("Add Post"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
