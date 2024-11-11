
import 'package:flutter/material.dart';
import 'database.dart';
import 'car_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(MyApp(database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  MyApp(this.database);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Management',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: CarListPage(database), // Pass AppDatabase here
    );
  }
}
