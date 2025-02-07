import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/model.dart';
import 'views/view.dart';
import 'controller/controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalculatorModel(),
      child: MaterialApp(
        title: 'Calculator App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        ),
        home: CalculatorView(),
      ),
    );
  }
}
