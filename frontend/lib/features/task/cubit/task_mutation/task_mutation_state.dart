import 'package:momentum/lib.dart';

part 'task_mutation_cubit.dart';

class TaskMutationCubit extends Cubit<TaskMutationState> {
  TaskMutationCubit(this._repository) : super(const TaskMutationInitial());

  final TaskLocalRepository _repository;

  Future<void> createTask(TaskModel task) async {
    emit(const TaskMutationLoading());

    try {
      await _repository.saveTask(task);

      emit(TaskCreated(task));
    } catch (error) {
      emit(TaskMutationError(error.toString()));
    }
  }

  Future<void> updateTask(TaskModel task) async {
    emit(const TaskMutationLoading());

    try {
      final updatedTask = task.copyWith(
        updatedAt: DateTime.now(),
        isSynced: false,
      );

      await _repository.updateTask(updatedTask);

      emit(TaskUpdated(updatedTask));
    } catch (error) {
      emit(TaskMutationError(error.toString()));
    }
  }

  Future<void> deleteTask(String id) async {
    emit(const TaskMutationLoading());

    try {
      await _repository.deleteTask(id);

      emit(TaskDeleted(id));
    } catch (error) {
      emit(TaskMutationError(error.toString()));
    }
  }
}
