
import 'package:flutter/material.dart';
import 'package:ui/core/person_funtion.dart';
import 'package:ui/modules/person_model.dart';
import 'package:ui/screens/homepage.dart';
import 'package:ui/screens/person_three_page.dart';


class PersonDetailsPage2 extends StatefulWidget {
  final Person person;
  const PersonDetailsPage2({super.key, required this.person});

  @override
  State<PersonDetailsPage2> createState() => _PersonDetailsPage2State();
}

class _PersonDetailsPage2State extends State<PersonDetailsPage2> {
  double weight = 60.0;
  double height = 170.0;
  String? physicalCondition = 'Loose Fat';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined,
              size: 20, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeScreen()),
            ),
            child: const Text(
              'Skip',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildSlider(
                title: 'Weight (kg)',
                value: weight,
                min: 30,
                max: 200,
                onChanged: (v) => setState(() => weight = v)),
            _buildSlider(
                title: 'Height (cm)',
                value: height,
                min: 100,
                max: 250,
                onChanged: (v) => setState(() => height = v)),
            const SizedBox(height: 20),
            _buildRadioGroup(),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final Person updatedPerson = Person(
                    imagePath: widget.person.imagePath,
                    name: widget.person.name,
                    dob: widget.person.dob,
                    age: widget.person.age,
                    gender: widget.person.gender,
                    weight: weight,
                    height: height,
                    physicalCondition: physicalCondition!,
                  );
                  await addPerson(updatedPerson);
                  print(
                      'Person added: ${updatedPerson.name}, ${updatedPerson.weight}, ${updatedPerson.height}, ${updatedPerson.physicalCondition}');
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PersonDetailsPage3()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Next', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(
      {required String title,
      required double value,
      required double min,
      required double max,
      required Function(double) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey)),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          label: value.toStringAsFixed(1),
          onChanged: onChanged,
          activeColor: Colors.blue,
          inactiveColor: Colors.grey[300],
        ),
        Text(value.toStringAsFixed(1),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildRadioGroup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Physical Condition',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey)),
        const SizedBox(height: 10),
        _buildRadioTile('Loose Fat'),
        _buildRadioTile('Average'),
        _buildRadioTile('Bulk Muscles'),
      ],
    );
  }

  Widget _buildRadioTile(String value) {
    return RadioListTile<String>(
      title: Text(value,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color:
                  physicalCondition == value ? Colors.blue : Colors.grey[600])),
      value: value,
      groupValue: physicalCondition,
      onChanged: (val) => setState(() => physicalCondition = val),
      activeColor: Colors.blue,
    );
  }
}
