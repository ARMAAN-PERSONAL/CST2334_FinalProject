import 'package:floor/floor.dart';
import 'package:final_proj/todo_item.dart';
import 'package:final_proj/car_item.dart'; // Add import for CarItem
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';
import 'todo_dao.dart';     // Import for TodoDao
import 'car_dao.dart';      // Import for CarDao

part 'database.g.dart'; // Ensure this remains for the generated code

@Database(version: 1, entities: [TodoItem, CarItem]) // Include both entities
abstract class AppDatabase extends FloorDatabase {
  TodoDao get todoDao; // Getter for TodoDao
  CarDao get carDao;   // Getter for CarDao
}
