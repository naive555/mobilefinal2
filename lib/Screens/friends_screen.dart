import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'todo_screen.dart';

class FriendScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return FriendState();
  }
}

Future<List<Account>> fetchAccount() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/users');

  List<Account> userlist = [];

  if (response.statusCode == 200) {
    var body = json.decode(response.body);
    for(int i = 0; i< body.length;i++){
      var user = Account.fromJson(body[i]);
      userlist.add(user);
    }
    return userlist;
  } else {
    throw Exception('Failed to load Friend Lists');
  }
}

class Account {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;

  Account({this.id, this.name, this.email, this.phone, this.website});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
    );
  }
}

class FriendState extends State<FriendScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Friends"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("BACK"),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            FutureBuilder(
              future: fetchAccount(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return new Text('loading...');
                  default:
                    if (snapshot.hasError){
                      return new Text('Error: ${snapshot.error}');
                    } else {
                      List<Account> list = snapshot.data;
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
                                    "${(list[index].id).toString()} : ${list[index].name}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
                                  Text(
                                    list[index].email,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    list[index].phone,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    list[index].website,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TodoScreen(id: list[index].id, name: list[index].name),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
              }
            ),
          ],
        ),
      ),
    );
  }
}