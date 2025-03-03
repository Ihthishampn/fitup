import 'package:hive/hive.dart';

part 'advanced_model.g.dart';

@HiveType(typeId: 4)
class AdvanceWorkout {
  @HiveField(0)
  String name;

  @HiveField(1)
  String duration;

  @HiveField(2)
  String goal;

  @HiveField(3)
  String count;

  @HiveField(4)
  String image;

  @HiveField(5)
  bool completed;

  AdvanceWorkout({
    required this.name,
    required this.duration,
    required this.goal,
    required this.count,
    required this.image,
    this.completed = false,
  });
}
