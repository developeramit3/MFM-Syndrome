import 'package:flutter/material.dart';

class GlobalDialogApp extends StatefulWidget {
  @override
  _GlobalDialogAppState createState() => _GlobalDialogAppState();
}

class _GlobalDialogAppState extends State<GlobalDialogApp> {
  final navigatorKey = GlobalKey<NavigatorState>();

  void show() {
    final context = navigatorKey.currentState.overlay.context;
    final dialog = AlertDialog(
      content: Text('Test'),
    );
    showDialog(context: context, builder: (x) => dialog);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        body: Center(
          child: RaisedButton(
            child: Text('Show alert'),
            onPressed: show,
          ),
        ),
      ),
    );
  }
}