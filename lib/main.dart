import 'package:duda/Loading02.dart';
import 'package:duda/Login.dart';
import 'package:flutter/material.dart';
import 'Loading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DUDA',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: login(),
    );
  }
}
