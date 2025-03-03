import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui/core/muscle_funtion.dart';
import 'package:ui/modules/musle_model.dart';
import 'package:ui/core/weight_funtion.dart';
import 'package:ui/modules/weight_model.dart';

import '../core/fitness_funtion.dart';
import '../modules/fitness_plan_model.dart';

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: const Text(
          'DIET PLANS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDietOption(context, 'WEIGHT LOSS', 'images/diet111.png',
                    const MuscleGainScreen()),
                const SizedBox(height: 20),
                _buildDietOption(context, 'WEIGHT GAIN', 'images/diet222.png',
                    const WeightLossScreen()),
                const SizedBox(height: 20),
                _buildDietOption(context, 'SET ACTIVITY', 'images/diet3333.png',
                    const FitnessActivitySelectorScreen()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDietOption(
      BuildContext context, String title, String imagePath, Widget screen) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      elevation: 0,
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imagePath,
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, size: 100, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => screen),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text(
                  'View Plan',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// muscle gain.......................

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

// muscle gain.....................................

// weight ..........................................

class WeightLossScreen extends StatefulWidget {
  const WeightLossScreen({super.key});

  @override
  _WeightLossScreenState createState() => _WeightLossScreenState();
}

class _WeightLossScreenState extends State<WeightLossScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  List<WeightModel> _foodEntries = [];

  // Error messages
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
                        _nameError = null; // Clear on edit
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

                    if (hasErrors) return; // Exit if any validation fails

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
        const SizedBox(height: 12), // Spacing between fields
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
      backgroundColor: Colors.white,
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
              color: Colors.blueGrey),
        ),
        backgroundColor: Colors.white,
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
// weight.............................................

// fitness activity.........................

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
                  borderRadius:
                      BorderRadius.circular(10), 
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
                      leading: Icon(
                        Icons.fitness_center_rounded,
                        color: Color.fromARGB(255, 95, 89, 89),
                        size: 30,
                      ),
                      title: Text(
                        plan.activity,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white, 
                        ),
                      ),
                      subtitle: Text(
                        "Duration: ${plan.duration} min | Distance: ${plan.distance} km",
                        style: TextStyle(
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
                            icon: const Icon(Icons.delete, color: Colors.red),
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
