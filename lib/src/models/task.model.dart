import 'package:uuid/uuid.dart';

import '../helpers/enums/priority.enum.dart';
import '../helpers/enums/recursive_days.enum.dart';

class Task {
  late String? id;

  /// Mandatory fields
  final String title;
  final TaskPriority priority;
  final DateTime? date; // Not mandatory - default value = day of creation

  /// Optional fields
  final bool isCompleted;
  final String? description;

  /// Recursive fields
  final bool isRecursive;
  final Map<RecursiveDay, bool> recursiveDays;

  Task({
    this.id,

    /// Mandatory fields
    required this.title,
    required this.priority,
    required this.date,

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
        'title': title,
        'taskPriority': priority,
        'date': date,
        'taskCompleted': isCompleted,
        'description': description,
        'recursive': isRecursive,
        'recursiveDays': recursiveDays,
      };

  factory Task.fromJson(Map<String, dynamic> map) => Task(
        id: map['id'] as String,
        title: map['title'] as String,
        priority: map['taskPriority'] as TaskPriority,
        date: map['date'] as DateTime,
        isCompleted: map['taskCompleted'] as bool,
        description: map['description'] as String,
        isRecursive: map['recursive'] as bool,
        recursiveDays: map['recursiveDays'] as Map<RecursiveDay, bool>,
      );

  Task copyWith({
    String? id,
    String? title,
    TaskPriority? priority,
    DateTime? date,
    bool? isCompleted,
    String? description,
    bool? isRecursive,
    Map<RecursiveDay, bool>? recursiveDays,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        priority: priority ?? this.priority,
        date: date ?? this.date,
        isCompleted: isCompleted ?? this.isCompleted,
        description: description ?? this.description,
        isRecursive: isRecursive ?? this.isRecursive,
        recursiveDays: recursiveDays ?? this.recursiveDays,
      );
}
