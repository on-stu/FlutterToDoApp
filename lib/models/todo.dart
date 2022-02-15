class Todo {
  final int? id;
  final String title;
  final int isDone;
  final int? taskId;
  Todo({this.id, this.title = '', this.taskId, this.isDone = 0});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'isDone': isDone, 'taskId': taskId};
  }
}
