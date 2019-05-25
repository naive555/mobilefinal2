import 'package:flutter/material.dart';
import '../currentuser/current_user.dart';
import 'package:mobilefinal2/sqlite/user_db.dart';

class ProfileScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<ProfileScreen> {
  final _formkey = GlobalKey<FormState>();
  AccountUtil acc = AccountUtil();
  final username = TextEditingController(text: CurrentAccount.USERID);
  final name = TextEditingController(text: CurrentAccount.NAME);
  final age = TextEditingController(text: CurrentAccount.AGE);
  final password = TextEditingController();
  final quote = TextEditingController(text: CurrentAccount.QUOTE);
  bool validator = false;

  int checkSpace(String text){
    int count = 0;
    for(int i = 0;i<text.length;i++){
      if(text[i] == ' '){
        count += 1;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: EdgeInsets.all(25),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'User Id',
                icon: Icon(Icons.person)
              ),
              controller: username,
              keyboardType: TextInputType.text,
              validator: (val) {
                if (val.isEmpty) {
                  return 'Plese fill out this form';
                } else if (val.length < 6 || val.length > 12) {
                  return 'User ID ต้องมีความยาวในช่วง 6-12 ตัวอักษร';
                } else if(this.validator)
                  return 'This User is Taken';
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Name',
                icon: Icon(Icons.account_circle),
              ),
              controller: name,
              keyboardType: TextInputType.text,
              validator: (val) {
                if (val.isEmpty) {
                  return 'Plese fill out this form';
                } else if (checkSpace(val) != 1) {
                  return 'Name ต้องมีทั้งชื่อและนามสกุล โดยคั่นด้วย space 1 space เท่านั้น';
                }
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Age',
                icon: Icon(Icons.calendar_view_day),
              ),
              controller: age,
              keyboardType: TextInputType.number,
              validator: (val) {
                if (val.isEmpty) {
                  return 'Plese fill out this form';
                } else if (int.parse(val) < 10 || int.parse(val) > 80) {
                  return "Age ต้องเป็นตัวเลขเท่านั้นและอยู่ในช่วง 10-80";
                }
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Password",
                icon: Icon(Icons.lock),
              ),
              controller: password,
              obscureText: true,
              keyboardType: TextInputType.text,
              validator: (val) {
                if (val.isEmpty) {
                  return 'Plese fill out this form';
                } else if (val.length <= 6) {
                  return "Please ต้องมีความยาวมากกว่า 6";
                }
              }
            ),
            RaisedButton(
              child: Text('Save'),
              onPressed: () async {
                await acc.open("user.db");
                Future<List<Account>> allAcc = acc.getAllUser();
                Account account = Account();
                account.id = CurrentAccount.ID;
                account.userid = username.text;
                account.name = name.text;
                account.age = age.text;
                account.password = password.text;
                account.quote = quote.text;

                Future userOnTaken(Account acc) async {
                  var userList = await allAcc;
                  for(var i=0; i < userList.length;i++){
                    if (acc.userid == userList[i].userid && CurrentAccount.ID != userList[i].id){
                      print('Taken');
                      this.validator = true;
                      break;
                    }
                  }
                }

                if (_formkey.currentState.validate()){
                  await userOnTaken(account);
                  if(!this.validator) {
                    await acc.updateUser(account);
                    CurrentAccount.USERID = account.userid;
                    CurrentAccount.NAME = account.name;
                    CurrentAccount.AGE = account.age;
                    CurrentAccount.PASSWORD = account.password;
                    CurrentAccount.QUOTE = account.quote;
                    Navigator.pop(context);
                  }
                }

                this.validator = false;
                Future showAllUser() async {
                  var userList = await allAcc;
                  for(var i=0; i < userList.length;i++){
                    print(userList[i]);
                    }
                  }

                showAllUser();
                print(CurrentAccount.whoCurrent());
              },
            ),
          ],
        ),
      ),
    );
  } 
}