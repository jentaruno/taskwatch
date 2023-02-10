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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.teal,
      ),
      home: const HomeApp(),
    );
  }
}

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);
  static const title = "TaskWatch";

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  String title = "TaskWatch";
  List<Task> taskList = [];

  callback(title, time) {
    List<Task> newTaskList = taskList;
    newTaskList.add(Task(id: taskList.length, title: title, time: time));
    setState(() {
      taskList = newTaskList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
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
                Stopwatch(
                  onAddTime: callback
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TimeGrid(
                  taskList: taskList,
                )
              ],
            ))));
  }
}
