import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoItem {
  final String category;
  final bool check;

  TodoItem({
    required this.category,
    required this.check,
  });

  factory TodoItem.fromFirestore(Map<String, dynamic> data) {
    return TodoItem(
      category: data['category'],
      check: data['check'],
    );
  }
}

class DataScreen extends StatelessWidget {
  // UID정보 받게 되면 주석 제거
  // final String UID; // 문서 ID를 저장할 변수
  // DataScreen({required this.UID}); // 생성자에서 문서 ID를 받음

  final String documentId = 'GRhRx2Yt2NUuyEHajIWfkCIIXaj1'; // 문서 ID

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<TodoItem>> fetchTodos() async {
    // UID 받아올 수 있으면 .doc(UID) 이렇게 넣으면 됨
    DocumentReference docRef = _firestore.collection('schedule').doc(documentId);
    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      List<dynamic> todosData = docSnapshot['data']; // '할 일' 필드 검색
      print("Fetched Todos Data: $todosData"); // 콘솔에 출력

      return todosData.map((data) => TodoItem.fromFirestore(data)).toList();
    } else {
      print("Document does not exist");
      return [];
    }
  }

  Future<double> getOverallCompletionRate(List<TodoItem> todos) async {
    int totalTasks = todos.length;
    int completedTasks = todos.where((todo) => todo.check).length;

    if (totalTasks == 0) return 0.0; // 할 일이 없으면 0%
    return (completedTasks / totalTasks) * 100; // 완료율 계산
  }

  Future<Map<String, double>> getCategoryCompletionRates(List<TodoItem> todos) async {
    Map<String, int> totalTasks = {};
    Map<String, int> completedTasks = {};

    for (var todo in todos) {
      totalTasks[todo.category] = (totalTasks[todo.category] ?? 0) + 1;
      if (todo.check) {
        completedTasks[todo.category] = (completedTasks[todo.category] ?? 0) + 1;
      }
    }

    Map<String, double> completionRates = {};
    totalTasks.forEach((category, total) {
      int completed = completedTasks[category] ?? 0;
      completionRates[category] = (total == 0) ? 0.0 : (completed / total) * 100;
    });

    return completionRates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('데이터 페이지'),
      ),
      body: FutureBuilder<List<TodoItem>>(
        future: fetchTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('오류 발생: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('할 일이 없습니다.'));
          }

          List<TodoItem> todos = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '전체 완료율',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                FutureBuilder<double>(
                  future: getOverallCompletionRate(todos),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    double completionRate = snapshot.data ?? 0.0;
                    return Column(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: completionRate / 100,
                                strokeWidth: 8,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                              ),
                              Text(
                                '${completionRate.toStringAsFixed(1)}%',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  '카테고리별 완료율',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                FutureBuilder<Map<String, double>>(
                  future: getCategoryCompletionRates(todos),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    Map<String, double> categoryCompletionRates = snapshot.data ?? {};
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: categoryCompletionRates.entries.map((entry) {
                        return Column(
                          children: [
                            Text(
                              entry.key,
                              style: const TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: entry.value / 100,
                                    strokeWidth: 8,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(_getColor(entry.key)),
                                  ),
                                  Text(
                                    '${entry.value.toStringAsFixed(1)}%',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getColor(String category) {
    switch (category) {
      case 'homework':
        return Colors.green;
      case 'school':
        return Colors.blue;
      // case '취미':
      //   return Colors.orange;
      case 'exercise':
        return Colors.purple;
      case 'routain':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}
