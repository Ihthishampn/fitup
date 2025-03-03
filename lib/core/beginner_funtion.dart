import '../modules/beginner_model.dart';
import 'package:hive/hive.dart';

class WorkoutFunctions {
  final Box<WorkoutModel> workoutBox = Hive.box<WorkoutModel>('workoutBox');

  Future<void> addWorkout(WorkoutModel workout) async {
    await workoutBox.add(workout);
  }

  Future<void> updateWorkout(int index, WorkoutModel workout) async {
    await workoutBox.putAt(index, workout);
  }

  Future<void> deleteWorkout(int index) async {
    await workoutBox.deleteAt(index);
  }

  List<WorkoutModel> getAllWorkouts() {
    return workoutBox.values.toList();
  }
}
