// Import the necessary packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_task/models/task_model.dart';
import 'package:coding_task/providers/auth_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  final user = ref.watch(authStateProvider).value;
  return TaskNotifier(user);
});

class TaskNotifier extends StateNotifier<List<Task>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user;

  TaskNotifier(this.user) : super([]) {
    if (user != null) {
      _fetchTasks();
    }
  }

  // Fetch tasks from Firestore
  Future<void> _fetchTasks() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('tasks')
        .get();

    final tasks = snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
    state = tasks;
  }

  // Search tasks by title
  List<Task> searchTasks(String query) {
    if (query.isEmpty) {
      return state;
    }
    return state
        .where((task) => task.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Add a new task
  Future<void> addTask(String title, String description, DateTime dueDate,
      String category) async {
    final task = Task(
      id: '',
      title: title,
      description: description,
      dueDate: dueDate,
      isCompleted: false,
      category: category,
    );

    final doc = await _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('tasks')
        .add(task.toMap());

    state = [...state, task.copyWith(id: doc.id)];
  }

  // Edit a task
  Future<void> editTask(String id, String title, String description,
      DateTime dueDate, String category) async {
    await _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('tasks')
        .doc(id)
        .update({
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'category': category,
    });

    state = state.map((task) {
      if (task.id == id) {
        return task.copyWith(
          title: title,
          description: description,
          dueDate: dueDate,
          category: category,
        );
      }
      return task;
    }).toList();
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    await _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('tasks')
        .doc(id)
        .delete();

    state = state.where((task) => task.id != id).toList();
  }

  // Mark task as completed
  Future<void> toggleTaskCompletion(String id, bool isCompleted) async {
    await _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('tasks')
        .doc(id)
        .update({'isCompleted': !isCompleted});

    state = state.map((task) {
      if (task.id == id) {
        return task.copyWith(isCompleted: !task.isCompleted);
      }
      return task;
    }).toList();
  }
}
