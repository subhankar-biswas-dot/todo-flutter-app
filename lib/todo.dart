class Todo {
  Todo({required this.name, required this.checked});
  final String name;
  bool checked;

  Todo.fromMap(Map map)
      : this.name = map['name'],
        this.checked = map['checked'];

  Map toMap() {
    return {'name': this.name, 'checked': this.checked};
  }
}
