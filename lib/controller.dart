import 'model.dart';

class CalculatorController {
  final CalculatorModel model;

  CalculatorController(this.model);

  void onButtonPressed(String value) {
    if (value == 'C') {
      model.clearInput();
    } else if (value == '=') {
      model.calculateResult();
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
