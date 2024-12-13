import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:ornek_test/person.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class Databasehelper {
  static final Databasehelper instance = Databasehelper._instance();
  static Database? _database;

  Databasehelper._instance();

  Future<Database> get db async {
    await initDb();
    return _database!;
  }

  Future<void> initDb() async {
    String? databasesPath;
    if(kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      databasesPath = await getDatabasesPath();
    } else {
      databaseFactory = databaseFactoryFfi;
      databasesPath = Platform.isIOS ? (await getLibraryDirectory()).path : (await getApplicationDocumentsDirectory()).path;
    }

    String path = join(databasesPath, 'my.db');

    _database = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  /*static Future<void> init() async{
   try{
       if(_database!=null){
      return ;
    }
       if(kIsWeb) {
         databaseFactory = databaseFactoryFfiWeb;
       } else {
         sqfliteFfiInit();
         databaseFactory = databaseFactoryFfi;
       }
    String dbPath =await getDatabasesPath();
    print(dbPath);
    String myDbPath = join(dbPath,"my.db");
    print(myDbPath);
    _database=await openDatabase(myDbPath,singleInstance: true,version: 1,onCreate: onCreate);
   }
   catch(e){
      print("Hataaaaa:$e");
   }
  }*/

  static void _onCreate(Database db ,int version)async{
    String sqlQuery = "CREATE TABLE person (id INTEGER PRIMARY KEY AUTOINCREMENT,ad STRING,soyad STRING,boy INTEGER,kilo INTEGER,yas INTEGER,cinsiyet STRING)";
    await db.execute(sqlQuery);

  }
  static Future<int> insert(String table,Person model)async{
    return await _database!.insert(table,model.toJson());
  }
  static Future<int> update(String table,Person model)async{
    return await _database!.update(table,model.toJson(),where: "id=?",whereArgs: [model.id]);
  }
  static Future<int> delete(String table,Person model)async{
    return await _database!.delete(table,where: "id=?",whereArgs: [model.id]);
  }
  static Future<List<Map<String,dynamic>>> query(String table)async{
    return await _database!.query(table);
  }

  static close(){
    _database?.close();
  }
}