import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/user_model.dart';

import 'package:flutter_blog_app/pages/login_page.dart';
import 'package:flutter_blog_app/services/user_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  String _username = "", _email = "", _password = "";
  late FirebaseAuth _auth;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  void initState() {
    _auth = FirebaseAuth.instance;

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
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
                    "Register",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                            labelText: "username",
                            hintText: "username",
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
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: "email",
                          hintText: "email",
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (!EmailValidator.validate(value!)) {
                          return "Email have to be valid";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (String? deger) {
                        _email = deger!;
                      },
                    ),
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
                          print(_email);
                          print(_validate);

                          if (!_validate) {
                            _formKey.currentState!.save();

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Something went wrong!")));
                          } else {
                            try {
                              bool error = await ref
                                  .read(userProvider)
                                  .checkUsername(_usernameController.text);

                              if (error == true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Username has already been taken")));
                              } else {
                                var _userCredential =
                                    (await _auth.createUserWithEmailAndPassword(
                                            email: _emailController.text,
                                            password: _passwordController.text))
                                        .user;

                                if (_userCredential != null) {
                                  final _userModel = UserModel(
                                    userId: _userCredential.uid,
                                    email: _userCredential.email,
                                    username: _usernameController.text,
                                  );

                                  /*  final Map<String, dynamic> _userMap =
                                    <String, dynamic>{};
                                _userMap["userId"] =
                                    _userCredential.uid.toString();
                                _userMap["email"] =
                                    _userCredential.email.toString();

                                _userMap["username"] = _username;*/

                                  /* await _firestore
                                    .collection("users")
                                    .doc(_userCredential.uid)
                                    .set(_userModel.toFirestore());*/

                                  var val = await ref
                                      .read(userProvider)
                                      .addUser(_userModel);
                                  if (val) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
                                  } else {
                                    return;
                                  }
                                }
                              }
                            } on FirebaseAuthException catch (e) {
                              print(e);
                            }
                          }
                        },
                        child: const Text("Register")),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        "Go to login page",
                        style: TextStyle(
                            color: Colors.blue.shade200, fontSize: 14),
                      ))
                ]),
          ),
        ));
  }
}
