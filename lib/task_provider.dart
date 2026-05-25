import 'package:flutter/material.dart';
import 'task_model.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

  // Expose the tasks list securely
  List<Task> get tasks => _tasks;

  // Week 6 Task 2: Implement Provider to handle tasks (Add)
  void addTask(String title) {
    if (title.trim().isNotEmpty) {
      _tasks.add(Task(id: DateTime.now().toString(), title: title.trim()));
      notifyListeners(); // Tells the entire Flutter UI tree to refresh instantly!
    }
  }

  // Week 6 Task 2: Implement Provider to handle tasks (Update/Toggle Completion)
  void toggleTaskStatus(String id) {
    int index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      notifyListeners();
    }
  }

  // Week 6 Task 2: Implement Provider to handle tasks (Delete)
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}