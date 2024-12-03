import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'search_screen.dart'; // SearchScreen import

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDay = DateTime.now(); // 초기값을 오늘 날짜로 설정
  DateTime _focusedDay = DateTime.now();

  // 할 일 데이터 (상태 포함)
  Map<String, List<Map<String, dynamic>>> _tasks = {
    "루틴": [],
    "과제": [
      {"title": "고급 모바일 프로그래밍 UI", "isChecked": true},
      {"title": "설계패턴 퀴즈", "isChecked": true},
      {"title": "네트워크 프로그래밍 과제", "isChecked": false},
    ],
    "학교": [
      {"title": "고급 모바일 프로그래밍", "isChecked": true},
      {"title": "설계패턴", "isChecked": false},
    ],
    "운동": [
      {"title": "달리기", "isChecked": false},
    ],
  };

  // 체크박스 상태 업데이트
  void _toggleCheckbox(String category, int index, bool? value) {
    setState(() {
      _tasks[category]![index]["isChecked"] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search), // 돋보기 아이콘
            onPressed: () {
              // SearchScreen으로 화면 전환
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 달력 위젯
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2000), // 시작 날짜
            lastDay: DateTime(2100), // 끝 날짜
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // 달력의 현재 페이지도 변경
              });
            },
          ),
          const SizedBox(height: 20),
          // 선택한 날짜 출력
          Text(
            "${_selectedDay.year}.${_selectedDay.month.toString().padLeft(2, '0')}.${_selectedDay.day.toString().padLeft(2, '0')} 할 일",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // 할일 리스트
          Expanded(
            child: ListView(
              children: _tasks.entries.map((entry) {
                String category = entry.key;
                List<Map<String, dynamic>> tasks = entry.value;
                return ExpansionTile(
                  title: Text(category),
                  children: tasks.asMap().entries.map((taskEntry) {
                    int index = taskEntry.key;
                    Map<String, dynamic> task = taskEntry.value;
                    return CheckboxListTile(
                      title: Text(task["title"]),
                      value: task["isChecked"],
                      onChanged: (value) {
                        _toggleCheckbox(category, index, value);
                      },
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}