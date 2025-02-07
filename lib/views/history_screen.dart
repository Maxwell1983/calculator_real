import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/model.dart';
import '../models/calculation_log.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("History")),
        body: FutureBuilder<List<CalculationLog>>(
          future: context.read<CalculatorModel>().history,
          builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: Text("Loading..."));
    }
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
    return Center(child: Text("No history available"));
    }

    // Remove duplicates before displaying
    final uniqueHistory = snapshot.data!.toSet().toList();

    return ListView.builder(
    itemCount: uniqueHistory.length,
    itemBuilder: (context, index) {
    final log = uniqueHistory[index];
    return ListTile(
    title: Text("${log.expression} = ${log.result}"),
    subtitle: Text(log.timestamp),
    );
    },
    );
    },
  ),

  floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete),
    onPressed: () async {
      await context.read<CalculatorModel>().clearHistory();
      (context as Element).markNeedsBuild(); // Force UI update
    },
  ),
    );
  }
}
