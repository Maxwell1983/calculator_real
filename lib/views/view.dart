import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/model.dart';
import '../controller/controller.dart';
import '../views/history_screen.dart';

class CalculatorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = context.watch<CalculatorModel>();
    final controller = CalculatorController(model);

    return Scaffold(
      appBar: AppBar(
        title: Text('KALKULAATOR'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[200],
              width: double.infinity,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(20),
              child: Text(
                model.input,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _buildButtonRow(context, ['7', '8', '9', '÷'], controller),
                _buildButtonRow(context, ['4', '5', '6', '×'], controller),
                _buildButtonRow(context, ['1', '2', '3', '-'], controller),
                _buildButtonRow(context, ['C', '0', '.', '+'], controller),
                _buildButtonRow(context, ['km → m', '='], controller, isConversion: true),
                _buildButtonRow(context, ['History'], controller),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[300],
              width: double.infinity,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(20),
              child: Text(
                model.result,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context, List<String> buttons, CalculatorController controller, { bool isConversion = false }) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons.map((button) {
          return Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (button == 'km → m') {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConversionView()));
                } else if (button == 'History') { // Add History button
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HistoryScreen()));
                } else {
                  controller.onButtonPressed(button);
                }
              },
              child: Text(button, style: TextStyle(fontSize: 20)),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ConversionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = context.watch<CalculatorModel>();
    final controller = CalculatorController(model);

    return Scaffold(
      appBar: AppBar(
        title: Text('Conversion: km → m'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              width: double.infinity,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(20),
              child: Text(
                model.conversionInput,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                _buildConversionButtonRow(context, ['7', '8', '9'], controller),
                _buildConversionButtonRow(context, ['4', '5', '6'], controller),
                _buildConversionButtonRow(context, ['1', '2', '3'], controller),
                _buildConversionButtonRow(context, ['C', 'back', '0', '='], controller),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[300],
              width: double.infinity,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(20),
              child: Text(
                model.conversionResult,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Move `_buildConversionButtonRow` inside the `ConversionView` class
  Widget _buildConversionButtonRow(
      BuildContext context,
      List<String> buttons,
      CalculatorController controller,
      ) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons.map((button) {
          return Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (button == 'back') {
                  Navigator.of(context).pop();
                } else if (button == 'C') {
                  controller.clearConversionInput();
                } else {
                  controller.onConversionButtonPressed(button);
                }
              },
              child: Text(
                button,
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
