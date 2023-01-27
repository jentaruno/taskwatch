import 'dart:async';

import 'package:flutter/material.dart';

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
  static const title = "CountUp";

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  String title = "CountUp";

  int seconds = 0, minutes = 0, hours = 0;
  String digitSeconds = "00", digitMinutes = "00", digitHours = "00";
  Timer? timer;
  bool started = false;
  List laps = [];

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
    String lap = "$digitHours:$digitMinutes:$digitSeconds";
    setState(() {
      laps.add(lap);
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/images/appicon.png",
            ),
          ),
          centerTitle: false,
          title: Text(title),
        ),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 200.0,
                      child: TextField(
                        decoration: InputDecoration(
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
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        cursorColor: Colors.white,
                        textAlign: TextAlign.center,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      onPressed: start,
                                      color: Colors.teal,
                                      icon: const Icon(Icons.play_arrow),
                                    ),
                                    IconButton(
                                      onPressed: pause,
                                      color: Colors.teal,
                                      icon: const Icon(Icons.pause),
                                    ),
                                    IconButton(
                                      onPressed: reset,
                                      color: Colors.teal,
                                      icon: const Icon(Icons.restart_alt),
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
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                        height: 300.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFF444444),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListView.builder(
                          itemCount: laps.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Time ${index + 1}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        )),
                                    Text("${laps[index]}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        ))
                                  ],
                                ));
                          },
                        )),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                )))));
  }
}
