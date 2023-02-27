import 'package:intl/intl.dart';

const String tableTasks = "tasks";

String getTodayDate() {
  var now = DateTime.now();
  var formatter = DateFormat('MM/dd/yyyy');
  return formatter.format(now);
}

class TaskFields {
  static const List<String> values = [id, title, times, dates];
  static const String id = "id";
  static const String title = "title";
  static const String times = "times";
  static const String dates = "dates";
}

class Task {
  final int? id;
  String title;
  List<String> times = [];
  List<String> dates = [];

  Task({this.id, required this.title, String? time}) {
    if (time != null) {
      times.add(time);
    };
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

  String getSpecialTime(String type) {
    switch (type) {
      case "fast":
        String fastestTime = times[0];
        for (int i = 1; i < times.length; i++) {
          if (DateTime.parse('1970-01-01 ${times[i]}')
              .difference(DateTime.parse('1970-01-01 $fastestTime'))
              .isNegative) {
            fastestTime = times[i];
          }
        }
        return fastestTime;
      case "average":
        int totalSeconds = 0;
        for (String time in times) {
          DateTime dateTime = DateTime.parse('1970-01-01 $time');
          totalSeconds += dateTime.hour * 3600 + dateTime.minute * 60 + dateTime.second;
        }

        int averageSeconds = (totalSeconds / times.length).ceil();
        int hours = averageSeconds ~/ 3600;
        int minutes = (averageSeconds % 3600) ~/ 60;
        int seconds = averageSeconds % 60;

        return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      default: return "...";
    }
  }

  String getDate(int index) {
    return dates[index];
  }

  // Add a new time. Place new time in list (newest to oldest)
  void addTime(String time, String date) {
    times.insert(0, time);
    dates.insert(0, date);
  }

  // Delete recorded time at given index
  void deleteTime(int index) {
    times.removeAt(index);
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
    String? times,
    String? dates,
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
