import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../helpers/di/di.dart';
import '../../../helpers/extensions/datetime_formatter.dart';
import '../../../models/task.model.dart';
import '../../../models/user_tasks.model.dart';
import '../auth/auth.service.dart';

class TasksService {
  final FirebaseFirestore _firestore;
  final AuthService _auth = getIt<AuthService>();

  TasksService(this._firestore) {
    if (bool.parse(dotenv.env['is_offline']!)) {
      _firestore.useFirestoreEmulator(
        dotenv.env['firebase_emulator_host']!,
        int.parse(dotenv.env['firebase_firestore_port']!),
      );
    }
  }

  Future<Task> addTask(Task task) async {
    final userUid = _auth.user.uid;
    final docRef = _firestore.collection('tasks').doc();

    task = task.copyWith(id: docRef.id, userId: userUid);
    await docRef.set(task.toJson());
    return task;
  }

  Future<bool> removeTask(Task task) async {
    if (task.id == null) throw ArgumentError('Task ID is null');

    await _firestore.collection('tasks').doc(task.id).delete();
    return true;
  }

  Future<Task> editTask(Task task) async {
    if (task.id == null) throw ArgumentError('Task ID is null');

    await _firestore.collection('tasks').doc(task.id).update(task.toJson());
    return task;
  }

  Future<UserTasks?> loadTasks(DateTime? date) async {
    final userUid = _auth.user.uid;

    Query query = _firestore.collection('tasks').where('userId', isEqualTo: userUid);

    if (date != null) {
      query = query.where('date', isEqualTo: date.formatDate());
    }

    final querySnapshot = await query.get();

    if (querySnapshot.docs.isEmpty) return null;

    final tasks = querySnapshot.docs.map((doc) {
      return Task.fromFirebaseMap({
        ...doc.data() as Map<String, dynamic>,
        'id': doc.id,
      });
    }).toList();

    return UserTasks(date: date ?? DateTime.now(), tasks: tasks);
  }

  Future<List<UserTasks>> loadTasksForTwoWeeks(
    DateTime fromDate,
    DateTime toDate,
  ) async {
    final userUid = _auth.user.uid;

    final querySnapshot = await _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userUid)
        .where('date', isGreaterThanOrEqualTo: fromDate.formatDate())
        .where('date', isLessThanOrEqualTo: toDate.formatDate())
        .orderBy('date')
        .get();

    final tasks = querySnapshot.docs.map((doc) {
      return Task.fromFirebaseMap({
        ...doc.data(),
        'id': doc.id,
      });
    }).toList();

    // Group tasks by day
    final Map<String, List<Task>> grouped = {};

    for (final task in tasks) {
      if (task.date != null) {
        grouped.putIfAbsent(task.date!, () => []).add(task);
      } else {
        log('$runtimeType - Task with null date - id ${task.id}!');
      }
    }

    return grouped.entries.map((entry) {
      return UserTasks(
        date: entry.key.convertStringToDateTime(),
        tasks: entry.value,
      );
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }
}
