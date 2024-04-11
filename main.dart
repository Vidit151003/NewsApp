
import 'package:flutter/material.dart';


import 'package:firebase_core/firebase_core.dart';
import 'package:phone_auth_firebase_tutorial/firebase_options.dart';
import 'package:phone_auth_firebase_tutorial/pages/login_page.dart';
import 'package:phone_auth_firebase_tutorial/pages/news.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily News',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(0, 65, 120, 1)),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}