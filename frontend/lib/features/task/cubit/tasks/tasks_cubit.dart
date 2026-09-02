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
      // Load from local DB first.
      final tasks = await taskLocalRepository.getTasks();

      emit(TasksLoaded(tasks));

      // Sync local changes to remote in background.
      _syncTasks();
    } catch (error) {
      emit(TaskListError(error.toString()));
    }
  }

  Future<void> _syncTasks() async {
    try {
      final unsyncedTasks = await taskLocalRepository.getUnsyncedTasks();

      for (final task in unsyncedTasks) {
        try {
          if (task.isDeleted) {
            await taskRemoteRepository.deleteTask(id: task.id, token: token);

            await taskLocalRepository.deleteTask(task.id);

            _removeTaskFromState(task.id);
          } else {
            await taskRemoteRepository.updateTask(task: task, token: token);

            await taskLocalRepository.markAsSynced(task.id);

            _markTaskAsSynced(task.id);
          }
        } catch (_) {
          // Keep unsynced.
        }
      }
    } catch (_) {
      // Ignore background sync errors.
    }
  }

  Future<void> refresh() async {
    await loadTasks();
  }

  void _removeTaskFromState(String taskId) {
    final currentState = state;

    if (currentState is! TasksLoaded) {
      return;
    }

    final tasks = currentState.tasks
        .where((task) => task.id != taskId)
        .toList();

    emit(TasksLoaded(tasks));
  }

  void _markTaskAsSynced(String taskId) {
    final currentState = state;

    if (currentState is! TasksLoaded) {
      return;
    }

    final tasks = currentState.tasks.map((task) {
      if (task.id == taskId) {
        return task.copyWith(isSynced: true);
      }

      return task;
    }).toList();

    emit(TasksLoaded(tasks));
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
