import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui/core/muscle_funtion.dart';
import 'package:ui/modules/musle_model.dart';



class MuscleGainScreen extends StatefulWidget {
  const MuscleGainScreen({super.key});

  @override
  State<MuscleGainScreen> createState() => _MuscleGainScreenState();
}

class _MuscleGainScreenState extends State<MuscleGainScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  // Error variables
  String? _nameError;
  String? _proteinError;
  String? _caloriesError;
  String? _carbsError;
  String? _fatsError;
  String? _imageError;

  // Track image selection and other inputs
  void _showAddFoodDialog(BuildContext context,
      {MuscleModel? entry, int? index}) {
    final nameController = TextEditingController(text: entry?.name ?? '');
    final proteinController =
        TextEditingController(text: entry?.protein.toString() ?? '');
    final caloriesController =
        TextEditingController(text: entry?.calories.toString() ?? '');
    final carbsController =
        TextEditingController(text: entry?.carbs.toString() ?? '');
    final fatsController =
        TextEditingController(text: entry?.fats.toString() ?? '');
    String selectedTime = entry?.time ?? 'Morning';
    String? selectedImagePath = entry?.imagePath;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> pickImage() async {
              final pickedFile =
                  await _imagePicker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                setDialogState(() {
                  selectedImagePath = pickedFile.path;
                  _imageError = null; // Clear previous image error
                });
              }
            }

            return AlertDialog(
              title: Text(entry == null ? "Add Food" : "Edit Food"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selectedImagePath != null)
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(File(selectedImagePath!)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    TextButton(
                        onPressed: pickImage, child: const Text("Add Image")),
                    _buildTextField(
                        nameController,
                        "Food Name",
                        _nameError,
                        (value) => setDialogState(() {
                              _nameError = null; // Clear on edit
                            })),
                    _buildTextField(
                        proteinController, "Protein (g)", _proteinError,
                        (value) {
                      setDialogState(() {
                        _proteinError = null; // Clear on edit
                      });
                    }, isNumber: true),
                    _buildTextField(
                        caloriesController, "Calories (kcal)", _caloriesError,
                        (value) {
                      setDialogState(() {
                        _caloriesError = null; // Clear on edit
                      });
                    }, isNumber: true),
                    _buildTextField(carbsController, "Carbs (g)", _carbsError,
                        (value) {
                      setDialogState(() {
                        _carbsError = null; // Clear on edit
                      });
                    }, isNumber: true),
                    _buildTextField(fatsController, "Fats (g)", _fatsError,
                        (value) {
                      setDialogState(() {
                        _fatsError = null; // Clear on edit
                      });
                    }, isNumber: true),
                    DropdownButtonFormField<String>(
                      value: selectedTime,
                      items: ["Morning", "Afternoon", "Evening", "Night"]
                          .map((time) =>
                              DropdownMenuItem(value: time, child: Text(time)))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedTime = value;
                          });
                        }
                      },
                      decoration: const InputDecoration(labelText: "Food Time"),
                    ),
                    if (_imageError != null)
                      Text(_imageError!,
                          style: const TextStyle(color: Colors.red)),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),
                ElevatedButton(
                  onPressed: () async {
                    // Validation
                    bool hasErrors = false;
                    if (nameController.text.isEmpty) {
                      hasErrors = true;
                      setDialogState(() {
                        _nameError = 'Food name is required';
                      });
                    }
                    if (proteinController.text.isEmpty ||
                        double.tryParse(proteinController.text) == null) {
                      hasErrors = true;
                      setDialogState(() {
                        _proteinError = 'Valid protein value is required';
                      });
                    }
                    if (caloriesController.text.isEmpty ||
                        double.tryParse(caloriesController.text) == null) {
                      hasErrors = true;
                      setDialogState(() {
                        _caloriesError = 'Valid calories value is required';
                      });
                    }
                    if (carbsController.text.isEmpty ||
                        double.tryParse(carbsController.text) == null) {
                      hasErrors = true;
                      setDialogState(() {
                        _carbsError = 'Valid carbs value is required';
                      });
                    }
                    if (fatsController.text.isEmpty ||
                        double.tryParse(fatsController.text) == null) {
                      hasErrors = true;
                      setDialogState(() {
                        _fatsError = 'Valid fats value is required';
                      });
                    }
                    if (selectedImagePath == null) {
                      hasErrors = true;
                      setDialogState(() {
                        _imageError = 'An image must be selected';
                      });
                    }

                    if (hasErrors) return; // Exit if any validation fails

                    final newEntry = MuscleModel(
                      name: nameController.text,
                      time: selectedTime,
                      protein: double.tryParse(proteinController.text) ?? 0,
                      calories: double.tryParse(caloriesController.text) ?? 0,
                      carbs: double.tryParse(carbsController.text) ?? 0,
                      fats: double.tryParse(fatsController.text) ?? 0,
                      imagePath: selectedImagePath,
                      isCompleted: entry?.isCompleted ?? false,
                    );

                    if (index != null) {
                      await MuscleDatabase.updateFood(index, newEntry);
                    } else {
                      await MuscleDatabase.addFood(newEntry);
                    }

                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Text(entry == null ? "Save" : "Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      String? errorText, Function(String) onChanged,
      {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : Colors.grey,
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        const SizedBox(height: 12), // Spacing between fields
      ],
    );
  }

  void _deleteEntry(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Entry"),
          content: const Text("Are you sure you want to delete this entry?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            TextButton(
              onPressed: () async {
                await MuscleDatabase.deleteFood(index);
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _toggleCompletion(int index, MuscleModel entry) async {
    final updatedEntry = MuscleModel(
      name: entry.name,
      time: entry.time,
      protein: entry.protein,
      calories: entry.calories,
      carbs: entry.carbs,
      fats: entry.fats,
      imagePath: entry.imagePath,
      isCompleted: !entry.isCompleted,
    );

    await MuscleDatabase.updateFood(index, updatedEntry);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<MuscleModel> foodEntries = MuscleDatabase.getFoods();

    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'WEIGHT LOSS PLAN',
        style: TextStyle(
            color: Colors.blueGrey, fontSize: 19, fontWeight: FontWeight.bold),
      )),
      body: ListView.builder(
        itemCount: foodEntries.length,
        itemBuilder: (context, index) {
          final entry = foodEntries[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (entry.imagePath != null)
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(File(entry.imagePath!)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: entry.isCompleted,
                            onChanged: (value) =>
                                _toggleCompletion(index, entry),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showAddFoodDialog(context,
                                entry: entry, index: index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteEntry(index),
                          ),
                        ],
                      ),
                      Text(
                        entry.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: entry.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color:
                              entry.isCompleted ? Colors.green : Colors.black,
                        ),
                      ),
                      Text(
                        "Time: ${entry.time}\nProtein: ${entry.protein}g\nCalories: ${entry.calories}kcal\nCarbs: ${entry.carbs}g\nFats: ${entry.fats}g",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddFoodDialog(context),
          child: const Icon(Icons.add)),
    );
  }
}