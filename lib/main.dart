import 'package:flutter/material.dart';

void main() {
  runApp(RootRestorationScope(
    restorationId: 'root',
    child: MaterialApp(
      home: TodoList(),
    ),
  ));
}

class Todo {
  Todo({required this.name, required this.checked});
  final String name;
  bool checked;
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class TodoItem extends StatelessWidget {
  TodoItem({
    required this.todo,
    required this.onTodoChanged,
  }) : super(key: ObjectKey(todo));

  final Todo todo;
  final onTodoChanged;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTodoChanged(todo);
      },
      leading: CircleAvatar(
        child: Text(todo.name[0]),
      ),
      title: Text(todo.name, style: _getTextStyle(todo.checked)),
    );
  }
}

class _TodoListState extends State<TodoList> {
  final List<Todo> _todoList = <Todo>[];
  final TextEditingController _textFieldController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My TO-DO List')),
      body: ListView(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          children: _todoList.map((Todo todo) {
            return TodoItem(todo: todo, onTodoChanged: _handleTodoChange);
          }).toList()),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(context),
          tooltip: 'Add Item',
          child: Icon(Icons.add)),
    );
  }

  void _addTodoItem(String name) {
    setState(() {
      _todoList.add(Todo(name: name, checked: false));
    });
    _textFieldController.clear();
  }

  Widget _buildTodoItem(String title) {
    return ListTile(
      title: Text(title),
    );
  }

  Future<Future> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a task to your list'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: 'Enter task here'),
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('ADD'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _addTodoItem(_textFieldController.text);
                },
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('CANCEL'))
            ],
          );
        });
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }
}
