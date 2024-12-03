import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'saved_diaries_screen.dart'; // 새로 생성한 화면의 경로

class DiaryScreen extends StatefulWidget {
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore에 새 일기 추가
  Future<void> _addDiary() async {
    if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
      try {
        await _firestore.collection('diary').add({
          'name': _titleController.text,
          'text': _contentController.text,
          'date': DateTime.now().toIso8601String(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('일기가 저장되었습니다!')),
        );
        _titleController.clear();
        _contentController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('제목과 내용을 입력해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // 화면 전체 배경을 회색으로 설정
      appBar: AppBar(
        backgroundColor: Colors.grey[200], // 상단바 배경색 회색으로 설정
        elevation: 0, // 그림자 제거
        title: Row(
          children: [
            Text(
              '일기 ',
              style: TextStyle(color: Colors.black), // 텍스트 색상 검정으로 설정
            ),
            Icon(Icons.book, color: Colors.black), // 아이콘 색상 검정으로 설정
          ],
        ),
        centerTitle: true, // 제목 중앙 정렬
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '오늘 하루는 어땠나요?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: '제목',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _contentController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: '내용을 입력해주세요',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addDiary,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('저장',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white)),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Navigator를 사용해 SavedDiariesScreen으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SavedDiariesScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('저장된 일기 보기',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      //backgroundColor: Colors.grey[200],
    );
  }
}