import 'package:hive/hive.dart';

part 'fitness_plan_model.g.dart';

@HiveType(typeId: 2)
class FitnessPlan {
  @HiveField(0)
  String activity;

  @HiveField(1)
  String duration;

  @HiveField(2)
  String distance;

  FitnessPlan({
    required this.activity,
    required this.duration,
    required this.distance,
  });
}
