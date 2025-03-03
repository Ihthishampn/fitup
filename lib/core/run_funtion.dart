import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../modules/run_model.dart';

class RunFunction {
  static const String _runRecordsBox = 'runRecordsBox';
  static const String _completedDaysBox = 'completedDaysBox';


  static Future<void> initHive() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(RunRecordAdapter().typeId)) {
      Hive.registerAdapter(RunRecordAdapter());
    }
    if (!Hive.isAdapterRegistered(CompletedDayAdapter().typeId)) {
      Hive.registerAdapter(CompletedDayAdapter());
    }
  }

  static Future<void> saveRunRecord(RunRecord record) async {
    final box = await Hive.openBox<RunRecord>(_runRecordsBox);
    await box.add(record);
  }

  static Future<List<RunRecord>> loadRunRecords() async {
    final box = await Hive.openBox<RunRecord>(_runRecordsBox);
    return box.values.toList();
  }

  static Future<void> deleteRunRecord(int index) async {
    final box = await Hive.openBox<RunRecord>(_runRecordsBox);
    await box.deleteAt(index);
  }

  static Future<void> clearRunRecords() async {
    final box = await Hive.openBox<RunRecord>(_runRecordsBox);
    await box.clear();
  }

  static Future<void> saveCompletedDay(int day) async {
    final box = await Hive.openBox<CompletedDay>(_completedDaysBox);

    final existingDays = box.values.map((e) => e.day).toSet();
    if (!existingDays.contains(day)) {
      await box.add(CompletedDay(day: day));
    } else {
      debugPrint('Day $day has already been recorded as completed.');
    }
  }

  static Future<Set<int>> loadCompletedDays() async {
    final box = await Hive.openBox<CompletedDay>(_completedDaysBox);
    return box.values.map((e) => e.day).toSet();
  }

  static Future<void> clearCompletedDays() async {
    final box = await Hive.openBox<CompletedDay>(_completedDaysBox);
    await box.clear();
  }
}
