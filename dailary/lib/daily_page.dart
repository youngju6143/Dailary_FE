import 'dart:convert';

import 'package:dailary/calendar_page.dart';
import 'package:dailary/edit_diary.dart';
import 'package:dailary/write_diary.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

class DailyWidget extends StatefulWidget {
  @override
  _DailyWidgetState createState() => _DailyWidgetState();
}

class _DailyWidgetState extends State<DailyWidget> {
  final ApiService apiService = ApiService();
  List<Map<String, String>> diaryList = [];
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchDiaryDates();
  }

  Future<void> fetchDiaryDates() async {
    final List<Map<String, String>> diaries = await apiService.fetchDiary();
    setState(() {
      diaryList = diaries;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: diaryList.isEmpty
        ? const Center(
            child: Text(
              "아직 작성한 일기가 없어요!",
              style: TextStyle(
                color: Color(0xFFAAAAAA),
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          )
        : ListView.builder(
            itemCount: diaryList.length,
            itemBuilder: (context, index) {
              final String diaryId = diaryList[index]['diaryId']!;
              final String date = diaryList[index]['date']!;
              final String emotion = diaryList[index]['emotion']!;
              final String weather = diaryList[index]['weather']!;
              final String content = diaryList[index]['content']!;

              return ListTile(
                title: Text('$date - $emotion - $weather - $content'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit), // 수정 버튼 아이콘
                      onPressed: () {
                        // 수정 버튼을 누를 때 해당 일기의 정보를 edit_diary 페이지로 전달
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditDiary(diary: diaryList[index]),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        apiService.deleteDiary(diaryId);
                        setState(() {
                          diaryList.removeAt(index); // 일기 삭제 함수 호출
                        });
                      },
                    ),
                  ],
                ),
              );
            },
            
          ),
      floatingActionButton: FloatingActionButton(
          child: Image.asset(
            "assets/imgs/edit.png",
            width: 30,
          ),
          shape: CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WriteDaily()),
            );
          },
        ),
    );
  }
}

class ApiService {
  final String baseUrl = "http://localhost:8080";

  Future<List<Map<String, String>>> fetchDiary() async {
    try {
      final res = await http.get(Uri.parse(baseUrl + '/diary'));
      final List<dynamic> jsonList = jsonDecode(res.body);
      final List<Map<String, String>> diaries = jsonList.map((entry) => {
        'diaryId': entry['diaryId'].toString(),
        'date': entry['date'].toString(),
        'emotion': entry['emotion'].toString(),
        'weather': entry['weather'].toString(),
        'content': entry['content'].toString(),
      }).toList();
      print(diaries);
      return diaries;
    } catch (err) {
      print('에러났다!! $err');
      return [];
    }
  }
  
  Future<Map<String, int>> fetchEmotionCounts() async {
    try {
      final res = await http.get(Uri.parse(baseUrl + '/sidebar'));
      final Map<String, dynamic> jsonData = jsonDecode(res.body);
      final Map<String, int> emotionCounts = Map<String, int>.from(jsonData);
      return emotionCounts;
    } catch (err) {
      print('에러났다!! $err');
      return {};
    }
  }

  Future<void> deleteDiary(String diaryId) async {
    try {
      final res = await http.delete(Uri.parse(baseUrl + '/diary/$diaryId'));
      print('삭제 성공!!');
      await fetchDiary(); 
    } catch (err) {
      print(err);
    }
  }
}