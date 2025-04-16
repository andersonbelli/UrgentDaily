import 'package:uuid/uuid.dart';

import '../helpers/enums/priority.enum.dart';
import '../helpers/enums/recursive_days.enum.dart';

class Task {
  late String? id;

  /// Mandatory fields
  final String userId;
  final String title;
  final TaskPriority priority;
  final String? date; // Not mandatory - default value = day of creation
  final DateTime? fullDate;

  /// Optional fields
  final bool isCompleted;
  final String? description;

  /// Recursive fields
  final bool isRecursive;
  final Map<RecursiveDay, bool> recursiveDays;

  Task({
    this.id,

    /// Mandatory fields
    required this.userId,
    required this.title,
    required this.priority,
    required this.date,
    this.fullDate,

    /// Not mandatory - default value = day of creation

    /// Optional fields
    this.isCompleted = false,
    this.description,

    /// Recursive fields
    this.isRecursive = false,
    this.recursiveDays = const {},
  }) {
    id ??= '${DateTime.now().toString().trim().replaceAll(' ', '')}-${const Uuid().v4()}';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'priority': priority.index,
        'date': date,
        'fullDate': fullDate?.toIso8601String(),
        'isCompleted': isCompleted,
        'description': description,
        'isRecursive': isRecursive,
        'recursiveDays': recursiveDays.map((key, value) => MapEntry(key.index.toString(), value)),
      };

  factory Task.fromFirebaseMap(Map<String, dynamic> map) => Task(
        id: map['id'],
        userId: map['userId'],
        title: map['title'],
        priority: TaskPriority.values[map['priority']], // Convert index back to Enum
        date: map['date'],
        fullDate: map['fullDate'] != null ? DateTime.parse(map['fullDate']) : null,
        isCompleted: map['isCompleted'] ?? false,
        description: map['description'],
        isRecursive: map['isRecursive'] ?? false,
        recursiveDays: (map['recursiveDays'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(RecursiveDay.values[int.parse(key)], value as bool),
            ) ??
            {},
      );

  factory Task.fromJson(Map<String, dynamic> map) => Task(
        id: map['id'] as String,
        userId: map['userId'] as String,
        title: map['title'] as String,
        priority: map['taskPriority'] as TaskPriority,
        date: map['date'] as String,
        fullDate: map['fullDate'] as DateTime,
        isCompleted: map['taskCompleted'] as bool,
        description: map['description'] as String,
        isRecursive: map['recursive'] as bool,
        recursiveDays: map['recursiveDays'] as Map<RecursiveDay, bool>,
      );

  Task copyWith({
    String? id,
    String? userId,
    String? title,
    TaskPriority? priority,
    String? date,
    DateTime? fullDate,
    bool? isCompleted,
    String? description,
    bool? isRecursive,
    Map<RecursiveDay, bool>? recursiveDays,
  }) =>
      Task(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        priority: priority ?? this.priority,
        date: date ?? this.date,
        fullDate: fullDate ?? this.fullDate,
        isCompleted: isCompleted ?? this.isCompleted,
        description: description ?? this.description,
        isRecursive: isRecursive ?? this.isRecursive,
        recursiveDays: recursiveDays ?? this.recursiveDays,
      );
}
