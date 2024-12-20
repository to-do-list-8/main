import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'search_screen.dart'; // 검색 화면 import

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<String, List<Map<String, dynamic>>> _tasks = {};

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> fetchTasks() async {
    try {
      User? user = _auth.currentUser;

      if (user == null) {
        throw Exception('사용자가 로그인되어 있지 않습니다.');
      }

      DocumentSnapshot documentSnapshot =
      await _firestore.collection('schedule').doc(user.uid).get();

      if (documentSnapshot.exists) {
        List<dynamic> tasksData = documentSnapshot['data'] ?? [];
        Map<String, List<Map<String, dynamic>>> loadedTasks = {};

        for (var task in tasksData) {
          String category = task['category'];
          if (!loadedTasks.containsKey(category)) {
            loadedTasks[category] = [];
          }
          loadedTasks[category]!.add(task as Map<String, dynamic>);
        }

        setState(() {
          _tasks = loadedTasks;
        });
      } else {
        throw Exception('문서가 존재하지 않습니다.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('할 일 데이터를 가져오지 못했습니다: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈 화면'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
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
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                return _buildMarkers(date);
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "${_selectedDay.year}.${_selectedDay.month.toString().padLeft(2, '0')}.${_selectedDay.day.toString().padLeft(2, '0')} 할 일",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: _tasks.entries.map((entry) {
                String category = entry.key;
                List<Map<String, dynamic>> tasks = entry.value.where((task) {
                  DateTime? startDate = task['s_date']?.toDate();
                  DateTime? endDate = task['f_date']?.toDate();

                  return startDate != null &&
                      endDate != null &&
                      (_selectedDay.isAtSameMomentAs(startDate) ||
                          _selectedDay.isAtSameMomentAs(endDate) ||
                          (_selectedDay.isAfter(startDate) &&
                              _selectedDay.isBefore(endDate)));
                }).toList();

                if (tasks.isEmpty) {
                  return SizedBox.shrink();
                }

                return ExpansionTile(
                  title: Text(category),
                  children: tasks.map((task) {
                    return ListTile(
                      title: Text(
                        task['name'] ?? '',
                        style: TextStyle(
                          decoration: (task['check'] ?? false)
                              ? TextDecoration.lineThrough
                              : null,
                          color: (task['check'] ?? false)
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        '${task['s_date']?.toDate().toLocal().toString().substring(0, 16) ?? ''} ~ ${task['f_date']?.toDate().toLocal().toString().substring(0, 16) ?? ''}',
                      ),
                      trailing: Checkbox(
                        value: task['check'] ?? false,
                        onChanged: (value) async {
                          await updateTaskStatus(category, task, value);
                        },
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildMarkers(DateTime date) {
    List<String> categories = [];

    _tasks.forEach((category, tasks) {
      for (var task in tasks) {
        DateTime? startDate = task['s_date']?.toDate();
        DateTime? endDate = task['f_date']?.toDate();

        if (startDate != null &&
            endDate != null &&
            (date.isAtSameMomentAs(startDate) ||
                date.isAtSameMomentAs(endDate) ||
                (date.isAfter(startDate) && date.isBefore(endDate)))) {
          categories.add(category);
        }
      }
    });

    if (categories.isEmpty) return SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: categories.map((category) {
        Color markerColor;

        switch (category) {
          case "과제":
            markerColor = Colors.green;
            break;
          case "학교":
            markerColor = Colors.blueAccent;
            break;
          case "운동":
            markerColor = Colors.deepPurpleAccent;
            break;
          case "루틴":
            markerColor = Colors.amber;
            break;
          default:
            markerColor = Colors.grey;
        }

        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: markerColor,
            shape: BoxShape.circle,
          ),
        );
      }).toList(),
    );
  }

  Future<void> updateTaskStatus(
      String category, Map<String, dynamic> task, bool? isChecked) async {
    try {
      User? user = _auth.currentUser;

      if (user == null) {
        throw Exception('사용자가 로그인되어 있지 않습니다.');
      }

      task['check'] = isChecked;

      await _firestore.collection('schedule').doc(user.uid).update({
        "data": _tasks.values.expand((tasks) => tasks).toList(),
      });

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('상태 업데이트 실패: $e')),
      );
    }
  }
}