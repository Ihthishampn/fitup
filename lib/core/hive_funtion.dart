import 'package:hive/hive.dart';
import '../modules/data_model.dart';


class HiveStorage {
  static Future<void> saveUserData(String name, String email) async {
    var box = await Hive.openBox<UserModel>('userBox');

   
    if (box.isNotEmpty) return; 

    await box.put('user', UserModel(name: name, email: email));
  }

  static Future<UserModel?> getUserData() async {
    var box = await Hive.openBox<UserModel>('userBox');
    return box.get('user');
  }

  static Future<void> clearUserData() async {
    var box = await Hive.openBox<UserModel>('userBox');
    await box.clear();
  }
}


