import 'package:flutter/material.dart';
import 'package:todoapp/database_helper.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/widgets.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 6),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Image(
                              image: AssetImage(
                                  'assets/images/back_arrow_icon.png')),
                        ),
                      ),
                      Expanded(
                          child: TextField(
                        onSubmitted: (value) async {
                          print(value);
                          if (value != "") {
                            DatabaseHelper _dbHelper = DatabaseHelper();
                            Task _newTask = Task(title: value);
                            await _dbHelper.insertTask(_newTask);
                            print('new task has been created');
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Enter task title",
                            border: InputBorder.none),
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF211551)),
                      ))
                    ],
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter Descrtiption for the task...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 24)),
                ),
                TodoWidget(
                  text: 'Create your first Task',
                  isDone: false,
                ),
                TodoWidget(
                  text: 'Create your first Todo as well',
                  isDone: false,
                ),
                TodoWidget(
                  text: 'just another task',
                  isDone: true,
                ),
                TodoWidget(
                  isDone: true,
                ),
              ],
            ),
            Positioned(
                bottom: 24,
                right: 24,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TaskPage()),
                    );
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Color(0xFFFE3577),
                        borderRadius: BorderRadius.circular(20)),
                    child: Image(
                        image: AssetImage('assets/images/delete_icon.png')),
                  ),
                ))
          ],
        )),
      ),
    );
  }
}
