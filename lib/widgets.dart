import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  const TaskCardWidget({Key? key, this.title, this.desc}) : super(key: key);

  final String? title; // 이렇게 물음표 넣어 줘야 null일 때도 받아옴
  final String? desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "(Unnamed Task)",
            style: TextStyle(
                color: Color(0xFF211551),
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              desc ?? "No Description Added.",
              style: TextStyle(
                  fontSize: 16, color: Color(0xFF86929D), height: 1.5),
            ),
          )
        ],
      ),
    );
  }
}

class TodoWidget extends StatelessWidget {
  final String? text;
  final bool isDone;
  const TodoWidget({Key? key, this.text, this.isDone = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
                color: isDone ? Color(0xFF7349FE) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: isDone
                    ? null
                    : Border.all(color: Color(0xFF86829D), width: 1.5)),
            child: Image(image: AssetImage('assets/images/check_icon.png')),
          ),
          Flexible(
            child: Text(
              text ?? '(Unnamed Todo)',
              style: TextStyle(
                  color: isDone ? Color(0xFF211551) : Color(0xFF86829D),
                  fontSize: 16,
                  fontWeight: isDone ? FontWeight.bold : FontWeight.normal),
            ),
          )
        ],
      ),
    );
  }
}
