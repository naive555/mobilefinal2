import 'package:flutter/material.dart';
import 'package:mobilefinal2/sqlite/user_db.dart';
import '../currentuser/current_user.dart';
import 'package:toast/toast.dart';


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
  AccountUtil acc = AccountUtil();
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
        key: _formkey,
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
                onForm += 1;
              } else {
                onForm = 0;
                return 'Plese fill out this form';
              }
            },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Password",
                icon: Icon(Icons.lock)
              ),
              controller: password,
              obscureText: true,
              keyboardType: TextInputType.text,
              validator: (val) {
                if (val.isNotEmpty) {
                  onForm += 1;
                } else {
                  onForm = 0;
                  return 'Plese fill out this form';
                }
              },
            ),
            RaisedButton(
              child: Text('Login'.toUpperCase()),
              onPressed: () async {
                _formkey.currentState.validate();
                await acc.open("user.db");
                Future<List<Account>> allUser = acc.getAllUser();

                Future userValidate(String userid, String password) async {
                  var userList = await allUser;
                  for(var i=0; i < userList.length;i++){
                    if (userid == userList[i].userid && password == userList[i].password){
                      CurrentAccount.ID = userList[i].id;
                      CurrentAccount.USERID = userList[i].userid;
                      CurrentAccount.NAME = userList[i].name;
                      CurrentAccount.AGE = userList[i].age;
                      CurrentAccount.PASSWORD = userList[i].password;
                      CurrentAccount.QUOTE = userList[i].quote;
                      this.validator = true;
                      break;
                    }
                  }
                }

                if(this.onForm == 2){
                  this.onForm = 0;
                  await userValidate(username.text, password.text);
                  if(!this.validator){
                    Toast.show("Invalid user or password", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                  } else {
                    Navigator.pushReplacementNamed(context, '/home');
                    username.text = '';
                    password.text = '';
                  }
                }
              },
            ),
            FlatButton(
              child: Text('Register New Account', textAlign: TextAlign.right),
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              padding: EdgeInsets.only(left: 180.0),
            )
          ],
        ),
      ),
    );
  }
}