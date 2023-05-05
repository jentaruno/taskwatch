import 'package:flutter/material.dart';
import 'tasks.dart';
import 'database.dart';

class TasksProvider with ChangeNotifier {
  List<Task> _taskList = [];

  List<Task> get taskList => _taskList;
  int get length => _taskList.length;

  TasksProvider() {
    loadTasks();
  }

  // Load tasks from database
  Future<void> loadTasks() async {
    _taskList = await TasksDatabase.instance.readAllTasks();
    notifyListeners();
  }

  // Add new task, unless task already exists in task list, add time to that task.
  Future<void> addTask(Task task) async {
    List<String> taskNames = _taskList.map((e) => e.getName()).toList();
    int i = taskNames.indexOf(task.getName());
    if (i != -1) {
      _taskList[i].addTime(task.getTime(0), DateTime.now());
      await TasksDatabase.instance.update(_taskList[i]);
    } else {
      _taskList.insert(0, task);
      await TasksDatabase.instance.create(task);
    }
    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    _taskList.remove(task);
    await TasksDatabase.instance.delete(task.title);
    notifyListeners();
  }

  Future<void> renameTask(Task task, String newName) async {
    int i = _taskList.indexOf(task);
    _taskList[i].title = newName;
    await TasksDatabase.instance.update(task);
    notifyListeners();
  }

  Future<void> deleteTaskTime(Task task, int index) async {
    int i = _taskList.indexOf(task);
    _taskList[i].deleteTime(index);
    await TasksDatabase.instance.update(task);
    notifyListeners();
  }

}