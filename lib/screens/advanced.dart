import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui/core/advance_funtion.dart';
import 'package:ui/modules/advanced_model.dart';
import 'package:ui/custom_widgets/validator.dart';

class AdvancedWorkoutPage extends StatefulWidget {
  const AdvancedWorkoutPage({super.key});

  @override
  _AdvancedWorkoutPageState createState() => _AdvancedWorkoutPageState();
}

class _AdvancedWorkoutPageState extends State<AdvancedWorkoutPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  XFile? _selectedFile;
  int? editingIndex;

  int _selectedHours = 0;
  int _selectedMinutes = 0;

  int _selectedCount = 1;

  final AdvanceWorkoutFunction _workoutFunctions = AdvanceWorkoutFunction();
  List<AdvanceWorkout> workouts = [];

  String? _nameError;
  String? _goalError;
  String? _imageError;

  bool _nameFieldTouched = false;
  bool _goalFieldTouched = false;
  bool _imageFieldTouched = false;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    setState(() {
      workouts = _workoutFunctions.getAllWorkouts();
    });
  }

  Future<void> _pickMedia(Function setDialogState) async {
    final picker = ImagePicker();
    try {
      final XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setDialogState(() {
          _selectedFile = file;
          _imageError = null;
          _imageFieldTouched = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  void _showAddWorkoutDialog({int? index}) {
    if (index != null) {
      final workout = workouts[index];
      _nameController.text = workout.name;

      var durationParts = workout.duration.split(':');
      _selectedHours =
          durationParts.isNotEmpty ? int.parse(durationParts[0]) : 0;
      _selectedMinutes =
          durationParts.length > 1 ? int.parse(durationParts[1]) : 0;

      _goalController.text = workout.goal;
      _selectedCount = int.tryParse(workout.count) ?? 1;
      _selectedFile = workout.image.isNotEmpty ? XFile(workout.image) : null;
      editingIndex = index;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Text(index == null ? "ADD WORKOUT" : "EDIT WORKOUT"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _pickMedia(setDialogState),
                      child: Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                          border: _imageError != null && _imageFieldTouched
                              ? Border.all(color: Colors.red, width: 2)
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: _selectedFile == null
                            ? const Text("Pick Image",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(File(_selectedFile!.path),
                                    height: 250,
                                    width: double.infinity,
                                    fit: BoxFit.cover),
                              ),
                      ),
                    ),
                    if (_imageError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 15),
                        child: Text(
                          _imageError!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 15),
                    _buildTextField(_nameController, "Workout Name", _nameError,
                        onChanged: () {
                      setState(() {
                        _nameFieldTouched = true;
                      });
                    }),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: DropdownButton<int>(
                            value: _selectedHours,
                            isExpanded: true,
                            items: List.generate(24, (index) => index)
                                .map((hour) => DropdownMenuItem(
                                      value: hour,
                                      child: Text('$hour hours'),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setDialogState(() {
                                  _selectedHours = value;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButton<int>(
                            value: _selectedMinutes,
                            isExpanded: true,
                            items: List.generate(60, (index) => index)
                                .map((minute) => DropdownMenuItem(
                                      value: minute,
                                      child: Text('$minute minutes'),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setDialogState(() {
                                  _selectedMinutes = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(_goalController, "Goal", _goalError,
                        onChanged: () {
                      setState(() {
                        _goalFieldTouched = true;
                      });
                    }),
                    const SizedBox(height: 10),
                    const Text("Count",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    DropdownButton<int>(
                      value: _selectedCount,
                      items: List.generate(100, (index) => index + 1)
                          .map((count) => DropdownMenuItem(
                                value: count,
                                child: Text('$count'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            _selectedCount = value;
                          });
                        }
                      },
                      isExpanded: true,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _clearInputs();
                    Navigator.pop(context);
                  },
                  child:
                      const Text("Cancel", style: TextStyle(color: Colors.red)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setDialogState(() {
                      _nameError = null;
                      _goalError = null;
                      _imageError = null;
                    });

                    bool hasErrors = false;

                    if (Validators.validateRequired(_nameController.text) !=
                        null) {
                      hasErrors = true;
                      setDialogState(() {
                        _nameError = 'Workout name is required';
                      });
                    }
                    if (Validators.validateRequired(_goalController.text) !=
                        null) {
                      hasErrors = true;
                      setDialogState(() {
                        _goalError = 'Goal is required';
                      });
                    }
                    if (_selectedFile == null) {
                      hasErrors = true;
                      setDialogState(() {
                        _imageError = 'An image must be selected';
                      });
                    }

                    if (_selectedHours == 0 && _selectedMinutes == 0) {
                      hasErrors = true;
                      setDialogState(() {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Duration must be greater than 0'),
                          ),
                        );
                      });
                    }

                    if (hasErrors) return;

                    final workout = AdvanceWorkout(
                      name: _nameController.text,
                      duration:
                          "$_selectedHours:${_selectedMinutes.toString().padLeft(2, '0')}",
                      goal: _goalController.text,
                      count: _selectedCount.toString(),
                      image: _selectedFile?.path ?? "",
                      completed: editingIndex != null
                          ? workouts[editingIndex!].completed
                          : false,
                    );

                    if (editingIndex != null) {
                      _workoutFunctions.updateWorkout(editingIndex!, workout);
                    } else {
                      _workoutFunctions.addWorkout(workout);
                    }

                    _clearInputs();
                    _loadWorkouts();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent),
                  child: Text(index == null ? "Save" : "Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String? error,
      {void Function()? onChanged}) {
    bool hasError = error != null;
    bool isTouched = (label == "Workout Name"
        ? _nameFieldTouched
        : label == "Goal"
            ? _goalFieldTouched
            : false);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: hasError ? Colors.red : Colors.grey,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            onChanged: (value) {
              if (onChanged != null) {
                onChanged();
              }
            },
            decoration: InputDecoration(
              labelText: label,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            ),
          ),
          if (hasError && isTouched)
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 4),
              child: Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  void _clearInputs() {
    _nameController.clear();
    _goalController.clear();
    _selectedHours = 0;
    _selectedMinutes = 0;
    _selectedFile = null;
    editingIndex = null;

    _nameFieldTouched = false;
    _goalFieldTouched = false;
    _imageFieldTouched = false;

    _nameError = null;
    _goalError = null;
    _imageError = null;
  }

  Future<void> _confirmDeleteWorkout(int index) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this workout?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("No", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _deleteWorkout(index);
    }
  }

  Future<void> _deleteWorkout(int index) async {
    _workoutFunctions.deleteWorkout(index);
    _loadWorkouts();
  }

  Future<void> _toggleWorkoutCompletion(int index) async {
    final workout = workouts[index];
    workout.completed = !workout.completed;
    _workoutFunctions.updateWorkout(index, workout);
    _loadWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('ADVANCED WORKOUT',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 241, 242, 243),
                fontSize: 19)),
        backgroundColor: Colors.blueAccent,
      ),
      body: workouts.isEmpty
          ? const Center(child: Text("No Workouts Added"))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: workout.completed
                          ? Colors.green[100]
                          : Colors.grey[200]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (workout.image.isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10)),
                          child: Image.file(
                            File(workout.image),
                            fit: BoxFit.fill,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(workout.name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text("Time: ${workout.duration}",
                                style: const TextStyle(fontSize: 16)),
                            Text("Goal: ${workout.goal}",
                                style: const TextStyle(fontSize: 16)),
                            Text("Count: ${workout.count}",
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        _toggleWorkoutCompletion(index),
                                    icon: Icon(
                                      workout.completed
                                          ? Icons.check_circle
                                          : Icons.check_circle_outline,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      workout.completed
                                          ? "Completed"
                                          : "Mark as Completed",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: workout.completed
                                            ? Colors.green
                                            : Colors.grey),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        _showAddWorkoutDialog(index: index),
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                    ),
                                    label: const Text(
                                      "Edit",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 179, 200, 235)),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        _confirmDeleteWorkout(index),
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    label: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 245, 190, 187),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddWorkoutDialog(),
        label: const Text('Add '),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
