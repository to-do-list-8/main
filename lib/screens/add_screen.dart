import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _dataController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _nameController = TextEditingController();
  String? _selectedCategory;
  DateTime? _startDate;
  DateTime? _endDate;

  void _addDataToFirebase() async {
    try {
      User? user = _auth.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is currently logged in.')),
        );
        return;
      }

      // 데이터 배열 추가
      await _firestore.collection('schedule').doc(user.uid).update({
        "data": FieldValue.arrayUnion([
          {
            "category": _selectedCategory,
            "name": _nameController.text,
            "s_date": _startDate != null ? Timestamp.fromDate(_startDate!) : null,
            "f_date": _endDate != null ? Timestamp.fromDate(_endDate!) : null,
            "check": false,
            "count": 0,
          }
        ])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('할 일 목록이 추가되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('할 일 추가'),
        centerTitle: true,
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
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _startDate = pickedDate;
                    });
                  }
                },
                child: Text(
                  _startDate == null
                      ? '시작 날짜 선택'
                      : 'Start Date: ${_startDate!.toLocal()}'.split(' ')[0],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _endDate = pickedDate;
                    });
                  }
                },
                child: Text(
                  _endDate == null
                      ? '마지막 날짜 선택'
                      : 'End Date: ${_endDate!.toLocal()}'.split(' ')[0],
                ),
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
      backgroundColor: Colors.grey[200],
    );
  }
}
