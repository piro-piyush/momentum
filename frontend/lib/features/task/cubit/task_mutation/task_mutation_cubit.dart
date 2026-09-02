import 'package:momentum/lib.dart';

part 'task_mutation_state.dart';

class TaskMutationCubit extends Cubit<TaskMutationState> {
  TaskMutationCubit({
    required this.taskLocalRepository,
    required this.taskRemoteRepository,
  }) : super(const TaskMutationInitial());

  final TaskLocalRepository taskLocalRepository;
  final TaskRemoteRepository taskRemoteRepository;

  String get token {
    final token = SpService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Authentication token not found');
    }
    return token;
  }

  Future<void> createTask(TaskModel task) async {
    try {
      final localTask = task.copyWith(
        isSynced: false,
        updatedAt: DateTime.now(),
      );

      // 1. Save locally first.
      await taskLocalRepository.saveTask(localTask);

      // 2. Local save succeeded.
      emit(TaskCreated(localTask));

      // 3. Try remote sync.
      await _syncCreate(localTask);
    } catch (error) {
      emit(
        TaskMutationError(
          error is ApiException ? error.message : error.toString(),
          details: error is ApiException ? error.errors : null,
        ),
      );
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      final updatedTask = task.copyWith(
        isSynced: false,
        updatedAt: DateTime.now(),
      );

      // 1. Update locally first.
      await taskLocalRepository.updateTask(updatedTask);

      // 2. Local update succeeded.
      emit(TaskUpdated(updatedTask));

      // 3. Try remote sync.
      await _syncUpdate(updatedTask);
    } catch (error) {
      emit(
        TaskMutationError(
          error is ApiException ? error.message : error.toString(),
          details: error is ApiException ? error.errors : null,
        ),
      );
    }
  }

  Future<void> deleteTask(TaskModel task) async {
    try {
      final deletedTask = task.copyWith(
        isDeleted: true,
        isSynced: false,
        updatedAt: DateTime.now(),
      );

      // 1. Mark as deleted locally first.
      await taskLocalRepository.markAsDeleted(deletedTask);

      // 2. Local update succeeded.
      emit(TaskDeleted(deletedTask.id));

      // 3. Try remote sync.
      await _syncDelete(deletedTask.id);
    } catch (error) {
      emit(
        TaskMutationError(
          error is ApiException ? error.message : error.toString(),
          details: error is ApiException ? error.errors : null,
        ),
      );
    }
  }

  Future<void> _syncCreate(TaskModel task) async {
    try {
      await taskRemoteRepository.createTask(task: task, token: token);

      await taskLocalRepository.markAsSynced(task.id);
    } catch (_) {
      // Remote failed.
      //
      // Keep the local task with:
      // isSynced = false
      //
      // It can be synced later.
    }
  }

  Future<void> _syncUpdate(TaskModel task) async {
    try {
      await taskRemoteRepository.updateTask(task: task, token: token);

      await taskLocalRepository.markAsSynced(task.id);
    } catch (_) {
      // Keep isSynced = false.
    }
  }

  Future<void> _syncDelete(String taskId) async {
    try {
      // 1. Delete from remote first.
      await taskRemoteRepository.deleteTask(id: taskId, token: token);

      // 2. Remote delete succeeded.
      // Now permanently delete from local storage.
      await taskLocalRepository.deleteTask(taskId);
    } catch (_) {
      // Remote delete failed.
      // Keep the local task as:
      // isDeleted = true
      // isSynced = false
      //
      // It can be synced again later.
    }
  }
}
