enum SyncOperation { create, update, delete }

class TaskSyncItem {
  const TaskSyncItem({
    required this.taskId,
    required this.operation,
    required this.createdAt,
    this.retryCount = 0,
  });

  final String taskId;
  final SyncOperation operation;
  final DateTime createdAt;
  final int retryCount;
}
