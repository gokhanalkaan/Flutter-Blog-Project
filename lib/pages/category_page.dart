import 'package:flutter/material.dart';
import 'package:flutter_blog_app/components/bottom_navbar.dart';
import 'package:flutter_blog_app/components/category.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blogify"),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: const [
                  Category(
                    categoryname: 'All',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Category(
                    categoryname: 'Science',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Category(
                    categoryname: 'Politics',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Category(
                    categoryname: 'Sports',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Category(
                    categoryname: 'Travelling',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Category(
                    categoryname: 'Fashion',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Category(
                    categoryname: 'Others',
                  ),
                ],
              ),
            ),
            BottomNavbar(
              selectedIndex: 1,
            )
          ],
        ),
      ),
    );
  }
}
