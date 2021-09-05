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

  void toggleDone() {
    done = !done;
  }
}

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  late List<Todo> _todo;

  int get _todoCount => _todo.where((todo) => todo.done).length;

  @override
  void initState() {
    _todo = [Todo('primero'), Todo('segundo')];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _maybeDelete() {
      if (_todoCount == 0) {
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmación'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Estás seguro que quieres borrar los elementos seleccionados?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Borrar'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        },
      ).then((borrar) {
        if (borrar) {
          _removeChecked();
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _maybeDelete,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _todo.length,
        itemBuilder: (context, int index) {
          return InkWell(
            onTap: () {
              setState(() {
                _todo[index].toggleDone();
              });
            },
            child: ListTile(
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
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NewTodoPage()),
          ).then((what) {
            setState(() {
              _todo.add(Todo(what));
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _removeChecked() {
    List<Todo> pending = [];
    for (var todo in _todo) {
      if (!todo.done) pending.add(todo);
    }
    setState(() {
      _todo = pending;
    });
  }
}

class NewTodoPage extends StatefulWidget {
  @override
  _NewTodoPageState createState() => _NewTodoPageState();
}

class _NewTodoPageState extends State<NewTodoPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              onSubmitted: (String what) {
                setState(() {
                  Navigator.pop(context, what);
                });
              },
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _controller.text);
                },
                child: const Text('Añadir'))
          ],
        ),
      ),
    );
  }
}
