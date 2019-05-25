import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();
  int onForm = 0;
  bool validator = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Form(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            Image.asset('assets/blueKey.png',
            width: 200,
            height: 200,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "User Id",
                icon: Icon(Icons.person)
              ),
            controller: username,
            keyboardType: TextInputType.text,
            validator: (val) {
              if (val.isNotEmpty) {
                onForm ++;
              }
            },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Password",
                icon: Icon(Icons.lock)
              ),
              controller: password,
              keyboardType: TextInputType.text,
              validator: (val) {
                if (val.isNotEmpty) {
                  onForm ++;
                }
              },
            ),
            RaisedButton(
              child: Text('Login'.toUpperCase()),
              onPressed: () {
                _formkey.currentState.validate();
              },
            ),
            FlatButton(
              child: Text('Register New Account', textAlign: TextAlign.right),
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
            )
          ],
        ),
      ),
    );
  }
}