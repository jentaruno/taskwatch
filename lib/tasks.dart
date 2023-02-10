const String tableTasks = "tasks";

class TaskFields {
  static const List<String> values = [id, title, times];
  static const String id = "_id";
  static const String title = "title";
  static const String times = "times";
}

class TaskList {
  List<Task> taskList = [];
  TaskList();

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
      taskList[i].addTime(task.getTime(0));
    } else {
      taskList.add(task);
    }
  }
}

class Task {
  final int? id;
  final String title;
  List<String> timesDates = [];

  Task({this.id, required this.title, String? time}) {
    timesDates.add(time!);
  }

  // Get name
  String getName() {
    return title;
  }

  // Get number of recorded times
  int getNumberOfTimes() {
    return timesDates.length;
  }

  // Get time from given index
  String getTime(int index) {
    return timesDates[index];
  }

  // Add a new time. Place new time in list, in order of speed
  void addTime(String time) {
    int index = 0;
    for (; index < timesDates.length; index++) {
      if (timesDates[index].compareTo(time) >= 0) {
        break;
      }
    }
    timesDates.insert(index, time);
  }

  // Database function, convert to JSON
  Map<String, Object?> toJSON() => {
        TaskFields.id: id,
        TaskFields.title: title,
        TaskFields.times: timesDates.join(",")
      };

  // Database function, convert from JSON
  static Task fromJSON(Map<String, Object?> json) {
    Task loadedTask = Task(
      id: json[TaskFields.id] as int?,
      title: json[TaskFields.title] as String
    );

    String loadedTimesString = json[TaskFields.times] as String;
    List<String> loadedTimes = loadedTimesString.split(",");
    for(String time in loadedTimes) {
      loadedTask.addTime(time);
    }

    return loadedTask;
  }

  // Database function, make a copy of task
  Task copy({
    int? id,
    String? title,
    List<String>? times,
  }) {
    Task taskCopy = Task(
        id: id ?? this.id,
        title: title ?? this.title
    );
    if (times != null) {
      for (String time in times) {
        taskCopy.addTime(time);
      }
    }
    return taskCopy;
  }

}
