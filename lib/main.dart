import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO Test App',
      theme: ThemeData(
        fontFamily: 'CustomFont',
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(), // MainScreen을 앱의 첫 화면으로 설정
    );
  }
}