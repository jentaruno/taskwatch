import 'package:flutter/material.dart';
import 'package:countup/tasks.dart';

class TaskScreen extends StatefulWidget {
  final Task task;

  const TaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final taskNameInput = TextEditingController();
  final String title = "TaskWatch";
  List<String> titleInputText = ["",""];

  Task removeTask() {
    Navigator.pop(context);
    return widget.task;
  }

  @override
  Widget build(BuildContext context) {
    taskNameInput.text = widget.task.getName();
    titleInputText[0] = widget.task.getName();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          title: Text(title),
        ),
        body: Padding(
            padding: const EdgeInsets.all(36.0),
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Task title
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      titleInputText[0] = titleInputText[1];
                      titleInputText[1] = value;
                    });
                  },
                  onEditingComplete: () {
                    if (titleInputText[1].isEmpty) {
                      setState(() {
                        titleInputText[1] = titleInputText[0];
                      });
                    }
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
                      hintStyle: TextStyle(color: Colors.white12)
                  ),
                  textAlign: TextAlign.center,
                  controller: taskNameInput,
                ),
                // Top time
                Text(
                  widget.task.getTime(0),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 70.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: removeTask,
                        color: Theme.of(context).colorScheme.primary,
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  )),
                const SizedBox(
                  height: 20.0,
                ),
                // Time graph

                // Recent times
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.task.getNumberOfTimes(),
                  itemBuilder: (context, index) {
                    return
                      Padding(
                        padding: const EdgeInsets.all(20),
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.task.getTime(index),
                            style: const TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            widget.task.getDate(index),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white12,
                            ),
                          )
                        ]));
                  },
                ),
              ],
            ))));
  }
}
