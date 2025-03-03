import 'package:hive/hive.dart';
import '../modules/intermediate_model.dart';

class IntermediateWorkoutFunction {
  final Box<IntermediateWorkout> _workoutBox = Hive.box('intermediate_workouts');

  List<IntermediateWorkout> getAllWorkouts() {
    return _workoutBox.values.toList();
  }

  void addWorkout(IntermediateWorkout workout) {
    _workoutBox.add(workout);
  }

  void updateWorkout(int index, IntermediateWorkout workout) {
    _workoutBox.putAt(index, workout);
  }

  void deleteWorkout(int index) {
    _workoutBox.deleteAt(index);
  }
}
