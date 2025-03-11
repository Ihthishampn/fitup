import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui/core/weight_funtion.dart';
import 'package:ui/modules/weight_model.dart';

class WeightLossScreen extends StatefulWidget {
  const WeightLossScreen({super.key});

  @override
  _WeightLossScreenState createState() => _WeightLossScreenState();
}

class _WeightLossScreenState extends State<WeightLossScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  List<WeightModel> _foodEntries = [];

  String? _nameError;
  String? _proteinError;
  String? _caloriesError;
  String? _carbsError;
  String? _fatsError;
  String? _imageError;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() {
    setState(() {
      _foodEntries = WeightDatabase.getEntries();
    });
  }

  void _showAddFoodDialog(BuildContext context,
      {WeightModel? entry, int? index}) {
    final TextEditingController foodNameController =
        TextEditingController(text: entry?.name);
    final TextEditingController proteinController =
        TextEditingController(text: entry?.protein.toString());
    final TextEditingController caloriesController =
        TextEditingController(text: entry?.calories.toString());
    final TextEditingController carbsController =
        TextEditingController(text: entry?.carbs.toString());
    final TextEditingController fatsController =
        TextEditingController(text: entry?.fats.toString());
    String selectedTime = entry?.time ?? 'Morning';
    File? selectedImage =
        entry?.imagePath != null ? File(entry!.imagePath!) : null;

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
                  selectedImage = File(pickedFile.path);
                  _imageError = null;
                });
              }
            }

            return AlertDialog(
              title: Text(entry == null ? "Add Food" : "Edit Food"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selectedImage != null)
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(selectedImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    TextButton(
                      onPressed: pickImage,
                      child: const Text("Add Image"),
                    ),
                    _buildTextField(foodNameController, "Food Name", _nameError,
                        (value) {
                      setDialogState(() {
                        _nameError = null;
                      });
                    }),
                    DropdownButtonFormField<String>(
                      value: selectedTime,
                      items: ["Morning", "Afternoon", "Evening", "Night"]
                          .map((time) => DropdownMenuItem(
                                value: time,
                                child: Text(time),
                              ))
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
                    _buildTextField(
                        proteinController, "Protein (g)", _proteinError,
                        (value) {
                      setDialogState(() {
                        _proteinError = null;
                      });
                    }, isNumber: true),
                    _buildTextField(
                        caloriesController, "Calories (kcal)", _caloriesError,
                        (value) {
                      setDialogState(() {
                        _caloriesError = null;
                      });
                    }, isNumber: true),
                    _buildTextField(carbsController, "Carbs (g)", _carbsError,
                        (value) {
                      setDialogState(() {
                        _carbsError = null;
                      });
                    }, isNumber: true),
                    _buildTextField(fatsController, "Fats (g)", _fatsError,
                        (value) {
                      setDialogState(() {
                        _fatsError = null;
                      });
                    }, isNumber: true),
                    if (_imageError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(_imageError!,
                            style: const TextStyle(color: Colors.red)),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Validation
                    bool hasErrors = false;
                    if (foodNameController.text.isEmpty) {
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
                    if (selectedImage == null) {
                      hasErrors = true;
                      setDialogState(() {
                        _imageError = 'An image must be selected';
                      });
                    }

                    if (hasErrors) return;

                    final newEntry = WeightModel(
                      name: foodNameController.text,
                      time: selectedTime,
                      protein: double.tryParse(proteinController.text) ?? 0.0,
                      calories: double.tryParse(caloriesController.text) ?? 0.0,
                      carbs: double.tryParse(carbsController.text) ?? 0.0,
                      fats: double.tryParse(fatsController.text) ?? 0.0,
                      imagePath: selectedImage?.path,
                      isCompleted: entry?.isCompleted ?? false,
                    );

                    if (index != null) {
                      await WeightDatabase.updateEntry(index, newEntry);
                    } else {
                      await WeightDatabase.addEntry(newEntry);
                    }

                    _loadEntries();
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
        const SizedBox(height: 12),
      ],
    );
  }

  void _deleteEntry(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this entry?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await WeightDatabase.deleteEntry(index);
              _loadEntries();
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _toggleComplete(int index) async {
    await WeightDatabase.toggleComplete(index);
    _loadEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
        ),
        title: const Text(
          'WEIGHT GAIN PLAN',
          style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 223, 225, 226)),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: _foodEntries.length,
        itemBuilder: (context, index) {
          final entry = _foodEntries[index];
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
                            onChanged: (value) => _toggleComplete(index),
                          ),
                          Expanded(
                            child: Text(
                              entry.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                decoration: entry.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _showAddFoodDialog(context,
                                entry: entry, index: index),
                            icon: const Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () => _deleteEntry(index),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
