import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/components/bottom_navbar.dart';
import 'package:flutter_blog_app/pages/landing_page.dart';
import 'package:flutter_blog_app/services/user_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class SettingsPage extends ConsumerStatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  String? downloadUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      //  String? downloadUrl;

      await imageRef.putFile(_image!);

      return await imageRef.getDownloadURL();
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteFile() async {
    String url = ref.read(currentUserProvider).profilePhoto!;
    try {
      await FirebaseStorage.instance.refFromURL(url).delete();
    } catch (e) {
      print("Error deleting db from cloud: $e");
    }
  }

  Future<bool> _handleAddPost(User? _user) async {
    //final downloadUrl ="https://assets.weforum.org/community/image/3v8PB95CCSn86e5fowthRAybW4ajSY18z2FfVPi2spk.jpeg";
    downloadUrl = await _downloadImage();

    await deleteFile();

    if (downloadUrl != null) {
      final result = ref.read(userProvider).updateProfilePhoto(
            _user!.uid,
            downloadUrl!,
          );

      return result;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    String _profilePhoto = ref.watch(currentUserProvider).profilePhoto!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Blogify"),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 90,
                  ),
                  Column(
                    children: [
                      Text(
                        "Change Profile Photo",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Stack(
                        children: [
                          // Image.file(_image!, fit: BoxFit.cover),
                          GestureDetector(
                            onTap: () {
                              _pickImage();
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(60.0),
                                child: _image != null
                                    ? Image.file(
                                        _image!,
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        _profilePhoto.length > 0
                                            ? _profilePhoto
                                            : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png",
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      )),
                          ),
                          Positioned(
                              bottom: 2,
                              right: 5,
                              child: IconButton(
                                onPressed: () {
                                  _pickImage();
                                },
                                iconSize: 20,
                                icon: Icon(Icons.add_a_photo),
                                color: Colors.lightBlueAccent,
                              ))
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  _image != null
                      ? ElevatedButton(
                          onPressed: () async {
                            bool val = await _handleAddPost(
                                ref.read(authProvider).asData?.value);

                            if (val == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Profile Photo updated")));
                              setState(() {
                                _profilePhoto = downloadUrl!;
                                _image = null;
                              });

                              if (val == false) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Profile Photo not updated.Try Again")));
                              }
                            }
                          },
                          child: Text("Save"))
                      : SizedBox(),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _auth.signOut();
                        //  ref.read(userProvider).logOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LandingPage()),
                        );
                      },
                      child: Text("LogOut")),
                ],
              ),
            )),
            BottomNavbar(
              selectedIndex: 3,
            )
          ],
        ),
      ),
    );
  }
}
