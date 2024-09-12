import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;
  String category;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
    required this.category,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    String? category,
    DateTime? dueDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  // Convert Task to Firestore format
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
      'category': category,
    };
  }

  // Create Task from Firestore document snapshot
  static Task fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      dueDate: DateTime.parse(data['dueDate']),
      isCompleted: data['isCompleted'] ?? false,
      category: data['category'] ?? 'Work',
    );
  }
}
