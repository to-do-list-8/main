import 'package:flutter/material.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  // 초기 알림 리스트
  final List<String> _alarms = [
    '2024/10/02 고급 모바일 프로그래밍 UI',
    '2024/10/02 설계패턴 퀴즈',
    '2024/10/02 네트워크 프로그래밍 과제',
    '2024/10/08 고급 모바일 프로그래밍',
  ];

  // 알림 삭제 함수
  void _removeAlarm(int index) {
    setState(() {
      _alarms.removeAt(index); // 해당 인덱스 항목 제거
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('알림 🔔')),
      body: ListView.builder(
        itemCount: _alarms.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_alarms[index]),
            trailing: GestureDetector(
              onTap: () => _removeAlarm(index), // 항목 제거
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Text(
                    '-',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
