import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/screens/homepage.dart';
import 'package:ui/screens/page_login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    if (hasSeenIntro) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const PageLogin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final titleFontSize = screenWidth * 0.08; 
    final bottomPadding = screenHeight * 0.1; 

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'images/splashimage.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            left: screenWidth * 0.35,
            bottom: bottomPadding, 
            child: Text(
              'FITUP',
              style: TextStyle(
                fontSize: titleFontSize, 
                color: const Color.fromARGB(255, 121, 111, 111),
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
