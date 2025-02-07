import '../../models/calculation_log.dart';

abstract class Persistence {
  Future<void> init();
  Future<void> saveData(CalculationLog data);
  Future<List<CalculationLog>> getAllData();
}
