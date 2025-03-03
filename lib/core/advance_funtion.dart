import 'package:hive/hive.dart';
import 'package:ui/modules/advanced_model.dart';

class AdvanceWorkoutFunction {
  final Box<AdvanceWorkout> _workoutBox = Hive.box('advanced_workout');

  List<AdvanceWorkout> getAllWorkouts() {
    return _workoutBox.values.toList();
  }

  void addWorkout(AdvanceWorkout workout) {
    _workoutBox.add(workout);
  }

  void updateWorkout(int index, AdvanceWorkout workout) {
    if (index >= 0 && index < _workoutBox.length) {
      _workoutBox.putAt(index, workout);
    }
  }

  void deleteWorkout(int index) {
    if (index >= 0 && index < _workoutBox.length) {
      _workoutBox.deleteAt(index);
    }
  }
}
