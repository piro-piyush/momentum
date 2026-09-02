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

  String get token {
    final token = SpService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Authentication token not found');
    }
    return token;
  }

  Future<void> loadTasks() async {
    emit(const TasksLoading());

    try {
      final tasks = await taskRemoteRepository.getTasks(token: token);

      emit(TasksLoaded(tasks));
    } catch (error) {
      emit(TaskListError(error.toString()));
    }
  }

  Future<void> refresh() async {
    await loadTasks();
  }

  void addTask(TaskModel task) {
    final currentState = state;

    if (currentState is! TasksLoaded) {
      return;
    }

    emit(TasksLoaded([task, ...currentState.tasks]));
  }

  void updateTask(TaskModel task) {
    final currentState = state;

    if (currentState is! TasksLoaded) {
      return;
    }

    final tasks = currentState.tasks.map((currentTask) {
      if (currentTask.id == task.id) {
        return task;
      }

      return currentTask;
    }).toList();

    emit(TasksLoaded(tasks));
  }

  void deleteTask(String id) {
    final currentState = state;

    if (currentState is! TasksLoaded) {
      return;
    }

    final tasks = currentState.tasks.where((task) => task.id != id).toList();

    emit(TasksLoaded(tasks));
  }
}
