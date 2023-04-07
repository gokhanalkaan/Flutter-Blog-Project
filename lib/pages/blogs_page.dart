import 'package:flutter/material.dart';
import 'package:flutter_blog_app/components/blog.dart';
import 'package:flutter_blog_app/models/blog_model.dart';
import 'package:flutter_blog_app/services/blog_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlogsPage extends ConsumerStatefulWidget {
  const BlogsPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  final String category;

  @override
  ConsumerState<BlogsPage> createState() => _BlogsPageState();
}

class _BlogsPageState extends ConsumerState<BlogsPage> {
  late Future<List<BlogModel>> _blogs;
  ScrollController _scrollController = ScrollController();
  var warning;

  @override
  void initState() {
    _blogs = ref.read(blogProvider).getCategoryBlogs(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.40;
      if (maxScroll - currentScroll <= delta) {
        // ref.read(blogProvider).getCategoryBlogs(widget.category).then((value) => null).catchError(onError);

      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: FutureBuilder<List<BlogModel>>(
        future: _blogs,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<BlogModel> _blogs = snapshot.data!;

            if (_blogs.length > 0) {
              return ListView.builder(
                //  controller: _scrollController,
                shrinkWrap: true,
                itemBuilder: ((context, index) {
                  BlogModel _blg = _blogs[index];
                  return Blog(blog: _blg);
                }),
                itemCount: _blogs.length,
              );
            } else {
              return Center(
                child: Text("No Blogs"),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
