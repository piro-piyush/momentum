import 'package:momentum/lib.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit(this._repository) : super(const TaskInitial());

  final TaskLocalRepository _repository;

  Future<void> loadTask(String id) async {
    emit(const TaskLoading());

    try {
      final task = await _repository.getTask(id);

      if (task == null) {
        emit(const TaskNotFound());
        return;
      }

      emit(TaskLoaded(task));
    } catch (error) {
      emit(TaskError(error.toString()));
    }
  }
}
