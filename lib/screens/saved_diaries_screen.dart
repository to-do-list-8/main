import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SavedDiariesScreen extends StatefulWidget {
  @override
  _SavedDiariesScreenState createState() => _SavedDiariesScreenState();
}

class _SavedDiariesScreenState extends State<SavedDiariesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 저장된 일기 리스트
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _diaries = [];

  // Firestore에서 저장된 일기 불러오기
  Future<void> _fetchDiaries() async {
    try {
      final snapshot = await _firestore.collection('diary').get();
      setState(() {
        _diaries = snapshot.docs;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('일기 불러오기 실패: $e')),
      );
    }
  }

  // Firestore에서 일기 삭제
  Future<void> _deleteDiary(String documentId) async {
    try {
      await _firestore.collection('diary').doc(documentId).delete();
      setState(() {
        _diaries.removeWhere((doc) => doc.id == documentId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('일기가 삭제되었습니다!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('삭제 실패: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDiaries(); // 초기화 시 저장된 일기 불러오기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // 배경색 회색으로 설정
      appBar: AppBar(
        backgroundColor: Colors.grey[200], // 상단바 배경색 회색으로 설정
        elevation: 0, // 그림자 제거
        title: Text(
          '저장된 일기 📚',
          style: TextStyle(color: Colors.black), // 텍스트 색상 검정
        ),
        centerTitle: true, // 제목 중앙 정렬
        iconTheme: IconThemeData(color: Colors.black), // 아이콘 색상 검정
      ),
      body: _diaries.isEmpty
          ? Center(
        child: Text(
          '아직 저장된 일기가 없습니다!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: _diaries.length,
        itemBuilder: (context, index) {
          final diary = _diaries[index].data();
          final documentId = _diaries[index].id;
          return Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    diary['name'] ?? 'Untitled',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    diary['text'] ?? 'No content',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        diary['date'] != null
                            ? diary['date']
                            .toString()
                            .split('T')[0]
                            : '',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteDiary(documentId),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}