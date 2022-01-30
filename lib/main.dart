import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app/todo.dart';
import 'package:todo_app/todoItems.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MaterialApp(
      home: TodoList(),
    ),
  );
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Todo> _todoList = <Todo>[];
  final TextEditingController _textFieldController = TextEditingController();

  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    initSharedPreferences();
    super.initState();
  }

  initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

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
    saveData();
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
    saveData();
  }

  void saveData() {
    List<String> spList =
        _todoList.map((items) => json.encode(items.toMap())).toList();

    sharedPreferences.setStringList('list', spList);
  }

  void loadData() {
    List<String>? spList = sharedPreferences.getStringList('list');
    _todoList = spList!.map((item) => Todo.fromMap(json.decode(item))).toList();
    setState(() {});
  }
}
