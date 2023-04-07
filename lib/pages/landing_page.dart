import 'package:flutter/material.dart';
import 'package:flutter_blog_app/pages/home_page.dart';
import 'package:flutter_blog_app/pages/login_page.dart';
import 'package:flutter_blog_app/services/user_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).asData?.value;
    return (user != null ? HomePage() : LoginPage());
  }
}
