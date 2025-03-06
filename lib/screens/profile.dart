import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui/service/notification_service.dart';
import 'package:ui/core/reminder_funtion.dart';
import '../modules/person_model.dart';
import '../modules/reminder_model.dart';

const String boxName = 'persons';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ValueNotifier<Person?> personNotifier = ValueNotifier(null);
  final List<Reminder> _reminders = [];
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _loadReminders();
  }

  void _loadProfileData() {
    var box = Hive.box<Person>(boxName);
    if (box.isNotEmpty) {
      personNotifier.value = box.get('person');
    }
  }

  void _loadReminders() {
    setState(() {
      _reminders.clear();
      _reminders.addAll(ReminderFunction.getReminders());
    });
  }

  Future<void> _editProfile() async {
    final TextEditingController nameController =
        TextEditingController(text: personNotifier.value?.name ?? '');
    final TextEditingController ageController = TextEditingController(
        text: personNotifier.value?.age?.toString() ?? '');
    final TextEditingController heightController = TextEditingController(
        text: personNotifier.value?.height?.toString() ?? '');
    final TextEditingController weightController = TextEditingController(
        text: personNotifier.value?.weight?.toString() ?? '');
    final TextEditingController goalController = TextEditingController(
        text: personNotifier.value?.physicalCondition ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Edit Profile'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        File? newImage = await _pickImage();
                        if (newImage != null) {
                          personNotifier.value?.imagePath = newImage.path;
                          setState(() {});
                        }
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: (personNotifier.value?.imagePath !=
                                    null &&
                                personNotifier.value!.imagePath!.isNotEmpty)
                            ? FileImage(File(personNotifier.value!.imagePath!))
                            : const AssetImage('images/logogym.png')
                                as ImageProvider,
                      ),
                    ),
                    const Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.image, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name')),
                TextField(
                    controller: ageController,
                    decoration: const InputDecoration(labelText: 'Age')),
                TextField(
                    controller: heightController,
                    decoration:
                        const InputDecoration(labelText: 'Height (cm)')),
                TextField(
                    controller: weightController,
                    decoration:
                        const InputDecoration(labelText: 'Weight (kg)')),
                TextField(
                    controller: goalController,
                    decoration:
                        const InputDecoration(labelText: 'Fitness Goal')),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  var updatedPerson = Person(
                    name: nameController.text,
                    age: ageController.text,
                    height: double.tryParse(heightController.text),
                    weight: double.tryParse(weightController.text),
                    gender: personNotifier.value?.gender ?? 'Unknown',
                    physicalCondition: goalController.text,
                    imagePath: personNotifier.value?.imagePath ?? '',
                  );
                  var box = Hive.box<Person>(boxName);
                  await box.put('person', updatedPerson);
                  setState(() {
                    personNotifier.value = updatedPerson;
                  });
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<File?> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<void> _addReminder() async {
    final TextEditingController contentController = TextEditingController();
    final TextEditingController timeController = TextEditingController();
    final ValueNotifier<bool> contentError = ValueNotifier(false);
    final ValueNotifier<bool> timeError = ValueNotifier(false);

    final BuildContext parentContext = context;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: contentError,
                builder: (context, isError, child) {
                  return TextField(
                    controller: contentController,
                    decoration: InputDecoration(
                      labelText: 'Reminder Content',
                      errorText: isError ? 'Content cannot be empty' : null,
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder<bool>(
                valueListenable: timeError,
                builder: (context, isError, child) {
                  return TextField(
                    controller: timeController,
                    decoration: InputDecoration(
                      labelText: 'Time (HH:mm)',
                      errorText: isError ? 'Time cannot be empty' : null,
                      suffixIcon:
                          const Icon(Icons.access_time, color: Colors.blue),
                    ),
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (selectedTime != null) {
                        // ignore: use_build_context_synchronously
                        timeController.text = selectedTime.format(context);
                        timeError.value = false;
                      }
                    },
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (contentController.text.trim().isEmpty) {
                  contentError.value = true;
                } else {
                  contentError.value = false;
                }

                if (timeController.text.trim().isEmpty) {
                  timeError.value = true;
                } else {
                  timeError.value = false;
                }

                if (!contentError.value && !timeError.value) {
                  String timeText = timeController.text;
                  List<String> timeParts = timeText.split(' ')[0].split(':');
                  int hour = int.parse(timeParts[0]);
                  int minute = int.parse(timeParts[1]);

                  if (timeText.endsWith('PM') && hour < 12) {
                    hour += 12;
                  } else if (timeText.endsWith('AM') && hour == 12) {
                    hour = 0;
                  }

                  final now = DateTime.now();
                  DateTime scheduledDateTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    hour,
                    minute,
                  );

                  if (scheduledDateTime.isBefore(now)) {
                    scheduledDateTime =
                        scheduledDateTime.add(const Duration(days: 1));
                  }

                  Reminder newReminder = Reminder(
                    content: contentController.text,
                    time: timeController.text,
                  );

                  await ReminderFunction.addReminder(newReminder);

                  NotificationService notificationService =
                      NotificationService();
                  await notificationService.scheduleNotification(
                    title: 'Reminder',
                    body: newReminder.content,
                    scheduledTime: scheduledDateTime,
                  );

                  _loadReminders();

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      const SnackBar(
                        content: Text('Reminder added successfully!'),
                        duration: Duration(seconds: 3),
                        backgroundColor: Colors.blueGrey,
                      ),
                    );
                  });

                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteReminder(int index) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Reminder'),
          content: const Text('Are you sure you want to delete this reminder?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _reminders.removeAt(index);
                });
                ReminderFunction.deleteReminder(index); // Remove from Hive
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('MY PROFILE',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_document, color: Colors.black),
            onPressed: _editProfile,
          ),
        ],
      ),
      body: ValueListenableBuilder<Person?>(
        valueListenable: personNotifier,
        builder: (context, person, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                _buildProfileCard(person),
                const SizedBox(height: 20),
                _buildRemindersCard(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(Person? person) {
    return Card(
      // color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              child: ClipOval(
                child:
                    (person?.imagePath != null && person!.imagePath!.isNotEmpty)
                        ? Image.file(
                            File(person.imagePath!),
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'images/logogym.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
              ),
            ),
            const SizedBox(height: 20),
            _profileDetail('Name', person?.name ?? 'Not Set'),
            _profileDetail('Age', person?.age?.toString() ?? 'Not Set'),
            _profileDetail(
                'Height', '${person?.height?.toString() ?? 'Not Set'} cm'),
            _profileDetail(
                'Weight', '${person?.weight?.toString() ?? 'Not Set'} kg'),
            _profileDetail('Gender', person?.gender ?? 'Not Set'),
            _profileDetail(
                'Fitness Goal', person?.physicalCondition ?? 'Not Set'),
          ],
        ),
      ),
    );
  }

  Widget _profileDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildRemindersCard() {
    return Card(
      color: const Color.fromARGB(255, 112, 114, 116),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'REMINDERS',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.black),
                  onPressed: _addReminder,
                  tooltip: 'Add Reminder',
                ),
              ],
            ),
            const SizedBox(height: 15),
            _reminders.isEmpty
                ? const Text(
                    'No reminders yet',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _reminders.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            _reminders[index].content,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            _reminders[index].time,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.redAccent),
                            onPressed: () => _deleteReminder(index),
                            tooltip: 'Delete Reminder',
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
