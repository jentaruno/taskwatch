import 'package:flutter/material.dart';
import 'taskview.dart';
import 'tasks.dart';

class TimeGrid extends StatefulWidget {
  final TaskList taskList;

  const TimeGrid({Key? key, required this.taskList}) : super(key: key);

  @override
  State<TimeGrid> createState() => _TimeGridState();
}

class _TimeGridState extends State<TimeGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 500,
          childAspectRatio: (2 / 1),
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        padding: const EdgeInsets.all(20),
        shrinkWrap: true,
        itemCount: widget.taskList.length(),
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TaskScreen(task: widget.taskList.get(index)))),
              child: GridTile(
                  child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.taskList.get(index).getTime(0),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36.0,
                          fontWeight: FontWeight.w600,
                        )),
                    Text(widget.taskList.get(index).getName(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        )),
                  ],
                ),
              )));
        });
  }
}
