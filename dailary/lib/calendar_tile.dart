import 'package:flutter/material.dart';

class CalendarTile extends StatelessWidget {
  final String date;
  final String startTime;
  final String endTime;
  final String text;
  final Function() onEditPressed;
  final Function() onDeletePressed;

  const CalendarTile({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.text,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: Offset(0, 2),
            blurRadius: 6.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$startTime - $endTime'),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: onEditPressed,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: onDeletePressed,
                  ),
                ],
              ),
            ],
          ),
          Container(
            height: 1,
            color: Color(0xFFF1CCCC),
          ),
          SizedBox(height: 10),
          Text(text),
        ],
      ),
    );
  }
}