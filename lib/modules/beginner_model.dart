import 'package:hive/hive.dart';

part 'beginner_model.g.dart';

@HiveType(typeId: 1) 
class WorkoutModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String duration;

  @HiveField(2)
  final String goal;

  @HiveField(3)
  final String count;

  @HiveField(4)
  final String image;

  @HiveField(5)
  bool completed;

  var level;

  WorkoutModel({
    required this.name,
    required this.duration,
    required this.goal,
    required this.count,
    required this.image,
    this.completed = false,
  });

  get id => null;
}