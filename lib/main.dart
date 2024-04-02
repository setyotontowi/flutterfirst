import 'package:flutter/material.dart';
import 'package:velmo/routes/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final routes = MyRoutes();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: routes.onGenerateRoute,
    );
  }
}
