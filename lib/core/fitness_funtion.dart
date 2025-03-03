import 'package:hive/hive.dart';
import '../modules/fitness_plan_model.dart';

class FitnessDatabase {
  static const String boxName = 'fitnessBox';

  static Future<void> addActivity(FitnessPlan plan) async {
    final box = await Hive.openBox<FitnessPlan>(boxName);
    await box.add(plan);
  }

  static Future<List<FitnessPlan>> getActivities() async {
    final box = await Hive.openBox<FitnessPlan>(boxName);
    return box.values.toList();
  }

  static Future<void> updateActivity(int index, FitnessPlan updatedPlan) async {
    final box = await Hive.openBox<FitnessPlan>(boxName);
    await box.putAt(index, updatedPlan);
  }

  static Future<void> deleteActivity(int index) async {
    final box = await Hive.openBox<FitnessPlan>(boxName);
    await box.deleteAt(index);
  }
}
