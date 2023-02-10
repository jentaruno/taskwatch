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
                        fontSize: 70,
                        color: Colors.white,
                      ),
                    ),
                    // Time graph

                    // Recent times
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.task.getNumberOfTimes(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              widget.task.getTime(index),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          )
                        );
                      },
                    ),
                  ],
                ))));
  }
}
