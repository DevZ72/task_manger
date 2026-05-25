import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _taskController = TextEditingController();

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Add New Task", style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: _taskController,
          decoration: const InputDecoration(hintText: "Enter task title...", border: UnderlineInputBorder()),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              // Call Provider to add item globally
              Provider.of<TaskProvider>(context, listen: false).addTask(_taskController.text);
              _taskController.clear();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E)),
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Week 6 Task 2: Listen to changes from our TaskProvider state container
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: tasks.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_turned_in_outlined, size: 70, color: Colors.indigo.withOpacity(0.4)),
            const SizedBox(height: 15),
            Text("No tasks added yet!", style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          // Week 6 Task 3: Basic UI/UX animations using Dismissible container transitions
          return Dismissible(
            key: Key(task.id),
            direction: DismissDirection.endToStart,
            background: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              taskProvider.deleteTask(task.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('"${task.title}" deleted successfully.')),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
              margin: const EdgeInsets.symmetric(vertical: 6),
              color: Colors.white,
              child: ListTile(
                leading: Checkbox(
                  value: task.isCompleted,
                  activeColor: const Color(0xFF3949AB),
                  onChanged: (bool? value) {
                    taskProvider.toggleTaskStatus(task.id);
                  },
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    color: task.isCompleted ? Colors.grey : Colors.black87,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                  onPressed: () => taskProvider.deleteTask(task.id),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        backgroundColor: const Color(0xFF1A237E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}