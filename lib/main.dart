import 'package:flutter/material.dart';
import 'dart:async';
import 'tasks.dart';
import 'task-view.dart';

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
          primaryIconTheme: const IconThemeData(color: Colors.teal),
          primaryColor: Colors.teal,
          primarySwatch: Colors.teal,
          canvasColor: Colors.black87),
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
  // MAIN STATES
  String title = "TaskWatch";
  TaskList taskList = TaskList();

  // STOPWATCH STATES
  final stopwatchNameInput = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String placeholder = "Edit task title";
  int seconds = 0, minutes = 0, hours = 0;
  String digitSeconds = "00", digitMinutes = "00", digitHours = "00";
  Timer? timer;
  bool started = false;
  String time = "";
  String taskTitle = "";

  // TIME GRID STATES
  List<String> itemsList = [];
  List<String> itemsListSearch = [];
  final FocusNode _textFocusNode = FocusNode();
  final TextEditingController _searchQuery = TextEditingController();

  // #### STOPWATCH FUNCTIONS

  // Start, pause, and reset stopwatch
  void start() {
    if (started) {
      return;
    }
    started = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int localSeconds = seconds + 1;
      int localMinutes = minutes;
      int localHours = hours;

      if (localSeconds > 59) {
        if (localMinutes > 59) {
          localHours++;
          localMinutes = 0;
        } else {
          localMinutes++;
          localSeconds = 0;
        }
      }
      setState(() {
        seconds = localSeconds;
        minutes = localMinutes;
        hours = localHours;
        digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
      });
    });
  }

  void pause() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  void reset() {
    timer!.cancel();
    setState(() {
      seconds = 0;
      minutes = 0;
      hours = 0;

      digitSeconds = "00";
      digitMinutes = "00";
      digitHours = "00";

      started = false;
    });
  }

  // If time is > 0s, add time
  void recordTime() {
    if (hours > 0 || minutes > 0 || seconds > 0) {
      String time = "$digitHours:$digitMinutes:$digitSeconds";
      String taskTitle = stopwatchNameInput.text;
      TaskList newTaskList = taskList;
      newTaskList
          .add(Task(id: taskList.length(), title: taskTitle, time: time));
      setState(() {
        taskList = newTaskList;
        itemsList = newTaskList.getTasks().map((e) => e.getName()).toList();
      });
    }
  }

  deleteTaskCallback(Task task) {
    TaskList newTaskList = taskList;
    newTaskList.remove(task);
    setState(() {
      taskList = newTaskList;
      itemsList = newTaskList.getTasks().map((e) => e.getName()).toList();
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
                // STOPWATCH
                Column(
                  children: [
                    SizedBox(
                      width: 200.0,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please title your task";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              focusColor: Colors.white,
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: placeholder,
                              hintStyle:
                                  const TextStyle(color: Colors.white12)),
                          textAlign: TextAlign.center,
                          controller: stopwatchNameInput,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: 350,
                      height: 350,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black12,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("$digitHours:$digitMinutes:$digitSeconds",
                                style: const TextStyle(
                                  fontSize: 70.0,
                                  fontWeight: FontWeight.w600,
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      onPressed: reset,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      icon: const Icon(Icons.restart_alt),
                                    ),
                                    (started)
                                        ? IconButton(
                                            onPressed: pause,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            icon: const Icon(Icons.pause),
                                          )
                                        : IconButton(
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                start();
                                              }
                                            },
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            icon: const Icon(Icons.play_arrow),
                                          ),
                                    IconButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          recordTime();
                                        }
                                      },
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      icon: const Icon(Icons.flag),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          ]),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 40.0,
                ),

                // TIME GRID
                Column(children: [
                  Padding(
                      padding: EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _searchQuery,
                        focusNode: _textFocusNode,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            prefixIconColor: Colors.white30,
                            hintText: "Search tasks",
                            hintStyle: TextStyle(color: Colors.white12),
                            filled: true,
                            fillColor: Colors.black12,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            )),
                        onChanged: (value) {
                          setState(() {
                            itemsListSearch = itemsList
                                .where((element) => element
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                            if (_searchQuery.text.isNotEmpty &&
                                itemsListSearch.isEmpty) {}
                          });
                        },
                      )),
                  _searchQuery.text.isNotEmpty && itemsListSearch.isEmpty
                      ? const Text("No results found")
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 500,
                            childAspectRatio: (2 / 1),
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                          padding: const EdgeInsets.all(20),
                          shrinkWrap: true,
                          itemCount: _searchQuery.text.isNotEmpty
                              ? itemsListSearch.length
                              : itemsList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TaskScreen(
                                            task: taskList.get(index),
                                            onDeleteTask: deleteTaskCallback
                                        ))),
                                child: GridTile(
                                    child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.white10,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(taskList.get(index).getTime(0),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 36.0,
                                            fontWeight: FontWeight.w600,
                                          )),
                                      Text(
                                          _searchQuery.text.isNotEmpty
                                              ? itemsListSearch[index]
                                              : itemsList[index],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                          )),
                                    ],
                                  ),
                                )));
                          }),
                ]),
              ],
            ))));
  }
}
