import 'package:flutter/material.dart';

import 'package:flutter_blog_app/models/user_model.dart';
import 'package:flutter_blog_app/pages/profile_page.dart';
import 'package:flutter_blog_app/pages/user_page.dart';
import 'package:flutter_blog_app/services/user_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  TextEditingController _controller = TextEditingController();
  UserModel? _user;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Blogify"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    width: size.width - 50,
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                          hintText: "Search...", border: InputBorder.none),
                    )),
                IconButton(
                    onPressed: () async {
                      debugPrint("onclick");
                      var res = await ref
                          .read(userProvider)
                          .getUser(_controller.text);
                      debugPrint(res.toString());

                      if (res != null) {
                        setState(() {
                          _user = res;
                        });
                      }
                    },
                    icon: Icon(Icons.search))
              ],
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            SizedBox(
              height: 3,
            ),
            _user != null
                ? GestureDetector(
                    onTap: (() {
                      _user!.userId != ref.read(userProvider).userId
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserPage(
                                        user: _user!,
                                      )),
                            )
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                        user: _user!,
                                      )),
                            );
                    }),
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  border: Border.all(
                                      color: Colors.blueGrey.shade300,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(40)),
                              margin: EdgeInsets.only(right: 3),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(_user != null
                                    ? _user!.profilePhoto!
                                    : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png"),
                              )),
                          SizedBox(
                            width: 3,
                          ),
                          Text(_user != null ? _user!.username! : "Username")
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
