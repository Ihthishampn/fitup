import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
// ignore: unused_import
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/modules/beginner_model.dart';
import 'package:ui/modules/fitness_plan_model.dart';
import 'package:ui/modules/intermediate_model.dart';
import 'package:ui/modules/advanced_model.dart';
import 'package:ui/modules/musle_model.dart';
import 'package:ui/modules/person_model.dart' as ui_person;
import 'package:ui/modules/reminder_model.dart';
import 'package:ui/modules/run_model.dart';
import 'package:ui/screens/splash.dart';
import 'package:ui/modules/weight_model.dart';
import 'modules/data_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'service/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(WorkoutModelAdapter());
  Hive.registerAdapter(FitnessPlanAdapter());
  Hive.registerAdapter(IntermediateWorkoutAdapter());
  Hive.registerAdapter(AdvanceWorkoutAdapter());
  Hive.registerAdapter(WeightModelAdapter());
  Hive.registerAdapter(MuscleModelAdapter());
  Hive.registerAdapter(ui_person.PersonAdapter());
  Hive.registerAdapter(RunRecordAdapter());
  Hive.registerAdapter(CompletedDayAdapter());
  Hive.registerAdapter(ReminderAdapter());
  //  box opeining
  await Hive.openBox<UserModel>('userBox');
  await Hive.openBox<WorkoutModel>('workoutBox');
  await Hive.openBox<FitnessPlan>('fitnessBox');
  await Hive.openBox<IntermediateWorkout>('intermediate_workouts');
  await Hive.openBox<AdvanceWorkout>('advanced_workout');
  await Hive.openBox<WeightModel>('weightBox');
  await Hive.openBox<MuscleModel>('muscle_food');
  await Hive.openBox<ui_person.Person>('persons');
  await Hive.openBox<CompletedDay>('completedDaysBox');
  await Hive.openBox<Reminder>('remindersss');
  NotificationService notificationService = NotificationService();
  await notificationService.initNotification();
  await _requestNotificationPermission();
  runApp(const MyApp());
}

Future<void> _requestNotificationPermission() async {
  final status = await Permission.notification.request();
  if (status.isGranted) {
    print('Notification permission granted');
  } else {
    print('Notification permission denied');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
