import 'package:flutter/material.dart';
import 'package:ui/screens/persons.dart';

class PageLogin extends StatelessWidget {
  const PageLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(237, 236, 235, 240),
      body: Column(
        children: [
          const SizedBox(height: 140),
          const Center(
            child: CircleAvatar(
              backgroundImage: AssetImage('images/logogym.png'),
              radius: 65,
            ),
          ),
          const SizedBox(height: 24),
          const Text('Hello!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
          const SizedBox(height: 12),
          const Text('I\'m your personal coach.',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const Text('Here are some questions to know',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const Text('your self.',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 39),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const PersonDetailsPage1()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 14),
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 5,
            ),
            child: const Text(
              'I\'m Ready',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
