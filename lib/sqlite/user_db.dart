import 'package:sqflite/sqflite.dart';

final String tableUser = "user";
final String columnId = "_id";
final String coulumnUser = "userid";
final String columnName = "name";
final String columnAge = "age";
final String columnPassword = "password";
final String columnQuote = "quote";

class Account {
  int id;
  String userid;
  String name;
  String age;
  String password;
  String quote;

  Account();

  Account.formMap(Map<String, dynamic> map) {
    this.id = map[columnId];
    this.userid = map[coulumnUser];
    this.name = map[columnName];
    this.age = map[columnAge];
    this.password = map[columnPassword];
    this.quote = map[columnQuote];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      coulumnUser: userid,
      columnName: name,
      columnAge: age,
      columnPassword: password,
      columnQuote: quote,
    };
    if (id != null) {
      map[columnId] = id; 
    }
    return map;
  }
}

class AccountUtil {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
          create table $tableUser (
            $columnId integer primary key autoincrement,
            $coulumnUser text not null unique,
            $columnName text not null,
            $columnAge text not null,
            $columnPassword text not null,
            $columnQuote text
          )
          ''');
    });
  }

  Future<Account> insertUser(Account acc) async {
    acc.id = await db.insert(tableUser, acc.toMap());
    return acc;
  }

  Future<Account> getUser(int id) async {
    List<Map<String, dynamic>> maps = await db.query(tableUser,
        columns: [columnId, coulumnUser, columnName, columnAge, columnPassword, columnQuote],
        where: '$columnId = ?',
        whereArgs: [id]);
        maps.length > 0 ? new Account.formMap(maps.first) : null;
  }

  Future<int> deleteUser(int id) async {
    return await db.delete(tableUser, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateUser(Account acc) async {
    return db.update(tableUser, acc.toMap(),
        where: '$columnId = ?', whereArgs: [acc.id]);
  }
  
  Future<List<Account>> getAllUser() async {
    await this.open("user.db");
    var res = await db.query(tableUser, columns: [columnId, coulumnUser, columnName, columnAge, columnPassword, columnQuote]);
    List<Account> userList = res.isNotEmpty ? res.map((c) => Account.formMap(c)).toList() : [];
    return userList;
  }

  Future close() async => db.close();

}