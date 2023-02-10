import 'dart:async';
import 'package:flutter/material.dart';

class Stopwatch extends StatefulWidget {
  final Function onAddTime;
  const Stopwatch({Key? key, required this.onAddTime}) : super(key: key);

  @override
  State<Stopwatch> createState() => _StopwatchState();
}

class _StopwatchState extends State<Stopwatch> {
  final stopwatchNameInput = TextEditingController();
  int seconds = 0, minutes = 0, hours = 0;
  String digitSeconds = "00", digitMinutes = "00", digitHours = "00";
  Timer? timer;
  bool started = false;
  String time = "";
  String title = "";

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

  void addLaps() {
    String time = "$digitHours:$digitMinutes:$digitSeconds";
    String title = stopwatchNameInput.text;
    widget.onAddTime(title, time);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 200.0,
          child: TextField(
            decoration: const InputDecoration(
              focusColor: Colors.white,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
              hintText: "Edit timer title",
              hintStyle: TextStyle(
                color: Colors.white12,
              ),
            ),
            style: const TextStyle(
              color: Colors.white,
            ),
            cursorColor: Colors.white,
            textAlign: TextAlign.center,
            controller: stopwatchNameInput,
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
                      color: Colors.white,
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
                          color: Colors.teal,
                          icon: const Icon(Icons.restart_alt),
                        ),
                        (started)
                            ? IconButton(
                                onPressed: pause,
                                color: Colors.teal,
                                icon: const Icon(Icons.pause),
                              )
                            : IconButton(
                                onPressed: start,
                                color: Colors.teal,
                                icon: const Icon(Icons.play_arrow),
                              ),
                        IconButton(
                          onPressed: addLaps,
                          color: Colors.teal,
                          icon: const Icon(Icons.flag),
                        ),
                      ],
                    )),
                  ],
                ),
              ]),
        ),
      ],
    );
  }
}