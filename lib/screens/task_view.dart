import 'package:flutter/material.dart';
import 'package:countup/providers/tasks.dart';
import 'package:provider/provider.dart';
import 'package:countup/providers/tasks_provider.dart';

class TaskScreen extends StatefulWidget {
  final Task task;
  final Function onDeleteTask;

  const TaskScreen({Key? key, required this.task, required this.onDeleteTask})
      : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  TextEditingController taskNameInput = TextEditingController();
  final String title = "TaskWatch";
  String _previousText = "";

  @override
  void initState() {
    super.initState();
    _previousText = widget.task.getName();
    taskNameInput = TextEditingController(text: _previousText);
  }

  void preventEmpty() {
    if (taskNameInput.text.isNotEmpty) {
      _previousText = taskNameInput.text;
    } else {
      taskNameInput.text = _previousText;
    }
  }

  void handleRename() {
    preventEmpty();
    context.read<TasksProvider>().renameTask(widget.task, taskNameInput.text);
  }

  void handleDeleteTime(int index) {
    context.read<TasksProvider>().deleteTaskTime(widget.task, index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
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
                  onEditingComplete: handleRename,
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
                  controller: taskNameInput,
                ),
                // Top time
                Text(
                  widget.task.getSpecialTime("fast"),
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
                          onPressed: () {
                            Navigator.pop(context);
                            Future.delayed(Duration(milliseconds: 50), () {
                              widget.onDeleteTask(widget.task);
                            });
                          },
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
                    return Padding(
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
                              Row(
                                children: [
                                  Text(
                                    widget.task.getDate(index),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white12,
                                    ),
                                  ),
                                  (widget.task.getNumberOfTimes() > 1)
                                      ? SizedBox(
                                          width: 24.0,
                                          child: IconButton(
                                            onPressed: () =>
                                                handleDeleteTime(index),
                                            color: Colors.white,
                                            icon: const Icon(Icons.delete),
                                          ),
                                        )
                                      : SizedBox(width: 24.0)
                                ],
                              ),
                            ]));
                  },
                ),
              ],
            ))));
  }
}
