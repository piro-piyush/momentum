import 'package:momentum/lib.dart';

class TaskRemoteRepository {
  TaskRemoteRepository(this._service);

  final ApiService _service;

  /// Get all tasks for the authenticated user.
  Future<List<TaskModel>> getTasks({required String token}) async {
    final response = await _service.get(
      '/tasks',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return ApiService.handleResponse(response, (data) {
      final json = data as List<dynamic>;

      return json
          .map((item) => TaskModel.fromRemoteJson(item as Map<String, dynamic>))
          .toList();
    });
  }

  /// Get a single task by ID.
  Future<TaskModel?> getTask({
    required String token,
    required String id,
  }) async {
    try {
      final response = await _service.get(
        '/tasks/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return await ApiService.handleResponse(
        response,
        (data) => TaskModel.fromRemoteJson(data as Map<String, dynamic>),
      );
    } catch (_) {
      return null;
    }
  }

  /// Create a new task.
  Future<TaskModel> createTask({
    required String token,
    required TaskModel task,
  }) async {
    final response = await _service.post(
      '/tasks',
      data: task.toRemoteJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return ApiService.handleResponse(
      response,
      (data) => TaskModel.fromRemoteJson(data as Map<String, dynamic>),
    );
  }

  /// Update an existing task.
  Future<TaskModel> updateTask({
    required String token,
    required TaskModel task,
  }) async {
    final response = await _service.patch(
      '/tasks/${task.id}',
      data: task.toRemoteJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return ApiService.handleResponse(
      response,
      (data) => TaskModel.fromRemoteJson(data as Map<String, dynamic>),
    );
  }

  /// Delete a task.
  Future<void> deleteTask({required String token, required String id}) async {
    final response = await _service.delete(
      '/tasks/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    ApiService.handleResponse(response, (_) {});
  }

  /// Sync a local task with the server.
  Future<TaskModel> syncTask({
    required String token,
    required TaskModel task,
  }) async {
    if (task.id.isEmpty) {
      return createTask(token: token, task: task);
    }

    return updateTask(token: token, task: task);
  }

  void dispose() => _service.close();
}
