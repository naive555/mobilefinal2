import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<List<Todo>> getTodos(int userid) async {
  final response = await http.get('https://jsonplaceholder.typicode.com/todos?userId=${userid}');

  List<Todo> todoList = [];

  if (response.statusCode == 200) {
    var body = json.decode(response.body);
    for(int i = 0; i< body.length;i++){
      var todo = Todo.fromJson(body[i]);
      if(todo.userid == userid){
        todoList.add(todo);
      }
    }
    return todoList;
  } else {
    throw Exception('Failed to load Todo Lists');
  }
}

class Todo {
  final int userid;
  final int id;
  final String title;
  final String completed;

  Todo({this.userid, this.id, this.title, this.completed});

  factory Todo.fromJson(Map<String, dynamic> json) {
      return Todo(
      userid: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: (json['completed'] ? "complete" : ""),
    );
  }
}

class TodoScreen extends StatelessWidget {
  final int id;
  final String name;
  TodoScreen({Key key, @required this.id, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todos"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("BACK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FutureBuilder(
              future: getTodos(this.id),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return new Text('loading...');
                default:
                  if (snapshot.hasError){
                    return new Text('Error: ${snapshot.error}');
                  } else {
                    List<Todo> list = snapshot.data;
                    return new Expanded(
                      child: new ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return new Card(
                            child: InkWell(
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  (list[index].id).toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(10)),
                                Text(
                                  list[index].title,
                                ),
                                Padding(padding: EdgeInsets.all(10)),
                                Text(
                                  list[index].completed,
                                ),
                              ],
                            ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
              },
            ),  
          ],
        ),
      ),
    );
  }
}