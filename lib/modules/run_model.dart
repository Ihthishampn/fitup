import 'package:hive/hive.dart';

part 'run_model.g.dart';

@HiveType(typeId: 37)
class RunRecord {
  @HiveField(0)
  final int milliseconds;

  @HiveField(1)
  final String date;

  RunRecord({
    required this.milliseconds,
    required this.date,
  });
}

@HiveType(typeId: 38)
class CompletedDay {
  @HiveField(0)
  final int day;

  CompletedDay({
    required this.day,
  });
}