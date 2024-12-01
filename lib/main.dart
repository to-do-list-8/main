import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_test/screens/login_page.dart';
import 'screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: const LoginPage(), // MainScreen을 앱의 첫 화면으로 설정
    );
  }
}