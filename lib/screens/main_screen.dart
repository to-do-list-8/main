import 'package:flutter/material.dart';
import 'data_screen.dart';
import 'home_screen.dart';
import 'add_screen.dart';
import 'extra_screen.dart'; // 부가 기능 화면 추가

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    const AddScreen(),
    ExtraScreen(), // 부가 기능 화면 추가
    DataScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, // 바탕색 검정
        selectedItemColor: Colors.white, // 선택된 아이템 아이콘 및 텍스트 흰색
        unselectedItemColor: Colors.white60, // 선택되지 않은 아이템 흰색 (약간 투명)
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.extension), // 부가 기능 아이콘
            label: 'Extra',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Data',
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
