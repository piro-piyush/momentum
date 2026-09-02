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
      // 1. Load local tasks first.
      final localTasks = await taskLocalRepository.getTasks();

      emit(TasksLoaded(localTasks));
      if (await ConnectivityService.instance.isConnected) {
        // 2. Fetch remote tasks in background.
        await _fetchRemoteTasks();

        // 3. Sync any local pending changes.
        await _syncTasks();
      }
    } catch (error) {
      emit(TaskListError(error.toString()));
    }
  }

  Future<void> _fetchRemoteTasks() async {
    try {
      final remoteTasks = await taskRemoteRepository.getTasks(token: token);

      await taskLocalRepository.saveTasks(remoteTasks);

      // Read the final data from local DB.
      final tasks = await taskLocalRepository.getTasks();

      emit(TasksLoaded(tasks));
    } catch (_) {
      // Keep showing local tasks if remote is unavailable.
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
            continue;
          }

          if (task.isNew) {
            await taskRemoteRepository.createTask(task: task, token: token);
          } else {
            await taskRemoteRepository.updateTask(task: task, token: token);
          }

          await taskLocalRepository.markAsSynced(task.id);

          _markTaskAsSynced(task.id);
        } catch (_) {
          // Keep task unsynced.
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
