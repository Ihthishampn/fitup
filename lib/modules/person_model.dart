import 'package:hive/hive.dart';

part 'person_model.g.dart';

@HiveType(typeId: 9)
class Person {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? dob;

  @HiveField(2)
  String? age;

  @HiveField(3)
  String? gender;

  @HiveField(4)
  String? imagePath;

  @HiveField(5)
  double? weight;

  @HiveField(6)
  double? height;

  @HiveField(7)
  String? physicalCondition;

  Person({
     this.name,
     this.dob,
   this.age,
     this.gender,
    this.imagePath,
    this.weight,
    this.height,
     this.physicalCondition,
  });
}
