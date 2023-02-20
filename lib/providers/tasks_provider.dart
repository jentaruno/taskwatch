import 'package:countup/screens/database.dart';
import 'package:flutter/material.dart';
import 'tasks.dart';

class TasksProvider with ChangeNotifier {
  List<Task> _taskList = [];
  int _num = 1;

  List<Task> get taskList => _taskList;
  int get length => _taskList.length;
  String get num => _num.toString();

  // Add new task, unless task already exists in task list, add time to that task.
  void addTask(Task task) {
    List<String> taskNames = _taskList.map((e) => e.getName()).toList();
    int i = taskNames.indexOf(task.getName());
    if (i != -1) {
      _taskList[i].addTime(task.getTime(0), getTodayDate());
    } else {
      _taskList.insert(0, task);
      TasksDatabase.instance.create(task);
    }
    notifyListeners();
  }

  void deleteTask(Task task) {
    _taskList.remove(task);
    TasksDatabase.instance.delete(task.title);
    notifyListeners();
  }

  void renameTask(Task task, String newName) {
    int i = _taskList.indexOf(task);
    _taskList[i].title = newName;
    TasksDatabase.instance.update(task);
    notifyListeners();
  }

  void deleteTaskTime(Task task, int index) {
    int i = _taskList.indexOf(task);
    _taskList[i].deleteTime(index);
    TasksDatabase.instance.update(task);
    notifyListeners();
  }

  Future<List<Task>> loadTasks() async {
    return await TasksDatabase.instance.readAllTasks();
  }

}