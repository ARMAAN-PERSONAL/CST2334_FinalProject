import 'package:floor/floor.dart';
import 'package:my_cst2335_labs/todo_item.dart';


@dao
abstract class TodoDao {
  @Query('SELECT * FROM TodoItem')
  Future<List<TodoItem>> getAllTodoItems();

  @insert
  Future<void> insertTodoItem(TodoItem todoItem);

  @delete
  Future<void> deleteTodoItem(TodoItem todoItem);
}
