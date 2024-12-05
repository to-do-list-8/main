import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedCategory;
  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _addDataToFirebase() async {
    try {
      User? user = _auth.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('사용자가 로그인되어 있지 않습니다.')),
        );
        return;
      }

      if (_nameController.text.isEmpty ||
          _selectedCategory == null ||
          _startDate == null ||
          _startTime == null ||
          _endDate == null ||
          _endTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('모든 필드를 입력해 주세요.')),
        );
        return;
      }

      // 시작 날짜와 시간, 끝 날짜와 시간 병합
      DateTime fullStartDate = DateTime(
        _startDate!.year,
        _startDate!.month,
        _startDate!.day,
        _startTime!.hour,
        _startTime!.minute,
      );
      DateTime fullEndDate = DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
        _endTime!.hour,
        _endTime!.minute,
      );

      // Firestore에 데이터 추가
      await _firestore.collection('schedule').doc(user.uid).update({
        "data": FieldValue.arrayUnion([
          {
            "category": _selectedCategory,
            "name": _nameController.text,
            "s_date": Timestamp.fromDate(fullStartDate),
            "f_date": Timestamp.fromDate(fullEndDate),
            "check": false,
          }
        ])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('할 일이 성공적으로 추가되었습니다.')),
      );

      // 입력 필드 초기화
      _nameController.clear();
      setState(() {
        _selectedCategory = null;
        _startDate = null;
        _startTime = null;
        _endDate = null;
        _endTime = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('데이터 추가 실패: $e')),
      );
    }
  }

  Future<DateTime?> _pickDate(BuildContext context, DateTime initialDate) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }

  Future<TimeOfDay?> _pickTime(BuildContext context, TimeOfDay initialTime) async {
    return await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('할 일 추가'),
      backgroundColor: Colors.black,
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '제목',
                hintText: '할 일을 입력해 주세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              items: ["과제", "학교", "운동", "루틴"]
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              decoration: InputDecoration(
                labelText: '카테고리 선택',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await _pickDate(context, DateTime.now());
                      if (pickedDate != null) {
                        setState(() {
                          _startDate = pickedDate;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // 버튼 색상
                    ),
                    child: Text(
                      _startDate == null
                          ? '시작 날짜 선택'
                          : '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.white), // 텍스트 색상
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      TimeOfDay? pickedTime = await _pickTime(context, TimeOfDay.now());
                      if (pickedTime != null) {
                        setState(() {
                          _startTime = pickedTime;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // 버튼 색상
                    ),
                    child: Text(
                      _startTime == null
                          ? '시작 시간 선택'
                          : '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.white), // 텍스트 색상
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await _pickDate(context, DateTime.now());
                      if (pickedDate != null) {
                        setState(() {
                          _endDate = pickedDate;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // 버튼 색상
                    ),
                    child: Text(
                      _endDate == null
                          ? '마지막 날짜 선택'
                          : '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.white), // 텍스트 색상
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      TimeOfDay? pickedTime = await _pickTime(context, TimeOfDay.now());
                      if (pickedTime != null) {
                        setState(() {
                          _endTime = pickedTime;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // 버튼 색상
                    ),
                    child: Text(
                      _endTime == null
                          ? '마지막 시간 선택'
                          : '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.white), // 텍스트 색상
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addDataToFirebase,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                '추가',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ),
    backgroundColor: Colors.white,
  );
}

}