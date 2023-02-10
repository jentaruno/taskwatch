import 'package:flutter/material.dart';
import 'tasks.dart';

class TimeGrid extends StatefulWidget {
  final List<Task> taskList;

  const TimeGrid({ Key? key, required this.taskList }) : super(key: key);

  @override
  State<TimeGrid> createState() => _TimeGridState();
}

class _TimeGridState extends State<TimeGrid> {

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(20),
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      shrinkWrap: true,
      childAspectRatio: (2 / 1),
      children: List.generate(widget.taskList.length, (index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.taskList[index].getTopTime(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36.0,
                    fontWeight: FontWeight.w600,
                  )),
              Text(widget.taskList[index].getName(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  )),
            ],
          ),
        );
      }),
    );
  }
}
