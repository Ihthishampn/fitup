import 'package:hive/hive.dart';

part 'reminder_model.g.dart';

@HiveType(typeId: 15)
class Reminder extends HiveObject {
  @HiveField(0)
  String content;

  @HiveField(1)
  String time;

  Reminder({required this.content, required this.time});
}