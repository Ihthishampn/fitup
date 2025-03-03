import 'package:hive/hive.dart';

part 'data_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String email;

  UserModel({required this.name, required this.email});
}
