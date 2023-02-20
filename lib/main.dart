import 'package:countup/providers/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TasksProvider()),
    ],
    child: const MyApp(),
  ));
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
          primaryIconTheme: IconThemeData(color: Colors.teal),
          primaryColor: Colors.teal,
          primarySwatch: Colors.teal,
          canvasColor: Colors.black87),
      initialRoute: "/",
      routes: {
        '/': (context) => HomeApp(),
      },
    );
  }
}
