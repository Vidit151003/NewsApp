import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:phone_auth_firebase_tutorial/pages/home_page.dart';
import 'package:phone_auth_firebase_tutorial/pages/login_page.dart';
import 'package:phone_auth_firebase_tutorial/pages/news.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Login();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
