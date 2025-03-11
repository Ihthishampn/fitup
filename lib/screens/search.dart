import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ui/core/advance_funtion.dart';
import '../core/beginner_funtion.dart';
import '../modules/beginner_model.dart';
import '../core/intermediate_function.dart';
import '../modules/intermediate_model.dart';
import 'beginner.dart';
import 'intermediate.dart';
import '../modules/advanced_model.dart';
import 'advanced.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<WorkoutModel> beginnerWorkouts = [];
  List<IntermediateWorkout> intermediateWorkouts = [];
  List<AdvanceWorkout> advancedWorkouts = [];
  List<Map<String, dynamic>> filteredWorkouts = [];
  String searchQuery = '';
  Map<String, bool> filters = {
    'Beginner': true,
    'Intermediate': true,
    'Advanced': true,
  };

  final WorkoutFunctions _beginnerWorkoutFunctions = WorkoutFunctions();
  final IntermediateWorkoutFunction _intermediateWorkoutFunctions =
      IntermediateWorkoutFunction();
  final AdvanceWorkoutFunction _advancedWorkoutFunctions =
      AdvanceWorkoutFunction();

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    setState(() {
      beginnerWorkouts = _beginnerWorkoutFunctions.getAllWorkouts();
      intermediateWorkouts = _intermediateWorkoutFunctions.getAllWorkouts();
      advancedWorkouts = _advancedWorkoutFunctions.getAllWorkouts();
      _filterWorkouts();
    });
  }

  void _filterWorkouts() {
    setState(() {
      filteredWorkouts = [];

      if (filters['Beginner']! && beginnerWorkouts.isNotEmpty) {
        filteredWorkouts.add({
          'type': 'Beginner Workouts',
          'workouts': searchQuery.isEmpty
              ? beginnerWorkouts
              : beginnerWorkouts
                  .where((workout) => workout.name
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()))
                  .toList(),
        });
      }

      if (filters['Intermediate']! && intermediateWorkouts.isNotEmpty) {
        filteredWorkouts.add({
          'type': 'Intermediate Workouts',
          'workouts': searchQuery.isEmpty
              ? intermediateWorkouts
              : intermediateWorkouts
                  .where((workout) => workout.name
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()))
                  .toList(),
        });
      }

      if (filters['Advanced']! && advancedWorkouts.isNotEmpty) {
        filteredWorkouts.add({
          'type': 'Advanced Workouts',
          'workouts': searchQuery.isEmpty
              ? advancedWorkouts
              : advancedWorkouts
                  .where((workout) => workout.name
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()))
                  .toList(),
        });
      }

      filteredWorkouts.removeWhere((section) => section['workouts'].isEmpty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Search for workouts...',
                  hintText: 'Enter workout type or name',
                  prefixIcon: const Icon(Icons.search, color: Colors.blueGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                    _filterWorkouts();
                  });
                },
              ),
              const SizedBox(height: 20),
              // Horizontally scrollable filter 
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filters.keys.map((String key) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: FilterChip(
                        label: Text(key),
                        selected: filters[key]!,
                        onSelected: (bool selected) {
                          setState(() {
                            filters[key] = selected;
                            _filterWorkouts();
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: filteredWorkouts.isEmpty
                    ? Center(
                        child: Text(
                          searchQuery.isEmpty
                              ? "No workouts available."
                              : "No results found for '$searchQuery'.",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredWorkouts.length,
                        itemBuilder: (context, index) {
                          final section = filteredWorkouts[index];
                          final String title = section['type'];
                          final List<dynamic> workouts = section['workouts'];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16.0,
                                ),
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ),
                              ...workouts.map((workout) {
                                return GestureDetector(
                                  onTap: () {
                                    if (workout is WorkoutModel) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BeginnerWorkoutPage(
                                            selectedIndex: beginnerWorkouts
                                                .indexOf(workout),
                                          ),
                                        ),
                                      );
                                    } else if (workout is IntermediateWorkout) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const IntermediateWorkoutPage(),
                                        ),
                                      );
                                    } else if (workout is AdvanceWorkout) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AdvancedWorkoutPage(),
                                        ),
                                      );
                                    }
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    color: Colors.blueGrey[50],
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(12),
                                      leading: workout.image.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.file(
                                                File(workout.image),
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.fitness_center,
                                              size: 40,
                                              color: Colors.blueGrey,
                                            ),
                                      title: Text(
                                        workout.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 8),
                                          Text(
                                            "Duration: ${workout.duration} min",
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            "Goal: ${workout.goal}",
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            "Count: ${workout.count}",
                                            style: const TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Icon(
                                        workout.completed
                                            ? Icons.check_circle
                                            : Icons.check_circle_outline,
                                        color: workout.completed
                                            ? Colors.green
                                            : Colors.blueGrey,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
