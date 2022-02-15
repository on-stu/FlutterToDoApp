import 'package:flutter/material.dart';
import 'package:todoapp/database_helper.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/models/todo.dart';
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
  String? _taskDesc = "";
  String? _todoTitle = "";

  final DatabaseHelper _dbHelper = DatabaseHelper();
  FocusNode? _titleFocus;
  FocusNode? _descriptionFocus;
  FocusNode? _todoFocus;
  bool _contentVisible = false;

  @override
  void initState() {
    // print('ID ${widget.task?.id}');
    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();
    if (widget.task != null) {
      _taskTitle = widget.task?.title;
      if (widget.task?.description != null) {
        _taskDesc = widget.task?.description;
      }
      _taskId = widget.task?.id;
      _contentVisible = true;
    } else {
      _titleFocus?.requestFocus();
    }

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus?.dispose();
    _descriptionFocus?.dispose();
    _todoFocus?.dispose();

    super.dispose();
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
                        focusNode: _titleFocus,
                        onSubmitted: (value) async {
                          if (value != "") {
                            if (widget.task == null) {
                              Task _newTask = Task(title: value);
                              int newTaskId =
                                  await _dbHelper.insertTask(_newTask);
                              print('new task has been created id: $newTaskId');
                              setState(() {
                                _contentVisible = true;
                                _taskId = newTaskId;
                                _taskTitle = value;
                              });
                            } else {
                              _dbHelper.updateTaskTitle(_taskId, value);
                              setState(() {
                                _taskTitle = value;
                              });
                              print('Update the exisition task');
                            }
                            _descriptionFocus?.requestFocus();
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
                Visibility(
                  visible: _contentVisible,
                  child: TextField(
                    focusNode: _descriptionFocus,
                    onSubmitted: (value) {
                      if (value != "") {
                        if (_taskId != 0) {
                          _dbHelper.updateTaskDescription(_taskId, value);
                          setState(() {
                            _taskDesc = value;
                          });
                        }
                      }
                      _todoFocus?.requestFocus();
                    },
                    controller: TextEditingController()
                      ..text = _taskDesc.toString(),
                    decoration: InputDecoration(
                        hintText: 'Enter Descrtiption for the task...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 24)),
                  ),
                ),
                Visibility(
                  visible: _contentVisible,
                  child: FutureBuilder(
                    initialData: [],
                    future: _dbHelper.getTodo(_taskId),
                    builder: (context, AsyncSnapshot<List> snapshot) {
                      return Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    if (snapshot.data?[index].isDone == 0) {
                                      await _dbHelper.updateTodoIsDone(
                                          snapshot.data?[index].id, 1);
                                    } else {
                                      await _dbHelper.updateTodoIsDone(
                                          snapshot.data?[index].id, 0);
                                    }
                                    setState(() {});
                                  },
                                  child: TodoWidget(
                                    text: snapshot.data?[index].title,
                                    isDone: snapshot.data?[index].isDone == 0
                                        ? false
                                        : true,
                                  ),
                                );
                              }));
                    },
                  ),
                ),
                Visibility(
                  visible: _contentVisible,
                  child: Padding(
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
                              image:
                                  AssetImage('assets/images/check_icon.png')),
                        ),
                        Expanded(
                            child: TextField(
                          focusNode: _todoFocus,
                          onSubmitted: ((value) async {
                            if (value != "") {
                              if (_taskId != 0) {
                                DatabaseHelper _dbHelper = DatabaseHelper();
                                Todo _newTodo = Todo(
                                    title: value, isDone: 0, taskId: _taskId);
                                await _dbHelper.insertTodo(_newTodo);
                                print(_newTodo.taskId);
                                setState(() {
                                  _todoTitle = "";
                                }); // reload the Items
                                _todoFocus?.requestFocus();
                              } else {
                                print('Task does not exist');
                              }
                            }
                          }),
                          controller: TextEditingController()
                            ..text = _todoTitle.toString(),
                          decoration: InputDecoration(
                              hintText: "Enter Todo item...",
                              border: InputBorder.none),
                        ))
                      ],
                    ),
                  ),
                )
              ],
            ),
            Visibility(
              visible: _contentVisible,
              child: Positioned(
                  bottom: 24,
                  right: 24,
                  child: GestureDetector(
                    onTap: () async {
                      if (_taskId != null) {
                        await _dbHelper.deleteTask(_taskId);
                        Navigator.pop(context);
                      }
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
                  )),
            )
          ],
        )),
      ),
    );
  }
}
