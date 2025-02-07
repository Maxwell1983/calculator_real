import '../models/model.dart';

class CalculatorController {
  final CalculatorModel model;

  CalculatorController(this.model);

  void onButtonPressed(String value) async {
    if (value == 'C') {
      model.clearInput();
    } else if (value == '=') {

      await model.calculateResult(); // Add calculation to history
    } else {
      model.addInput(value);
    }
  }


  void onConversionButtonPressed(String value) {
    if (value == '=') {
      model.performConversion();
    } else {
      model.updateConversionInput(value);
    }
  }

  void clearConversionInput() {
    model.clearConversionInput();
  }
}
