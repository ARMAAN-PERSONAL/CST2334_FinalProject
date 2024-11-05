import 'package:floor/floor.dart';
import 'package:my_cst2335_labs/todo_item.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';
import 'todo_dao.dart';     // Corrected import path

part 'database.g.dart'; // Ensure this remains for the generated code

@Database(version: 1, entities: [TodoItem])
abstract class AppDatabase extends FloorDatabase {
  TodoDao get todoDao;
}
