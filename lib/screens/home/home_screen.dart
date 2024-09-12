import 'package:coding_task/models/task_model.dart';
import 'package:coding_task/providers/quotes_provider.dart';
import 'package:coding_task/providers/tasks_provider.dart';
import 'package:coding_task/screens/home/widgets/drawer_widget.dart';
import 'package:coding_task/screens/home/widgets/tasks_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final Set<String> _selectedTasks = {};

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);
    final searchResults =
        ref.watch(taskProvider.notifier).searchTasks(_searchController.text);

    final quote = ref.watch(quoteProvider);
    // Group tasks by category
    final groupedTasks = <String, List<Task>>{};
    for (var task in searchResults) {
      if (groupedTasks[task.category] == null) {
        groupedTasks[task.category] = [];
      }
      groupedTasks[task.category]!.add(task);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                hintText: 'Search tasks...',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: quote.when(
              data: (quote) => Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, 4), // changes position of shadow
                    ),
                  ],
                ),
                child: Text(
                  '"$quote"',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              loading: () => Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              error: (error, stack) => Center(
                child: Text(
                  'Failed to load quote: $error',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: groupedTasks.entries.map((entry) {
                final category = entry.key;
                final tasksInCategory = entry.value;

                return _buildCategoryTile(category, tasksInCategory);
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryTile(String category, List<Task> tasksInCategory) {
    return ExpansionTile(
      title: Text(category),
      children: tasksInCategory.isEmpty
          ? [const ListTile(title: Text('No tasks available'))]
          : tasksInCategory.map((task) {
              return _buildTaskTile(task);
            }).toList(),
    );
  }

  Widget _buildTaskTile(Task task) {
    final isSelected = _selectedTasks.contains(task.id);

    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          color: task.isCompleted ? Colors.green : null,
        ),
      ),
      subtitle: Text(DateFormat('yMd').format(task.dueDate)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(task.isCompleted
                ? Icons.check_box
                : Icons.check_box_outline_blank),
            onPressed: () {
              ref
                  .read(taskProvider.notifier)
                  .toggleTaskCompletion(task.id, task.isCompleted);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              ref.read(taskProvider.notifier).deleteTask(task.id);
            },
          ),
        ],
      ),
      onTap: () {
        _showTaskDialog(context, task: task);
      },
    );
  }

  void _showTaskDialog(BuildContext context, {Task? task}) {
    showDialog(
      context: context,
      builder: (context) {
        return TaskDialog(task: task);
      },
    );
  }
}
