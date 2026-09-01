part of 'task_cubit.dart';

sealed class TaskState {
  const TaskState();
}

final class TaskInitial extends TaskState {
  const TaskInitial();
}

final class TaskLoading extends TaskState {
  const TaskLoading();
}

final class TaskLoaded extends TaskState {
  const TaskLoaded(this.task);

  final TaskModel task;
}

final class TaskNotFound extends TaskState {
  const TaskNotFound();
}

final class TaskError extends TaskState {
  const TaskError(this.message);

  final String message;
}
