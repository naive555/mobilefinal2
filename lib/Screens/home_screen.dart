import 'package:flutter/material.dart';
import '../currentuser/current_user.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(25),
          children: <Widget>[
            ListTile(
              title: Text('Hello ${CurrentAccount.NAME}'),
              subtitle: Text('this is my quote "${CurrentAccount.QUOTE != null ? CurrentAccount.QUOTE == '' ? 'ยังไม่มีการระบุข้อมูล' : CurrentAccount.QUOTE : 'ยังไม่มีการระบุข้อมูล'}"'),
            ),
            RaisedButton(
              child: Text("PROFILE SETUP"),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            RaisedButton(
              child: Text("MY FRIENDS"),
              onPressed: () {
                Navigator.pushNamed(context, '/friend');
              },
            ),
            RaisedButton(
              child: Text("SIGN OUT"),
              onPressed: () {
                CurrentAccount.USERID = null;
                CurrentAccount.NAME = null;
                CurrentAccount.AGE = null;
                CurrentAccount.PASSWORD = null;
                CurrentAccount.QUOTE = null;
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}