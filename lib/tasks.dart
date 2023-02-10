const String tableTasks = "tasks";

class TaskFields {
  static const List<String> values = [id, title, times];
  static const String id = "_id";
  static const String title = "title";
  static const String times = "times";
}

class Task {
  final int? id;
  final String title;
  List<String> times = [];

  Task({this.id, required this.title, String? time}) {
    times.add(time!);
  }

  // Get name
  String getName() {
    return title;
  }

  // Get quickest time
  String getTopTime() {
    return times[0];
  }

  // Get all times
  List<String> getTimes() {
    return times;
  }

  // Add a new time. Place new time in list, in order of speed
  void addTime(String time) {
    int index = 0;
    for (; index < times.length; index++) {
      if (times[index].compareTo(time) >= 0) {
        break;
      }
    }
    times.insert(index, time);
  }

  // Database function, convert to JSON
  Map<String, Object?> toJSON() => {
        TaskFields.id: id,
        TaskFields.title: title,
        TaskFields.times: times.join(",")
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
