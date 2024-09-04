import '../helpers/enums/priority.enum.dart';
import '../helpers/enums/recursive_days.enum.dart';

class Task {

  static final mockTasksList = MockTasks.tasks;

  /// Mandatory fields
  final String title;
  final TaskPriority taskPriority;
  final DateTime taskDate;

  /// Not mandatory - default value = day of creation

  /// Optional fields
  final bool taskCompleted;
  final String? description;

  /// Recursive fields
  final bool recursive;
  final List<RecursiveDay> recursiveDays;

  Task({
    /// Mandatory fields
    required this.title,
    required this.taskPriority,
    required this.taskDate,

    /// Not mandatory - default value = day of creation

    /// Optional fields
    this.taskCompleted = false,
    this.description,

    /// Recursive fields
    this.recursive = false,
    this.recursiveDays = const [],
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'taskPriority': taskPriority,
        'taskDate': taskDate,
        'taskCompleted': taskCompleted,
        'description': description,
        'recursive': recursive,
        'recursiveDays': recursiveDays,
      };

  factory Task.fromJson(Map<String, dynamic> map) => Task(
        title: map['title'] as String,
        taskPriority: map['taskPriority'] as TaskPriority,
        taskDate: map['taskDate'] as DateTime,
        taskCompleted: map['taskCompleted'] as bool,
        description: map['description'] as String,
        recursive: map['recursive'] as bool,
        recursiveDays: map['recursiveDays'] as List<RecursiveDay>,
      );
}

/// Mock Tasks data
class MockTasks {
  static final Task _task1 = Task(
    title: 'Task 1',
    description: 'Description of Task 1',
    taskPriority: TaskPriority.IMPORTANT,
    taskDate: DateTime(2024, 09, 03),
  );
  static final Task _task2 = Task(
    title: 'Task 2',
    description: 'Description of Task 2',
    taskPriority: TaskPriority.URGENT,
    taskDate: DateTime(2024, 09, 20),
  );
  static final Task _task3 = Task(
    title: 'Task 3',
    description: 'Description of Task 3',
    taskPriority: TaskPriority.NOT_IMPORTANT,
    taskDate: DateTime(2024, 09, 03),
  );

  static final List<Task> tasks = [_task1, _task2, _task3];
}
