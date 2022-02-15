import 'package:flutter/material.dart';
import 'package:todoapp/database_helper.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/screens/homepage.dart';
import 'package:todoapp/widgets.dart';

class TaskPage extends StatefulWidget {
  final Task? task;

  const TaskPage({Key? key, @required this.task}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  int? _taskId = 0;
  String? _taskTitle = "";
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    print('ID ${widget.task?.id}');
    if (widget.task != null) {
      _taskTitle = widget.task?.title;
      _taskId = widget.task?.id;
    }

    super.initState();
  }

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
                            if (widget.task == null) {
                              Task _newTask = Task(title: value);
                              await _dbHelper.insertTask(_newTask);
                              print('new task has been created');
                            } else {
                              print('Update the exisition task');
                            }
                          }
                        },
                        controller: TextEditingController()
                          ..text = _taskTitle.toString(),
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
                FutureBuilder(
                  initialData: [],
                  future: _dbHelper.getTodo(_taskId),
                  builder: (context, AsyncSnapshot<List> snapshot) {
                    return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  //sex
                                  print('hello');
                                },
                                child: TodoWidget(
                                  text: snapshot.data?[index].title,
                                  isDone: false,
                                ),
                              );
                            }));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        margin: EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: Color(0xFF86829D), width: 1.5)),
                        child: Image(
                            image: AssetImage('assets/images/check_icon.png')),
                      ),
                      Expanded(
                          child: TextField(
                        onSubmitted: ((value) async {
                          if (value != "") {
                            if (widget.task != null) {
                              DatabaseHelper _dbHelper = DatabaseHelper();
                              Todo _newTodo = Todo(
                                  title: value, isDone: 0, taskId: _taskId);
                              await _dbHelper.insertTodo(_newTodo);
                              print(_newTodo.taskId);
                            } else {
                              print('Task does not exist');
                            }
                          }
                        }),
                        decoration: InputDecoration(
                            hintText: "Enter Todo item...",
                            border: InputBorder.none),
                      ))
                    ],
                  ),
                )
              ],
            ),
            Positioned(
                bottom: 24,
                right: 24,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
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
