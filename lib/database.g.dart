// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TodoDao? _todoDaoInstance;

  CarDao? _carDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TodoItem` (`id` INTEGER, `task` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `cars` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `brand` TEXT NOT NULL, `model` TEXT NOT NULL, `passengerCount` INTEGER NOT NULL, `capacity` REAL NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TodoDao get todoDao {
    return _todoDaoInstance ??= _$TodoDao(database, changeListener);
  }

  @override
  CarDao get carDao {
    return _carDaoInstance ??= _$CarDao(database, changeListener);
  }
}

class _$TodoDao extends TodoDao {
  _$TodoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _todoItemInsertionAdapter = InsertionAdapter(
            database,
            'TodoItem',
            (TodoItem item) =>
                <String, Object?>{'id': item.id, 'task': item.task}),
        _todoItemDeletionAdapter = DeletionAdapter(
            database,
            'TodoItem',
            ['id'],
            (TodoItem item) =>
                <String, Object?>{'id': item.id, 'task': item.task});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TodoItem> _todoItemInsertionAdapter;

  final DeletionAdapter<TodoItem> _todoItemDeletionAdapter;

  @override
  Future<List<TodoItem>> getAllTodoItems() async {
    return _queryAdapter.queryList('SELECT * FROM TodoItem',
        mapper: (Map<String, Object?> row) =>
            TodoItem(row['id'] as int?, row['task'] as String));
  }

  @override
  Future<void> insertTodoItem(TodoItem todoItem) async {
    await _todoItemInsertionAdapter.insert(todoItem, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTodoItem(TodoItem todoItem) async {
    await _todoItemDeletionAdapter.delete(todoItem);
  }
}

class _$CarDao extends CarDao {
  _$CarDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _carItemInsertionAdapter = InsertionAdapter(
            database,
            'cars',
            (CarItem item) => <String, Object?>{
                  'id': item.id,
                  'brand': item.brand,
                  'model': item.model,
                  'passengerCount': item.passengerCount,
                  'capacity': item.capacity
                }),
        _carItemUpdateAdapter = UpdateAdapter(
            database,
            'cars',
            ['id'],
            (CarItem item) => <String, Object?>{
                  'id': item.id,
                  'brand': item.brand,
                  'model': item.model,
                  'passengerCount': item.passengerCount,
                  'capacity': item.capacity
                }),
        _carItemDeletionAdapter = DeletionAdapter(
            database,
            'cars',
            ['id'],
            (CarItem item) => <String, Object?>{
                  'id': item.id,
                  'brand': item.brand,
                  'model': item.model,
                  'passengerCount': item.passengerCount,
                  'capacity': item.capacity
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CarItem> _carItemInsertionAdapter;

  final UpdateAdapter<CarItem> _carItemUpdateAdapter;

  final DeletionAdapter<CarItem> _carItemDeletionAdapter;

  @override
  Future<List<CarItem>> findAllCars() async {
    return _queryAdapter.queryList('SELECT * FROM cars',
        mapper: (Map<String, Object?> row) => CarItem(
            id: row['id'] as int?,
            brand: row['brand'] as String,
            model: row['model'] as String,
            passengerCount: row['passengerCount'] as int,
            capacity: row['capacity'] as double));
  }

  @override
  Future<void> insertCar(CarItem car) async {
    await _carItemInsertionAdapter.insert(car, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCar(CarItem car) async {
    await _carItemUpdateAdapter.update(car, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCar(CarItem car) async {
    await _carItemDeletionAdapter.delete(car);
  }
}
