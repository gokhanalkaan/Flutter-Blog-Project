import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter_blog_app/pages/home_page.dart';
import 'package:flutter_blog_app/pages/register_page.dart';
import 'package:flutter_blog_app/services/user_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late FirebaseAuth _auth;
  String _username = "", _password = "";

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _auth = FirebaseAuth.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Blogify"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 5, left: 5, top: 10),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                            labelText: "email",
                            hintText: "email",
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value!.length < 2) {
                            return "Username have to be at least 2 character";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (deger) {
                          _username = deger!;
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                          labelText: "password",
                          hintText: "password",
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.length < 6) {
                          return "Password have to be at least 2 character";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (deger) {
                        _password = deger!;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 40,
                    width: 250,
                    child: ElevatedButton(
                        onPressed: () async {
                          bool _validate = _formKey.currentState!.validate();
                          print(_validate);

                          if (!_validate) {
                            _formKey.currentState!.save();
                            String result =
                                'username: $_username\n password:$_password ';
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(result)));

                            print(result);
                          } else {
                            var _userCredential =
                                (await _auth.signInWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text))
                                    .user;

                            if (_userCredential != null) {
                              ref.read(userProvider).getLoggedInUser();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => HomePage())));
                            }
                          }
                        },
                        child: const Text("Login")),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                      child: Text(
                        "Go to register page",
                        style: TextStyle(
                            color: Colors.blue.shade200, fontSize: 14),
                      ))
                ]),
          ),
        ));
  }
}
