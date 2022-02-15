class Task {
  final int? id;
  final String? title;
  final String? description;
  Task({this.id, this.title, this.description});

  Map<String, dynamic> toMap() {
    print('something');
    return {'id': id, 'title': title, 'description': description};
  }
}
