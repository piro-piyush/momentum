import 'package:intl/intl.dart';
import 'package:momentum/lib.dart';

class TaskModel {
  final String id;
  final String title;
  final Color color;
  final String description;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime dueAt;
  final bool isSynced;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.updatedAt,
    required this.dueAt,
    required this.color,
    required this.isSynced,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueAt,
    Color? color,
    bool? isSynced,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueAt: dueAt ?? this.dueAt,
      color: color ?? this.color,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  /// JSON representation used by SQLite.
  Map<String, dynamic> toLocalJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'dueAt': dueAt.toIso8601String(),
      'hexColor': rgbToHex(color),
      'isSynced': isSynced ? 1 : 0,
    };
  }

  /// JSON representation sent to the API.
  Map<String, dynamic> toRemoteJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'color': rgbToHex(color),
      'dueAt': dueAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory TaskModel.fromLocalJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
      dueAt: DateTime.parse(json['dueAt'] as String).toLocal(),
      color: hexToRgb(json['hexColor'] as String),
      isSynced: json['isSynced'] == 1,
    );
  }

  factory TaskModel.fromRemoteJson(Map<String, dynamic> json) {
    try {
      return TaskModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String).toLocal()
            : null,
        dueAt: DateTime.parse(json['dueAt'] as String).toLocal(),
        color: hexToRgb(json['color'] as String),
        isSynced: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  String get formatDueTime => DateFormat('h:mm a').format(dueAt);

  @override
  String toString() {
    return 'TaskModel('
        'id: $id, '
        'title: $title, '
        'description: $description, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt, '
        'dueAt: $dueAt, '
        'color: $color, '
        'isSynced: $isSynced'
        ')';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TaskModel &&
            other.id == id &&
            other.title == title &&
            other.description == description &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt &&
            other.dueAt == dueAt &&
            other.color == color &&
            other.isSynced == isSynced;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,

      title,
      description,
      createdAt,
      updatedAt,
      dueAt,
      color,
      isSynced,
    );
  }

  static final List<TaskModel> list = <TaskModel>[
    TaskModel(
      id: 'task-001',

      title: 'Fix login validation',
      description: 'Handle invalid credentials, network errors, and loading states on the login screen.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      dueAt: DateTime.now().add(const Duration(hours: 2)),
      color: Colors.red,
      isSynced: true,
    ),
    TaskModel(
      id: 'task-002',

      title: 'Review pull request',
      description: 'Review the authentication changes and leave feedback before merging.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
      dueAt: DateTime.now().add(const Duration(hours: 5)),
      color: Colors.blue,
      isSynced: true,
    ),
    TaskModel(
      id: 'task-003',

      title: 'Study DBMS',
      description: 'Revise normalization, transactions, ACID properties, and concurrency control.',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      dueAt: DateTime.now().add(const Duration(hours: 8)),
      color: Colors.orange,
      isSynced: true,
    ),
    TaskModel(
      id: 'task-004',

      title: 'Prepare MCA notes',
      description: 'Complete notes for the next unit and organize important exam questions.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
      dueAt: DateTime.now().add(const Duration(days: 1)),
      color: Colors.purple,
      isSynced: false,
    ),
    TaskModel(
      id: 'task-005',

      title: 'Plan tomorrow',
      description: 'Review unfinished tasks and decide the top three priorities for tomorrow.',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      dueAt: DateTime.now().add(const Duration(days: 1)),
      color: Colors.green,
      isSynced: false,
    ),
    TaskModel(
      id: 'task-006',

      title: 'Update project documentation',
      description: 'Document the API endpoints, authentication flow, and local database setup.',
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      dueAt: DateTime.now().add(const Duration(days: 3)),
      color: Colors.indigo,
      isSynced: true,
    ),
    TaskModel(
      id: 'task-007',

      title: 'Clean up Flutter code',
      description: 'Remove unused imports, simplify duplicated logic, and fix analyzer warnings.',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      dueAt: DateTime.now().add(const Duration(days: 4)),
      color: Colors.teal,
      isSynced: true,
    ),
    TaskModel(
      id: 'task-008',

      title: 'Backup important files',
      description: 'Back up the current project, environment configuration, and important documents.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
      dueAt: DateTime.now().add(const Duration(days: 5)),
      color: Colors.brown,
      isSynced: false,
    ),
  ];
}
