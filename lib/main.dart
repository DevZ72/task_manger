import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Intern Task',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(), // Setting the LoginScreen as the starting page
    );
  }
}