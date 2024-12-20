import 'package:uuid/uuid.dart';

import '../helpers/enums/priority.enum.dart';
import '../helpers/enums/recursive_days.enum.dart';

class Task {
  static final mockTasksList1 = MockTasks.tasks1;
  static final mockTasksList2 = MockTasks.tasks2;
  static final mockTasksList3 = MockTasks.tasks3;

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

/// Mock Tasks data
class MockTasks {
  static final Task _task1 = Task(
    title: 'Exercise 15 minutes',
    description: 'Description of Task 1',
    priority: TaskPriority.IMPORTANT,
    isRecursive: true,
    recursiveDays: {RecursiveDay.MON: true, RecursiveDay.WED: true},
    date: DateTime(2024, 09, 03),
    isCompleted: true,
  );
  static final Task _task2 = Task(
    title: 'Pay bills',
    description: 'Description of Task 2',
    priority: TaskPriority.URGENT,
    date: DateTime(2024, 09, 20),
  );
  static final Task _task3 = Task(
    title: 'Clean desk',
    description: 'Clean desk',
    priority: TaskPriority.NOT_IMPORTANT,
    date: DateTime(2024, 09, 03),
    isCompleted: true,
  );
  static final Task _task4 = Task(
    title: 'Play guitar',
    description: 'description of Task 4',
    priority: TaskPriority.NOT_IMPORTANT,
    date: DateTime(2024, 09, 03),
  );
  static final Task _task5 = Task(
    title: 'Study for exams',
    description: 'description of Task 5',
    priority: TaskPriority.IMPORTANT,
    date: DateTime(2024, 09, 03),
  );

  static final List<Task> tasks1 = [_task1, _task2, _task3];
  static final List<Task> tasks2 = [_task2, _task4, _task5];
  static final List<Task> tasks3 = [_task4, _task3, _task5];
}
