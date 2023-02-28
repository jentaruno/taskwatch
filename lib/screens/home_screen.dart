import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/tasks.dart';
import '../providers/tasks_provider.dart';
import '../providers/database.dart';
import 'task_screen.dart';

class HomeApp extends StatelessWidget {
  const HomeApp({Key? key}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    },
    child: Scaffold(
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
          title: const Text("TaskWatch"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Stopwatch(),
                    const SizedBox(
                      height: 40.0,
                    ),
                    TimeGrid(
                      taskList: context.watch<TasksProvider>().taskList,
                    )
                  ],
                )))));
  }
}

class TimeGrid extends StatefulWidget {
  final List<Task> taskList;

  const TimeGrid({Key? key, required this.taskList}) : super(key: key);

  @override
  State<TimeGrid> createState() => _TimeGridState();
}

class _TimeGridState extends State<TimeGrid> {
  final key = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  late List<String> itemsList = [];
  List<String> itemsListSearch = [];
  final FocusNode _textFocusNode = FocusNode();
  final TextEditingController _searchQuery = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAllTasks();
  }

  @override
  void dispose() {
    TasksDatabase.instance.close();
    super.dispose();
  }

  Future loadAllTasks() async {
    setState(() => isLoading = true);
    await context.read<TasksProvider>().loadTasks();
    setState(() => isLoading = false);
  }

  deleteTaskCallback(Task task) {
    context.read<TasksProvider>().deleteTask(task);
  }

  // @override
  // void dispose() {
  //   _textFocusNode.dispose();
  //   _searchQuery!.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    itemsList = context.watch<TasksProvider>().taskList.map((e) => e.getName()).toList();

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TasksProvider()),
        ],
        child:
        isLoading
            ? const CircularProgressIndicator()
            :
        Column(children: [
          TextField(
                controller: _searchQuery,
                focusNode: _textFocusNode,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: Colors.white30,
                    hintText: "Search tasks",
                    hintStyle: const TextStyle(color: Colors.white12),
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    )),
                onChanged: (value) {
                  setState(() {
                    itemsListSearch = itemsList
                        .where((element) =>
                        element.toLowerCase().contains(value.toLowerCase()))
                        .toList();
                    if (_searchQuery.text.isNotEmpty &&
                        itemsListSearch.isEmpty) {}
                  });
                },
              ),
          const SizedBox(height: 10),
          _searchQuery.text.isNotEmpty && itemsListSearch.isEmpty
              ? const Text("No results found")
              : GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: (5 / 3),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _searchQuery.text.isNotEmpty
                  ? itemsListSearch.length
                  : itemsList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaskScreen(
                                task: context.watch<TasksProvider>().taskList[index],
                              onDeleteTask: deleteTaskCallback,
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
                              Text(
                                  widget.taskList[index]
                                      .getSpecialTime("fast"),
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
        ]));
  }
}

class Stopwatch extends StatefulWidget {
  const Stopwatch({Key? key}) : super(key: key);

  @override
  State<Stopwatch> createState() => _StopwatchState();
}

// STOPWATCH
class _StopwatchState extends State<Stopwatch> {
  final stopwatchNameInput = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int seconds = 0, minutes = 0, hours = 0;
  String digitSeconds = "00", digitMinutes = "00", digitHours = "00";
  Timer? timer;
  bool started = false;
  String time = "";
  String title = "";
  String _previousText = "";

  // Prevent empty title
  void preventEmpty() {
    if (stopwatchNameInput.text.isNotEmpty) {
      _previousText = stopwatchNameInput.text;
    } else {
      stopwatchNameInput.text = _previousText;
    }
  }

  // Start stopwatch
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
      String title = stopwatchNameInput.text;
      List<Task> taskList = context.read<TasksProvider>().taskList;
      Task task = Task(id: taskList.length, title: title, time: time);
      reset();
      context.read<TasksProvider>().addTask(task);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TasksProvider()),
      ],
      child: Column(
        children: [
          SizedBox(
            width: 300.0,

            child: Form(
              key: _formKey,
              child: TextFormField(
                style: const TextStyle(fontSize: 24.0),
                onEditingComplete: preventEmpty,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please title your task";
                  }
                  if (value.length > 30) {
                    return "Title is 30 characters max";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    focusColor: Colors.white,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Edit task title",
                    hintStyle: TextStyle(color: Colors.white12)),
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
              color: Colors.black26,
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: reset,
                                color: Theme.of(context).colorScheme.primary,
                                icon: const Icon(Icons.restart_alt),
                              ),
                              (started)
                                  ? IconButton(
                                onPressed: pause,
                                color: Theme.of(context).colorScheme.primary,
                                icon: const Icon(Icons.pause),
                              )
                                  : IconButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    start();
                                  }
                                },
                                color: Theme.of(context).colorScheme.primary,
                                icon: const Icon(Icons.play_arrow),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    recordTime();
                                  }
                                },
                                color: Theme.of(context).colorScheme.primary,
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
    );
  }
}
