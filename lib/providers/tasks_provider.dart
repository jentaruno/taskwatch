import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'tasks.dart';

class TasksProvider with ChangeNotifier {
  List<Task> _taskList = [];

  List<Task> get taskList => _taskList;
  int get length => _taskList.length;

  // Add new task, unless task already exists in task list, add time to that task.
  void addTask(Task task) {
    List<String> taskNames = _taskList.map((e) => e.getName()).toList();
    int i = taskNames.indexOf(task.getName());
    if (i != -1) {
      _taskList[i].addTime(task.getTime(0), getTodayDate());
    } else {
      _taskList.add(task);
    }
    notifyListeners();
  }

}