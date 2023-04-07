import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/pages/blogs_page.dart';

class Category extends StatelessWidget {
  const Category({
    Key? key,
    required this.categoryname,
  }) : super(key: key);

  final String categoryname;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: GestureDetector(
        onTap: (() {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlogsPage(
                      category: categoryname,
                    )),
          );
        }),
        child: Container(
          child: Center(
            child: Text(
              categoryname,
              textAlign: TextAlign.center,
            ),
          ),
          height: 100,
          width: size.width,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade600, spreadRadius: 1, blurRadius: 15)
            ],
          ),
        ),
      ),
    );
  }
}
