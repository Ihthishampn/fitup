import 'package:hive/hive.dart';
import 'package:ui/modules/musle_model.dart';

class MuscleDatabase {
  static Box<MuscleModel> getBox() => Hive.box<MuscleModel>('muscle_food');

  static Future<void> addFood(MuscleModel food) async {
    await getBox().add(food);
  }

  static List<MuscleModel> getFoods() {
    return getBox().values.toList();
  }

  static Future<void> updateFood(int index, MuscleModel food) async {
    await getBox().putAt(index, food);
  }

  static Future<void> deleteFood(int index) async {
    await getBox().deleteAt(index);
  }
}
