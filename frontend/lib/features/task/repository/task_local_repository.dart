import 'package:momentum/lib.dart';

class TaskLocalRepository {
  TaskLocalRepository(this._db);

  final Database _db;

  static const String _tableName = 'tasks';

  Future<List<TaskModel>> getTasks() async {
    final result = await _db.query(_tableName, orderBy: 'created_at DESC');

    return result.map(TaskModel.fromLocalJson).toList();
  }

  Future<TaskModel?> getTask(String id) async {
    final result = await _db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return TaskModel.fromLocalJson(result.first);
  }

  Future<List<TaskModel>> getTasksByUser(String uid) async {
    final result = await _db.query(
      _tableName,
      where: 'uid = ?',
      whereArgs: [uid],
      orderBy: 'created_at DESC',
    );

    return result.map(TaskModel.fromLocalJson).toList();
  }

  Future<List<TaskModel>> getUnsyncedTasks() async {
    final result = await _db.query(
      _tableName,
      where: 'is_synced = ?',
      whereArgs: [0],
      orderBy: 'created_at ASC',
    );

    return result.map(TaskModel.fromLocalJson).toList();
  }

  Future<void> saveTask(TaskModel task) async {
    await _db.insert(
      _tableName,
      task.toLocalJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> saveTasks(List<TaskModel> tasks) async {
    if (tasks.isEmpty) {
      return;
    }

    await _db.transaction((txn) async {
      final batch = txn.batch();

      for (final task in tasks) {
        batch.insert(
          _tableName,
          task.toLocalJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
    });
  }

  Future<int> updateTask(TaskModel task) async {
    return _db.update(
      _tableName,
      task.toLocalJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> markAsSynced(String id) async {
    return _db.update(
      _tableName,
      {'is_synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTask(String id) async {
    return _db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTasksByUser(String uid) async {
    return _db.delete(_tableName, where: 'uid = ?', whereArgs: [uid]);
  }

  Future<int> clearTasks() async {
    return _db.delete(_tableName);
  }

  Future<bool> taskExists(String id) async {
    final result = await _db.query(
      _tableName,
      columns: ['id'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  Future<int> getTaskCount() async {
    final result = await _db.rawQuery(
      'SELECT COUNT(*) AS count FROM $_tableName',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }
}
