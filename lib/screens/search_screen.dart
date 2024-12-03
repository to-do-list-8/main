import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = "";

  // 검색 데이터를 미리 정의
  final Map<String, List<String>> _data = {
    "과제": ["고급 모바일 프로그래밍 UI", "설계 패턴 과제"],
    "학교": ["고급 모바일 프로그래밍", "모바일 컴퓨팅 실습"],
  };

  // 검색 결과에서 하이라이트를 적용하는 함수
  Widget _buildHighlightedText(String text, String query) {
    if (query.isEmpty) return Text(text); // 검색어가 없으면 원래 텍스트 출력

    // 검색어와 텍스트 비교
    final RegExp regex = RegExp(query, caseSensitive: false);
    final List<TextSpan> spans = [];
    int start = 0;

    regex.allMatches(text).forEach((match) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: const TextStyle(
          color: Colors.red, // 하이라이트 색상
          fontWeight: FontWeight.bold,
        ),
      ));
      start = match.end;
    });

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return RichText(
      text: TextSpan(style: const TextStyle(color: Colors.black), children: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('검색 🔍')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '검색',
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value; // 검색어 업데이트
                });
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: _data.entries.map((entry) {
                String category = entry.key;
                List<String> items = entry.value
                    .where((item) => item.toLowerCase().contains(_searchQuery.toLowerCase())) // 검색 조건
                    .toList();

                if (items.isEmpty) return const SizedBox.shrink(); // 검색 결과 없을 시 빈 위젯 반환

                return ExpansionTile(
                  title: Text(category),
                  children: items.map((item) {
                    return ListTile(
                      title: _buildHighlightedText(item, _searchQuery), // 하이라이트 텍스트 적용
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