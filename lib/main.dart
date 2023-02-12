import 'package:countup/timegrid.dart';
import 'package:flutter/material.dart';
import 'stopwatch.dart';
import 'tasks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskWatch',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryIconTheme: IconThemeData(color: Colors.teal),
        primaryColor: Colors.teal,
        primarySwatch: Colors.teal,
        canvasColor: Colors.black87
      ),
      home: const HomeApp(),
    );
  }
}

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  String title = "TaskWatch";
  TaskList taskList = TaskList();

  callback(title, time) {
    TaskList newTaskList = taskList;
    newTaskList.addTask(Task(id: taskList.length(), title: title, time: time));
    setState(() {
      taskList = newTaskList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              top: 12.0,
              bottom: 12.0,
            ),
            child: Image.asset(
              "assets/images/appicon.png",
            ),
          ),
          centerTitle: false,
          title: Text(title),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stopwatch(onAddTime: callback),
                const SizedBox(
                  height: 40.0,
                ),
                TimeGrid(
                  taskList: taskList,
                )
              ],
            ))));
  }
}
