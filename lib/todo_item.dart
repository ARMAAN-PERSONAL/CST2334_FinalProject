import 'package:floor/floor.dart';

@entity
class TodoItem {
  @primaryKey
  final int? id; // Nullable ID for auto-generation
  final String task;

  TodoItem(this.id, this.task);
}
