import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String _selectedCategory = "과제";
  List<String> _categories = ["과제", "학교", "운동"];
  TimeOfDay _selectedTime = TimeOfDay(hour: 8, minute: 0); // 초기 시간
  bool _isAm = true; // AM/PM 상태

  // 카테고리 추가
  void _addCategory(String category) {
    setState(() {
      _categories.add(category);
    });
  }

  // 카테고리 삭제
  void _removeCategory(String category) {
    setState(() {
      _categories.remove(category);
      if (_categories.isNotEmpty) {
        _selectedCategory = _categories.first; // 첫 번째 카테고리로 선택
      } else {
        _selectedCategory = ""; // 선택된 카테고리 초기화
      }
    });
  }

  // 카테고리 수정
  void _editCategory(String oldCategory, String newCategory) {
    setState(() {
      int index = _categories.indexOf(oldCategory);
      if (index != -1) {
        _categories[index] = newCategory;
        if (_selectedCategory == oldCategory) {
          _selectedCategory = newCategory;
        }
      }
    });
  }

  // 다이얼로그로 새 카테고리 추가
  void _showAddCategoryDialog() {
    TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('새 카테고리 추가'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: '카테고리 이름 입력'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                _addCategory(_controller.text);
                Navigator.pop(context);
              },
              child: Text('추가'),
            ),
          ],
        );
      },
    );
  }

  // 다이얼로그로 카테고리 수정
  void _showEditCategoryDialog(String oldCategory) {
    TextEditingController _controller = TextEditingController(
        text: oldCategory);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('카테고리 수정'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: '새 카테고리 이름 입력'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                _editCategory(oldCategory, _controller.text);
                Navigator.pop(context);
              },
              child: Text('수정'),
            ),
          ],
        );
      },
    );
  }

  // 시간 선택
  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('할 일 추가'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddCategoryDialog, // 새 카테고리 추가
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To Do',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: '할 일',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories
                  .map((category) =>
                  DropdownMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(category),
                        IconButton(
                          icon: Icon(Icons.edit, size: 18),
                          onPressed: () =>
                              _showEditCategoryDialog(category), // 카테고리 수정
                        ),
                      ],
                    ),
                    value: category,
                  ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              decoration: InputDecoration(
                labelText: '카테고리',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ends',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _selectTime, // 시간 선택
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${_selectedTime.format(context)}', // 선택된 시간 표시
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ToggleButtons(
                      isSelected: [_isAm, !_isAm],
                      onPressed: (index) {
                        setState(() {
                          _isAm = index == 0;
                        });
                      },
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('AM', style: TextStyle(fontSize: 16)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('PM', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}