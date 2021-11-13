import 'package:adaptive_scaffold/adaptive_scaffold.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      leftMenuHeader: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ListTile(
          title: const Text(
            'Demo',
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
            ),
          ),
        ),
      ),
      leftMenuFooter: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text("About us"),
          ),
          ListTile(
            leading: Icon(Icons.rate_review),
            title: Text("Facebook"),
          ),
        ],
        shrinkWrap: true,
      ),
      destinations: [
        AdaptiveScaffoldDestination(
          icon: const Icon(Icons.home),
          title: "Home",
          bodyBuilder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Home"),
              ),
            );
          },
        ),
        AdaptiveScaffoldDestination(
          icon: const Icon(Icons.calendar_today),
          title: "Calendars",
          bodyBuilder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Calendars"),
              ),
            );
          },
        ),
        AdaptiveScaffoldDestination(
          icon: const Icon(Icons.settings),
          title: "Settings",
          bodyBuilder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Settings"),
              ),
            );
          },
        ),
      ],
    );
  }
}
