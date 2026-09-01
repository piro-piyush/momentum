part of "tasks_cubit.dart";

sealed class TasksState {
  const TasksState();
}

final class TasksInitial extends TasksState {
  const TasksInitial();
}

final class TasksLoading extends TasksState {
  const TasksLoading();
}

final class TasksLoaded extends TasksState {
  const TasksLoaded(this.tasks);

  final List<TaskModel> tasks;
}

final class TaskListError extends TasksState {
  const TaskListError(this.message);

  final String message;
}
