import 'package:flutter/material.dart';

void main() {
  runApp(const MainAppRoute());
}

class MainAppRoute extends StatefulWidget {
  const MainAppRoute({super.key});

  @override
  State<MainAppRoute> createState() => _MainAppRouteState();
}

class _MainAppRouteState extends State<MainAppRoute> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("okno 1"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(),
        ),
      ),
    );

  }
}

