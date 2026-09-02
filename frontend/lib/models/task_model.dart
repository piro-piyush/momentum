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
    this.isSynced = false,
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
}
