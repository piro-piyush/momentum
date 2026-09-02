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
    emit(const TaskMutationLoading());

    try {
      await taskRemoteRepository.createTask(task: task, token: token);

      emit(TaskCreated(task));
    } catch (error) {
      if (error is ApiException) {
        emit(TaskMutationError(error.message, details: error.errors));
        return;
      }

      emit(TaskMutationError(error.toString()));
    }
  }

  Future<void> updateTask(TaskModel task) async {
    emit(const TaskMutationLoading());

    try {
      final token = SpService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }
      final updatedTask = task.copyWith(
        updatedAt: DateTime.now(),
        isSynced: false,
      );

      await taskRemoteRepository.updateTask(task: updatedTask, token: token);

      emit(TaskUpdated(updatedTask));
    } catch (error) {
      emit(TaskMutationError(error.toString()));
    }
  }

  Future<void> deleteTask(String taskId) async {
    emit(const TaskMutationLoading());

    try {
      final token = SpService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }
      await taskRemoteRepository.deleteTask(id: taskId, token: token);

      emit(TaskDeleted(taskId));
    } catch (error) {
      emit(TaskMutationError(error.toString()));
    }
  }
}
