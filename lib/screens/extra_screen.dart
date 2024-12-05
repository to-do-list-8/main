import 'package:flutter/material.dart';

class ExtraScreen extends StatelessWidget {
  final List<Map<String, String>> famousRoutines = [
    {'name': '스티브 잡스', 'routine': '아침 산책'},
    {'name': '빌 게이츠', 'routine': '독서'},
    {'name': '일론 머스크', 'routine': '매일 목표 설정'},
    {'name': '오프라 윈프리', 'routine': '명상'},
  ];

  void _addFamousRoutine(BuildContext context, String routine) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('루틴 추가'),
          content: Text('\'$routine\'을(를) 내 루틴에 추가하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('\'$routine\'이(가) 추가되었습니다!')),
                );
              },
              child: Text('추가'),
            ),
          ],
        );
      },
    );
  }

  void _writeDiary(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController diaryController = TextEditingController();
        return AlertDialog(
          title: Text('일기 쓰기'),
          content: TextField(
            controller: diaryController,
            maxLines: 5,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '오늘의 일기를 작성하세요...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('일기가 저장되었습니다!')),
                );
              },
              child: Text('저장'),
            ),
          ],
        );
      },
    );
  }

  Color _getProgressColor(int streak) {
    if (streak >= 100) {
      return Colors.amberAccent;
    } else if (streak >= 10) {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }


 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('부가 기능'),
      backgroundColor: Colors.black,
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 유명인 루틴 추가 섹션
            Text(
              '유명인 루틴 추가',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ...famousRoutines.map((routine) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text('${routine['name']}'),
                  subtitle: Text('${routine['routine']}'),
                  trailing: ElevatedButton(
                    onPressed: () =>
                        _addFamousRoutine(context, routine['routine']!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // 버튼 색상 검정
                    ),
                    child: Text(
                      '추가',
                      style: TextStyle(color: Colors.white), // 텍스트 색상 흰색
                    ),
                  ),
                ),
              );
            }).toList(),
            SizedBox(height: 16),

            // 일기 기능 섹션
            Text(
              '일기',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text('일기를 작성하세요'),
                trailing: ElevatedButton(
                  onPressed: () => _writeDiary(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // 버튼 색상 검정
                  ),
                  child: Text(
                    '쓰기',
                    style: TextStyle(color: Colors.white), // 텍스트 색상 흰색
                  ),
                ),
              ),
            ),
            Text(
              '저장된 일기',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            ...['2024/11/27: 눈이 왔다 ☃️', '2024/11/26: 날씨가 추워졌다.']
                .map((diary) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(diary),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    ),
    backgroundColor: Colors.white,
   );
  }
}