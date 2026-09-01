import 'package:momentum/lib.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit({
    required this.taskLocalRepository,
    required this.taskRemoteRepository,
  }) : super(const TasksInitial()) {
    loadTasks();
  }

  final TaskLocalRepository taskLocalRepository;
  final TaskRemoteRepository taskRemoteRepository;

  Future<void> loadTasks() async {
    emit(const TasksLoading());

    try {
      final token = SpService.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      final tasks = await taskRemoteRepository.getTasks(token: token);

      // Cache the latest remote tasks locally.
      // await taskLocalRepository.saveTasks(tasks);

      emit(TasksLoaded(tasks));
    } catch (error) {
      // try {
      // Fallback to locally cached tasks when remote fails.
      // final tasks = await taskLocalRepository.getTasks();

      // emit(TasksLoaded(tasks));
      // } catch (localError) {
      emit(TaskListError(error.toString()));
      // }
    }
  }

  Future<void> refresh() async {
    await loadTasks();
  }
}
