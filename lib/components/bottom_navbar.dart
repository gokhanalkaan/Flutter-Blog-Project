import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/user_model.dart';

import 'package:flutter_blog_app/pages/category_page.dart';
import 'package:flutter_blog_app/pages/home_page.dart';
import 'package:flutter_blog_app/pages/profile_page.dart';
import 'package:flutter_blog_app/pages/settings_page.dart';
import 'package:flutter_blog_app/services/user_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/chats_page.dart';

class BottomNavbar extends ConsumerStatefulWidget {
  int? selectedIndex;
  BottomNavbar({
    Key? key,
    this.selectedIndex,
  }) : super(key: key);

  @override
  ConsumerState<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends ConsumerState<BottomNavbar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            margin: EdgeInsets.only(right: 0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      widget.selectedIndex = 0;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    });
                  },
                  icon: widget.selectedIndex == 0
                      ? Icon(
                          Icons.home_filled,
                          color: Colors.blue.shade400,
                        )
                      : Icon(
                          Icons.home_filled,
                          color: Colors.blue.shade100,
                        ),
                ),
                const Text("Home", style: const TextStyle(fontSize: 10))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      widget.selectedIndex = 1;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CategoryPage()),
                      );
                    });
                  },
                  icon: widget.selectedIndex == 1
                      ? Icon(
                          Icons.list,
                          color: Colors.blue.shade400,
                        )
                      : Icon(
                          Icons.list,
                          color: Colors.blue.shade100,
                        ),
                ),
                const Text("Categories", style: const TextStyle(fontSize: 10))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      widget.selectedIndex = 4;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatsPage()),
                      );
                    });
                  },
                  icon: widget.selectedIndex == 4
                      ? Icon(
                          Icons.chat_bubble,
                          color: Colors.blue.shade400,
                        )
                      : Icon(
                          Icons.chat_bubble,
                          color: Colors.blue.shade100,
                        ),
                ),
                const Text("Chats", style: const TextStyle(fontSize: 10)),
                Container(
                  margin: EdgeInsets.only(right: 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          var value =
                              await ref.read(userProvider).getLoggedInUser();
                          setState(() {
                            widget.selectedIndex = 2;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                        user: value,
                                      )),
                            );
                          });
                        },
                        icon: widget.selectedIndex == 2
                            ? Icon(
                                Icons.person,
                                color: Colors.blue.shade400,
                              )
                            : Icon(
                                Icons.person,
                                color: Colors.blue.shade100,
                              ),
                      ),
                      const Text("Profile",
                          style: const TextStyle(fontSize: 10))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
