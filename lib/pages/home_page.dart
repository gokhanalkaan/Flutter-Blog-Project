import 'package:flutter/material.dart';
import 'package:flutter_blog_app/components/blog.dart';
import 'package:flutter_blog_app/components/bottom_navbar.dart';
import 'package:flutter_blog_app/models/blog_model.dart';
import 'package:flutter_blog_app/pages/add_post_page.dart';
import 'package:flutter_blog_app/pages/search_page.dart';
import 'package:flutter_blog_app/services/blog_services.dart';
import 'package:flutter_blog_app/services/user_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/myFloatingActionButtonLocation.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late Future<List<BlogModel>> timeline;

  @override
  void initState() {
    timeline = ref.read(blogProvider).getTimeline();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blogify"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<BlogModel>>(
                future: timeline,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    List<BlogModel> blogs = snapshot.data!;

                    return ListView.builder(
                        itemCount: blogs.length,
                        itemBuilder: ((BuildContext context, int index) {
                          BlogModel model = blogs[index];
                          debugPrint(model.blogId);
                          debugPrint(model.blogImage);
                          debugPrint(model.blogQuote);
                          debugPrint(model.blogTitle);
                          debugPrint(model.creatorId);

                          return Blog(
                            blog: model,
                            likeCount: model.likedUsers!.length,
                          );
                        }));
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Center();
                  }
                }),
              ),
            ),
            BottomNavbar(
              selectedIndex: 0,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddPostPage()),
            );
          },
          elevation: 6,
          child: Icon(Icons.add)),
      floatingActionButtonLocation: MyFloatingActionButtonLocation(),
    );
  }
}
