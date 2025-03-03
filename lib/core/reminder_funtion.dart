import 'package:hive/hive.dart';
import '../modules/reminder_model.dart';

const String reminderBoxName = 'remindersss';

class ReminderFunction {
  static Box<Reminder> get _box => Hive.box<Reminder>(reminderBoxName);

  static Future<void> addReminder(Reminder reminder) async {
    await _box.add(reminder);
  }

  static List<Reminder> getReminders() {
    return _box.values.toList();
  }

  static Future<void> deleteReminder(int index) async {
    await _box.deleteAt(index);
  }
}