import 'dart:convert';

import 'package:dailary/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditDiary extends StatefulWidget {
  final Map<String, String> diary;

  EditDiary({required this.diary});

  @override
  EditDiaryState createState() => EditDiaryState();
}

class EditDiaryState extends State<EditDiary> {
  final ApiService apiService = ApiService();
  late String diaryId;
  late DateTime selectedDate;
  late String selectedEmotion;
  late String selectedWeather;
  late String content;
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    // 일기에서 받은 날짜를 파싱하여 DateTime으로 변환합니다.
    diaryId = widget.diary['diaryId'] ?? '';
    selectedDate = DateTime.parse(widget.diary['date']!);
    selectedEmotion = widget.diary['emotion'] ?? '';
    selectedWeather = widget.diary['weather'] ?? '';
    content = widget.diary['content'] ?? '';

    textEditingController = TextEditingController(text: content);

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('일기 작성하기'),
          centerTitle: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // 뒤로가기 버튼 클릭 시 현재 화면을 종료하여 이전 화면으로 이동
            },
  ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '오늘의 날짜: ${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                style: const TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EmotionButton(
                    iconData: IconData(0xf584, fontFamily: 'Emotion'),
                    emotion: '행복해요',
                    onPressed: () {
                      setState(() {
                        selectedEmotion = '행복해요';
                      });
                    },
                    color: const Color.fromARGB(255, 255, 119, 164),
                  ),
                  EmotionButton(
                    iconData: IconData(0xf5b8, fontFamily: 'Emotion'),
                    emotion: '좋아요',
                    onPressed: () {
                      setState(() {
                        selectedEmotion = '좋아요';
                      });
                    },
                    color: Color.fromARGB(255, 255, 203, 119),
                  ),
                  EmotionButton(
                    iconData: IconData(0xf5a4, fontFamily: 'Emotion'),
                    emotion: '그럭저럭',
                    onPressed: () {
                      setState(() {
                        selectedEmotion = '그럭저럭';
                      });
                    },
                    color: Color.fromARGB(255, 107, 203, 129),
                  ),
                  EmotionButton(
                    iconData: IconData(0xf5b3, fontFamily: 'Emotion'),
                    emotion: '슬퍼요',
                    onPressed: () {
                      setState(() {
                        selectedEmotion = '슬퍼요';
                      });
                    },
                    color: Color.fromARGB(255, 119, 196, 255),
                  ),
                  EmotionButton(
                    iconData: IconData(0xf556, fontFamily: 'Emotion'),
                    emotion: '화나요',
                    onPressed: () {
                      setState(() {
                        selectedEmotion = '화나요';
                      });
                    },
                    color: Color.fromARGB(255, 255, 74, 74),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WeatherButton(
                    iconData: IconData(0xe800, fontFamily: 'Weather'),
                    weather: '맑음',
                    onPressed: () {
                      setState(() {
                        selectedWeather = '맑음';
                      });
                    },
                  ),
                  WeatherButton(
                    iconData: IconData(0xe801, fontFamily: 'Weather'),
                    weather: '흐림',
                    onPressed: () {
                      setState(() {
                        selectedWeather = '흐림';
                      });
                    },
                  ),
                  WeatherButton(
                    iconData: IconData(0xe803, fontFamily: 'Weather'),
                    weather: '비',
                    onPressed: () {
                      setState(() {
                        selectedWeather = '비';
                      });
                    },
                  ),
                  WeatherButton(
                    iconData: IconData(0xe802, fontFamily: 'Weather'),
                    weather: '눈',
                    onPressed: () {
                      setState(() {
                        selectedWeather = '눈';
                      });
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Text('날짜 선택'),
              ),
              SizedBox(height: 20),
              TextField(
                  controller: textEditingController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: '내용',
                    border: OutlineInputBorder(),
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  content = textEditingController.text;
                  apiService.putDiary(diaryId, selectedDate, selectedEmotion, selectedWeather, content);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApp()));
                },
                child: Text('일기 작성 완료'),
              ),
            ],
          ),
        ),
      )
      
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}

class EmotionButton extends StatelessWidget {
  final IconData iconData;
  final String emotion;
  final VoidCallback onPressed;
  final Color color;

  EmotionButton({
    required this.iconData,
    required this.emotion,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(iconData),
      onPressed: onPressed,      
      color: color,
    );
  }
}

class WeatherButton extends StatelessWidget {
  final IconData iconData;
  final String weather;
  final VoidCallback onPressed;

  WeatherButton({
    required this.iconData,
    required this.weather,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(iconData),
      onPressed: onPressed,
    );
  }
}


class ApiService {
  final String baseUrl = "http://localhost:8080";

  Future<void> putDiary(String diaryId, DateTime selectedDate, String selectedEmotion, String selectedWeather, String content) async {
    try {
      final res = await http.put(
        Uri.parse(baseUrl + '/diary/$diaryId'), 
        body:{
          'diaryId': diaryId, 
          'date': selectedDate.toString(),
          'emotion': selectedEmotion,
          'weather': selectedWeather,
          'content': content
        }
      );
    } catch (err) {
      print(err);
    }
  }
}