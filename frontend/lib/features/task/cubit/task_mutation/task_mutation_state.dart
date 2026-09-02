part of 'task_mutation_cubit.dart';

sealed class TaskMutationState {
  const TaskMutationState();
}

final class TaskMutationInitial extends TaskMutationState {
  const TaskMutationInitial();
}

final class TaskMutationLoading extends TaskMutationState {
  const TaskMutationLoading();
}

final class TaskCreated extends TaskMutationState {
  const TaskCreated(this.task);

  final TaskModel task;
}

final class TaskUpdated extends TaskMutationState {
  const TaskUpdated(this.task);

  final TaskModel task;
}

final class TaskDeleted extends TaskMutationState {
  const TaskDeleted(this.taskId);

  final String taskId;
}

final class TaskMutationError extends TaskMutationState {
  const TaskMutationError(this.message);

  final String message;
}
