import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:momentum/lib.dart';

class TaskModel {
  final String id;
  final String uid;
  final String title;
  final Color color;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime dueAt;
  final bool isSynced;

  TaskModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.dueAt,
    required this.color,
    required this.isSynced,
  });

  TaskModel copyWith({
    String? id,
    String? uid,
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
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueAt: dueAt ?? this.dueAt,
      color: color ?? this.color,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'dueAt': dueAt.toIso8601String(),
      'hexColor': rgbToHex(color),
      'isSynced': isSynced,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      uid: map['uid'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      dueAt: DateTime.parse(map['dueAt']),
      color: hexToRgb(map['hexColor']),
      isSynced: map['isSynced'] ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaskModel(id: $id, uid: $uid, title: $title, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, dueAt: $dueAt, color: $color)';
  }

  @override
  bool operator ==(covariant TaskModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uid == uid &&
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
    return id.hashCode ^
        uid.hashCode ^
        title.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        dueAt.hashCode ^
        color.hashCode ^
        isSynced.hashCode;
  }

  String get formatDueTime {
    return DateFormat('h:mm a').format(dueAt);
  }

  static final List<TaskModel> list = <TaskModel>[
    TaskModel(
      id: 'task-001',
      uid: 'user-1',
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
      uid: 'user-1',
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
      uid: 'user-1',
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
      uid: 'user-1',
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
      uid: 'user-1',
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
      uid: 'user-1',
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
      uid: 'user-1',
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
      uid: 'user-1',
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
