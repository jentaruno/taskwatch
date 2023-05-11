import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

const String tableTasks = "tasks";
enum TaskSort { fast, long, average }
extension TaskSortExtension on TaskSort {
  Color get color {
    switch (this) {
      case TaskSort.fast: return Colors.greenAccent;
      case TaskSort.long: return Colors.blueAccent;
      case TaskSort.average: return Colors.orangeAccent;
      default: return Colors.white12;
    }
  }

  String get name {
    switch (this) {
      case TaskSort.fast: return "FASTEST";
      case TaskSort.long: return "LONGEST";
      case TaskSort.average: return "AVERAGE";
      default: return "UNSORTED";
    }
  }

  IconData get icon {
    switch (this) {
      case TaskSort.fast: return Icons.arrow_upward_rounded;
      case TaskSort.long: return Icons.arrow_downward_rounded;
      case TaskSort.average: return Icons.hourglass_empty_rounded;
      default: return Icons.question_mark_rounded;
    }
  }

}

// HELPFUL PUBLIC FUNCTIONS

// convert DateTime object to MM/dd/yyyy format string
String dateToString(DateTime dt) {
  var formatter = DateFormat('MM/dd/yyyy');
  return formatter.format(dt);
}

// convert String to DateTime, time 00:00:00
DateTime stringToDate(String s) {
  DateFormat formatter = DateFormat('MM/dd/yyyy');
  // parse the input date string into a DateTime object
  DateTime dateTime = formatter.parse(s);
  DateTime dateWithZeroTime = DateTime(dateTime.year, dateTime.month, dateTime.day);

  return dateWithZeroTime;
}

String formatTimeDifference(DateTime startTime, DateTime endTime) {
  Duration difference = endTime.difference(startTime);
  int hours = difference.inHours;
  int minutes = difference.inMinutes.remainder(60);
  int seconds = difference.inSeconds.remainder(60);
  return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
}

class TaskFields {
  static const List<String> values = [id, title, times, dates];
  static const String id = "id";
  static const String title = "title";
  static const String times = "times";
  static const String dates = "dates";
}

// TASK CLASS

class Task {
  final int? id;
  String title;
  List<String> times = [];
  List<DateTime> dates = [];
  TaskSort taskSort = TaskSort.average;

  Task({this.id, required this.title, String? time}) {
    if (time != null) {
      times.add(time);
    }
    dates.add(DateTime.now());
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

  String getSpecialTime() {
    switch (taskSort) {
      case TaskSort.fast:
        String fastestTime = times[0];
        for (int i = 1; i < times.length; i++) {
          if (DateTime.parse('1970-01-01 ${times[i]}')
              .difference(DateTime.parse('1970-01-01 $fastestTime'))
              .isNegative) {
            fastestTime = times[i];
          }
        }
        return fastestTime;
      case TaskSort.long:
        String longestTime = times[0];
        for (int i = 1; i < times.length; i++) {
          if (DateTime.parse('1970-01-01 $longestTime')
              .difference(DateTime.parse('1970-01-01 ${times[i]}'))
              .isNegative) {
            longestTime = times[i];
          }
        }
        return longestTime;
      case TaskSort.average:
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

  DateTime getDate(int index) {
    return dates[index];
  }

  String getDateString(int index) {
    return dateToString(dates[index]);
  }

  // Add a new time. Place new time in list (newest to oldest)
  void addTime(String time, DateTime date) {
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
        TaskFields.dates: dates.map((e) => dateToString(e)).join(",")
      };

  // Database function, convert from JSON
  static Task fromJSON(Map<String, Object?> json) {
    Task loadedTask = Task(
        id: json[TaskFields.id] as int?,
        title: json[TaskFields.title] as String);

    String loadedTimesString = json[TaskFields.times] as String;
    List<String> loadedTimes = loadedTimesString.split(",");
    String loadedDatesString = json[TaskFields.dates] as String;
    List loadedDates =
    loadedDatesString.split(",").map((e) => stringToDate(e)).toList();
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
        taskCopy.addTime(times[i], stringToDate(dates[i]));
      }
    }
    return taskCopy;
  }
}
