import 'package:flutter/material.dart';

void main() => runApp(TodoListApp());

class TodoListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoListPage(),
    );
  }
}

class Todo {
  String what;
  bool done;
  Todo(this.what) : this.done = false;
}

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  late List<Todo> _todo;

  @override
  void initState() {
    _todo = [Todo('primero'), Todo('segundo')];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
      ),
      body: ListView.builder(
        itemCount: _todo.length,
        itemBuilder: (context, int index) {
          return ListTile(
            leading: Checkbox(
              value: _todo[index].done,
              onChanged: (bool? value) {
                setState(() {
                  _todo[index].done = value!;
                });
              },
            ),
            title: Text(
              _todo[index].what,
              style: _todo[index].done
                  ? TextStyle(decoration: TextDecoration.lineThrough)
                  : TextStyle(decoration: TextDecoration.none),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
