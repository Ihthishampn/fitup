import 'package:flutter/material.dart';
import 'package:ui/core/fitness_funtion.dart';
import 'package:ui/modules/fitness_plan_model.dart';

class FitnessActivitySelectorScreen extends StatefulWidget {
  const FitnessActivitySelectorScreen({super.key});

  @override
  _FitnessActivitySelectorScreenState createState() =>
      _FitnessActivitySelectorScreenState();
}

class _FitnessActivitySelectorScreenState
    extends State<FitnessActivitySelectorScreen> {
  String selectedActivity = 'Running';
  String selectedDuration = '1';
  String selectedDistance = '1';

  List<String> activities = [
    'Running',
    'Swimming',
    'Cycling',
    'Yoga',
    'Weightlifting'
  ];
  List<String> durations =
      List.generate(100, (index) => (index + 1).toString());
  List<String> distances =
      List.generate(100, (index) => (index + 1).toString());

  List<FitnessPlan> fitnessPlans = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final activities = await FitnessDatabase.getActivities();
    setState(() {
      fitnessPlans = activities;
    });
  }

  Future<void> _saveActivityDetails() async {
    final newPlan = FitnessPlan(
      activity: selectedActivity,
      duration: selectedDuration,
      distance: selectedDistance,
    );

    await FitnessDatabase.addActivity(newPlan);
    _loadActivities();
    _showSnackbar("Activity saved successfully!");
  }

  Future<void> _deleteActivity(int index) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this activity?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await FitnessDatabase.deleteActivity(index);
      _loadActivities();
      _showSnackbar("Activity deleted successfully!");
    }
  }

  void _editActivity(FitnessPlan plan, int index) {
    String tempActivity = plan.activity;
    String tempDuration = plan.duration;
    String tempDistance = plan.distance;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Edit Activity"),
              content: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDropdown("Activity", tempActivity, activities,
                        (value) {
                      setDialogState(() {
                        tempActivity = value!;
                        _showSnackbar("Activity changed to: $value");
                      });
                    }),
                    _buildDropdown(
                        "Duration (minutes)", tempDuration, durations, (value) {
                      setDialogState(() {
                        tempDuration = value!;
                        _showSnackbar("Duration changed to: $value minutes");
                      });
                    }),
                    _buildDropdown("Distance (km)", tempDistance, distances,
                        (value) {
                      setDialogState(() {
                        tempDistance = value!;
                        _showSnackbar("Distance changed to: $value km");
                      });
                    }),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    final updatedPlan = FitnessPlan(
                      activity: tempActivity,
                      duration: tempDuration,
                      distance: tempDistance,
                    );
                    await FitnessDatabase.updateActivity(index, updatedPlan);
                    _loadActivities();
                    _showSnackbar("Activity updated successfully!");
                    Navigator.of(context).pop();
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'FITNESS ACTIVITY',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
              color: Colors.blueGrey),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown("Select Activity", selectedActivity, activities,
                (value) {
              setState(() => selectedActivity = value!);
            }),
            _buildDropdown("Duration (minutes)", selectedDuration, durations,
                (value) {
              setState(() => selectedDuration = value!);
            }),
            _buildDropdown("Distance (km)", selectedDistance, distances,
                (value) {
              setState(() => selectedDistance = value!);
            }),
            const SizedBox(height: 20),
            Center(
                child: ElevatedButton(
              onPressed: _saveActivityDetails,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                backgroundColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Save Activity",
                style: TextStyle(color: Colors.white),
              ),
            )),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: fitnessPlans.length,
                itemBuilder: (context, index) {
                  final plan = fitnessPlans[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    color: Colors.blueGrey,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: const Icon(
                        Icons.fitness_center_rounded,
                        color: Color.fromARGB(255, 95, 89, 89),
                        size: 30,
                      ),
                      title: Text(
                        plan.activity,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        "Duration: ${plan.duration} min | Distance: ${plan.distance} km",
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.green),
                            onPressed: () => _editActivity(plan, index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Color.fromARGB(255, 209, 97, 97)),
                            onPressed: () => _deleteActivity(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String selectedValue, List<String> items,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          value: selectedValue,
          onChanged: onChanged,
          items: items.map((value) {
            return DropdownMenuItem(value: value, child: Text(value));
          }).toList(),
          isExpanded: true,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
