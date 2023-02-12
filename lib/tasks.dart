import 'package:intl/intl.dart';

const String tableTasks = "tasks";

String getTodayDate() {
  var now = DateTime.now();
  var formatter = DateFormat('MM/dd/yyyy');
  return formatter.format(now);
}

class TaskFields {
  static const List<String> values = [id, title, times];
  static const String id = "_id";
  static const String title = "title";
  static const String times = "times";
  static const String dates = "dates";
}

class TaskList {
  List<Task> taskList = [];

  TaskList();

  List<Task> getTasks() {
    return taskList;
  }

  Task get(int i) {
    return taskList[i];
  }

  int length() {
    return taskList.length;
  }

  // Add new task, unless task already exists in task list, add time to that task.
  void addTask(Task task) {
    List<String> taskNames = taskList.map((e) => e.getName()).toList();
    int i = taskNames.indexOf(task.getName());
    if (i != -1) {
      taskList[i].addTime(task.getTime(0), getTodayDate());
    } else {
      taskList.add(task);
    }
  }
}

class Task {
  final int? id;
  final String title;
  List<String> times = [];
  List<String> dates = [];

  Task({this.id, required this.title, String? time}) {
    times.add(time!);
    dates.add(getTodayDate());
  }

  // Get name
  String getName() {
    return title;
  }

  // Get number of recorded times
  int getNumberOfTimes() {
    return times.length;
  }

  // Get time from given index
  String getTime(int index) {
    return times[index];
  }

  String getDate(int index) {
    return dates[index];
  }

  // Add a new time. Place new time in list, in order of speed
  void addTime(String time, String date) {
    int index = 0;
    for (; index < times.length; index++) {
      if (times[index].compareTo(time) >= 0) {
        break;
      }
    }
    times.insert(index, time);
    dates.insert(index, date);
  }

  // Database function, convert to JSON
  Map<String, Object?> toJSON() => {
        TaskFields.id: id,
        TaskFields.title: title,
        TaskFields.times: times.join(","),
        TaskFields.dates: dates.join(",")
      };

  // Database function, convert from JSON
  static Task fromJSON(Map<String, Object?> json) {
    Task loadedTask = Task(
        id: json[TaskFields.id] as int?,
        title: json[TaskFields.title] as String);

    String loadedTimesString = json[TaskFields.times] as String;
    List<String> loadedTimes = loadedTimesString.split(",");
    String loadedDatesString = json[TaskFields.dates] as String;
    List<String> loadedDates = loadedDatesString.split(",");
    for (int i = 0; i < loadedTimes.length; i++) {
      loadedTask.addTime(loadedTimes[i], loadedDates[i]);
    }

    return loadedTask;
  }

  // Database function, make a copy of task
  Task copy({
    int? id,
    String? title,
    List<String>? times,
    List<String>? dates,
  }) {
    Task taskCopy = Task(id: id ?? this.id, title: title ?? this.title);
    if (times != null && dates != null) {
      for (int i = 0; i < times.length; i++) {
        taskCopy.addTime(times[i], dates[i]);
      }
    }
    return taskCopy;
  }
}
