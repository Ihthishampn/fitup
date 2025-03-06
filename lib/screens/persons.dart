import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui/screens/homepage.dart';
import 'package:ui/core/person_funtion.dart';
import 'package:ui/modules/person_model.dart';
import 'package:ui/custom_widgets/validator.dart';
import 'secon_page_person.dart';

class PersonDetailsPage1 extends StatefulWidget {
  const PersonDetailsPage1({super.key});

  @override
  State<PersonDetailsPage1> createState() => _PersonDetailsPage1State();
}

class _PersonDetailsPage1State extends State<PersonDetailsPage1> {
  File? _image;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  int? _age;
  String? _selectedGender;
  bool _validate = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  void _calculateAge(String dob) {
    DateTime birthDate = DateFormat('dd/MM/yyyy').parse(dob);
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    setState(() => _age = age);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeScreen())),
              child: const Text('Skip',
                  style: TextStyle(color: Colors.blue, fontSize: 16)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? const Icon(Icons.add_a_photo,
                            size: 30, color: Colors.black)
                        : null,
                  ),
                ),
                if (_validate && Validators.validateImage(_image?.path) != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      Validators.validateImage(_image?.path)!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 30),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.person, color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText: _validate
                        ? Validators.validateString(_nameController.text)
                        : null,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _dobController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon:
                        const Icon(Icons.calendar_today, color: Colors.red),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText: _validate
                        ? Validators.validateRequired(_dobController.text)
                        : null,
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      _dobController.text =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
                      _calculateAge(_dobController.text);
                    }
                  },
                ),
                if (_age != null) ...[
                  const SizedBox(height: 10),
                  Text('Age: $_age years',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ],
                const SizedBox(height: 30),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon:
                        const Icon(Icons.people, color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  onChanged: (value) => setState(() => _selectedGender = value),
                ),
                if (_validate &&
                    Validators.validateGender(_selectedGender) != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      Validators.validateGender(_selectedGender)!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _validate = true);
                    if (Validators.validateString(_nameController.text) ==
                            null &&
                        Validators.validateRequired(_dobController.text) ==
                            null &&
                        Validators.validateImage(_image?.path) == null &&
                        Validators.validateGender(_selectedGender) == null &&
                        _age != null) {
                      final Person person = Person(
                        imagePath: _image?.path,
                        name: _nameController.text,
                        dob: _dobController.text,
                        age: _age.toString(),
                        gender: _selectedGender!,
                      );
                      addPerson(person);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PersonDetailsPage2(person: person)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 25),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 6,
                    shadowColor: Colors.black45,
                  ),
                  child: const Text('Continue',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Second Page - Personal Details Part 2 (Next 3 fields)
// class PersonDetailsPage2 extends StatefulWidget {
//   final Person person;
//   const PersonDetailsPage2({super.key, required this.person});

//   @override
//   State<PersonDetailsPage2> createState() => _PersonDetailsPage2State();
// }

// class _PersonDetailsPage2State extends State<PersonDetailsPage2> {
//   double weight = 60.0;
//   double height = 170.0;
//   String? physicalCondition = 'Loose Fat';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new_outlined,
//               size: 20, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => const HomeScreen()),
//             ),
//             child: const Text(
//               'Skip',
//               style: TextStyle(color: Colors.blue, fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//             _buildSlider(
//                 title: 'Weight (kg)',
//                 value: weight,
//                 min: 30,
//                 max: 200,
//                 onChanged: (v) => setState(() => weight = v)),
//             _buildSlider(
//                 title: 'Height (cm)',
//                 value: height,
//                 min: 100,
//                 max: 250,
//                 onChanged: (v) => setState(() => height = v)),
//             const SizedBox(height: 20),
//             _buildRadioGroup(),
//             const Spacer(),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () async {
//                   final Person updatedPerson = Person(
//                     imagePath: widget.person.imagePath,
//                     name: widget.person.name,
//                     dob: widget.person.dob,
//                     age: widget.person.age,
//                     gender: widget.person.gender,
//                     weight: weight,
//                     height: height,
//                     physicalCondition: physicalCondition!,
//                   );
//                   await addPerson(updatedPerson);
//                   print(
//                       'Person added: ${updatedPerson.name}, ${updatedPerson.weight}, ${updatedPerson.height}, ${updatedPerson.physicalCondition}');
//                   Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const PersonDetailsPage3()),
//                     (Route<dynamic> route) => false,
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black,
//                   foregroundColor: Colors.white,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                 ),
//                 child: const Text('Next', style: TextStyle(fontSize: 16)),
//               ),
//             ),
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSlider(
//       {required String title,
//       required double value,
//       required double min,
//       required double max,
//       required Function(double) onChanged}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title,
//             style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blueGrey)),
//         Slider(
//           value: value,
//           min: min,
//           max: max,
//           divisions: (max - min).toInt(),
//           label: value.toStringAsFixed(1),
//           onChanged: onChanged,
//           activeColor: Colors.blue,
//           inactiveColor: Colors.grey[300],
//         ),
//         Text(value.toStringAsFixed(1),
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 10),
//       ],
//     );
//   }

//   Widget _buildRadioGroup() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Physical Condition',
//             style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blueGrey)),
//         const SizedBox(height: 10),
//         _buildRadioTile('Loose Fat'),
//         _buildRadioTile('Average'),
//         _buildRadioTile('Bulk Muscles'),
//       ],
//     );
//   }

//   Widget _buildRadioTile(String value) {
//     return RadioListTile<String>(
//       title: Text(value,
//           style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color:
//                   physicalCondition == value ? Colors.blue : Colors.grey[600])),
//       value: value,
//       groupValue: physicalCondition,
//       onChanged: (val) => setState(() => physicalCondition = val),
//       activeColor: Colors.blue,
//     );
//   }
// }

// Third Page - Personal Details Part 3 (Final 3 fields)
// class PersonDetailsPage3 extends StatefulWidget {
//   const PersonDetailsPage3({super.key});

//   @override
//   State<PersonDetailsPage3> createState() => _PersonDetailsPage3State();
// }

// class _PersonDetailsPage3State extends State<PersonDetailsPage3> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;

//   void navigateToSplash2() async {
//     // Set the shared preference flag here
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('hasSeenIntro', true);

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const Splash2()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color.fromARGB(255, 139, 128, 168),
//                   Color.fromARGB(255, 7, 15, 8)
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//           SafeArea(
//             child: Column(
//               children: [
//                 const Spacer(),
//                 SizedBox(
//                   height: 220,
//                   width: screenWidth * 0.85,
//                   child: PageView.builder(
//                     controller: _pageController,
//                     onPageChanged: (index) {
//                       setState(() {
//                         _currentPage = index;
//                       });
//                     },
//                     itemCount: 3,
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: index == 2 ? navigateToSplash2 : null,
//                         child: AnimatedContainer(
//                           duration: const Duration(milliseconds: 300),
//                           margin: const EdgeInsets.symmetric(horizontal: 10),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             image: DecorationImage(
//                               image: AssetImage(
//                                 index == 0
//                                     ? 'images/okeyy.png'
//                                     : index == 1
//                                         ? 'images/sherii.png'
//                                         : 'images/lets.png',
//                               ),
//                               fit: BoxFit.cover,
//                             ),
//                             boxShadow: const [],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(3, (index) {
//                     return AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       margin: const EdgeInsets.symmetric(horizontal: 5),
//                       height: 10,
//                       width: _currentPage == index ? 24 : 10,
//                       decoration: BoxDecoration(
//                         color: _currentPage == index
//                             ? Colors.white
//                             : Colors.white.withOpacity(0.5),
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                     );
//                   }),
//                 ),
//                 const SizedBox(height: 30),
//                 GestureDetector(
//                   onTap: () {
//                     if (_currentPage < 2) {
//                       _pageController.nextPage(
//                         duration: const Duration(milliseconds: 500),
//                         curve: Curves.easeInOut,
//                       );
//                     } else {
//                       navigateToSplash2();
//                     }
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 12, horizontal: 30),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(30),
//                       gradient: const LinearGradient(
//                         colors: [
//                           Color.fromARGB(255, 96, 147, 189),
//                           Color.fromARGB(255, 136, 127, 138)
//                         ],
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.3),
//                           blurRadius: 10,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: const Text(
//                       'Continue',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Spacer(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Splash screen to navigate to the homepage
// ignore: camel_case_types
// class Splash2 extends StatefulWidget {
//   const Splash2({super.key});

//   @override
//   State<Splash2> createState() => _Splash2State();
// }

// class _Splash2State extends State<Splash2> {
//   bool _isDone = false;

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(seconds: 3), () {
//       setState(() {
//         _isDone = true;
//       });
//     });

//     Future.delayed(const Duration(seconds: 4), () {
//       if (mounted) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => const Homepage()),
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark(), // Dark mode for a sleek look
//       home: Scaffold(
//         backgroundColor: Colors.black,
//         body: Padding(
//           padding: const EdgeInsets.all(48.0),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 500),
//                   child: Text(
//                     _isDone ? "It's done!" : "Analyzing... Please wait",
//                     key: ValueKey(_isDone),
//                     style: const TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 const LinearProgressIndicator(
//                   backgroundColor: Colors.grey,
//                   color: Colors.blue,
//                   minHeight: 4,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
