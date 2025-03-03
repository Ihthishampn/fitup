import 'package:hive/hive.dart';

    part 'musle_model.g.dart';

@HiveType(typeId: 6)
class MuscleModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String time;

  @HiveField(2)
  double protein;

  @HiveField(3)
  double calories;

  @HiveField(4)
  double carbs;

  @HiveField(5)
  double fats;

  @HiveField(6)
  String? imagePath;

  @HiveField(7)
  bool isCompleted;

  MuscleModel({
    required this.name,
    required this.time,
    required this.protein,
    required this.calories,
    required this.carbs,
    required this.fats,
    this.imagePath,
    this.isCompleted = false,
  });
}
