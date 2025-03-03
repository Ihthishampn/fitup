import 'package:hive/hive.dart';
import '../modules/weight_model.dart';

class WeightDatabase {
  static const String boxName = 'weightBox';

  static Future<void> addEntry(WeightModel entry) async {
    final box = Hive.box<WeightModel>(boxName);
    await box.add(entry);
  }

  static List<WeightModel> getEntries() {
    final box = Hive.box<WeightModel>(boxName);
    return box.values.toList();
  }

  static Future<void> updateEntry(int index, WeightModel updatedEntry) async {
    final box = Hive.box<WeightModel>(boxName);
    await box.putAt(index, updatedEntry);
  }

  static Future<void> deleteEntry(int index) async {
    final box = Hive.box<WeightModel>(boxName);
    await box.deleteAt(index);
  }

  static Future<void> toggleComplete(int index) async {
    final box = Hive.box<WeightModel>(boxName);
    final entry = box.getAt(index);
    if (entry != null) {
      entry.isCompleted = !entry.isCompleted;
      await entry.save();
    }
  }
}
