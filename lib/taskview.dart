import 'package:flutter/material.dart';
import 'package:countup/tasks.dart';

class TaskScreen extends StatefulWidget {
  final Task task;

  const TaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final String title = "TaskWatch";

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
                Text(
                  widget.task.getName(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
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
                              color: Colors.white,
                            ),
                          )
                        ]));
                  },
                ),
              ],
            ))));
  }
}
