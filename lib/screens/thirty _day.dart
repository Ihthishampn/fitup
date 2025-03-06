import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ui/core/run_funtion.dart';
import '../modules/run_model.dart';

class WorkoutSchedulePage extends StatefulWidget {
  const WorkoutSchedulePage({super.key});

  @override
  _WorkoutSchedulePageState createState() => _WorkoutSchedulePageState();
}

class _WorkoutSchedulePageState extends State<WorkoutSchedulePage> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  List<RunRecord> _runRecords = [];
  Map<int, int> _completedDaysCount = {};
  bool _minTimeReached = false;
  bool _maxTimeReached = false;

  int _currentDayIndex = 0; // Tracks the current chunk of 4 days
  static const int _daysToShow = 4; // Number of days to show at a time

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    await RunFunction.initHive();
    await _loadRunRecords();
    await _loadCompletedDays();
    _setCurrentDayIndexBasedOnLastCompletedDay(); // Set index based on last completed day
    _checkAndShowReminder(); // Check if the current day is incomplete
  }

  void _checkAndShowReminder() {
    int currentDay = _getCurrentDay();
    if (!_completedDaysCount.containsKey(currentDay)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showReminderPopup(currentDay);
      });
    }
  }

  void _showReminderPopup(int day) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reminder'),
        content: Text(
            'You haven\'t completed Day $day yet. Don\'t forget to complete it today!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  int _getCurrentDay() {
    return _completedDaysCount.isEmpty ? 1 : _completedDaysCount.length + 1;
  }

  void _setCurrentDayIndexBasedOnLastCompletedDay() {
    if (_completedDaysCount.isNotEmpty) {
      int lastCompletedDay = _completedDaysCount.keys.last;
      _currentDayIndex = ((lastCompletedDay - 1) ~/ _daysToShow) * _daysToShow;
      setState(() {});
    }
  }

  void _startStopwatch() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_stopwatch.elapsedMilliseconds >= 600000) {
          // 10 minutes
          _stopStopwatch();
          _maxTimeReached = true;
        } else if (_stopwatch.elapsedMilliseconds >= 300000) {
          // 5 minutes
          _minTimeReached = true;
        }
      });
    });
  }

  void _stopStopwatch() async {
    _stopwatch.stop();
    _timer?.cancel();

    if (_stopwatch.elapsedMilliseconds >= 600000) {
      // 10 minutes
      _maxTimeReached = true;
      await _saveRunRecord(_stopwatch.elapsedMilliseconds);
      await _checkDailyCompletion();
    } else if (_stopwatch.elapsedMilliseconds >= 300000) {
      // 5 minutes
      _minTimeReached = true;
      await _saveRunRecord(_stopwatch.elapsedMilliseconds);
    }

    setState(() {}); // Ensure UI updates
  }

  void _resetStopwatch() {
    _stopwatch.reset();
    _minTimeReached = false;
    _maxTimeReached = false;
    setState(() {});
  }

  Future<void> _loadRunRecords() async {
    _runRecords = await RunFunction.loadRunRecords();
    setState(() {});
  }

  Future<void> _loadCompletedDays() async {
    Set<int> completedDays = await RunFunction.loadCompletedDays();
    _completedDaysCount = {for (var day in completedDays) day: 1};
    setState(() {});
  }

  Future<void> _saveRunRecord(int milliseconds) async {
    String date = DateTime.now().toString().split(" ")[0];
    RunRecord record = RunRecord(milliseconds: milliseconds, date: date);
    await RunFunction.saveRunRecord(record);
    _loadRunRecords();
  }

  String _formatTime(int milliseconds) {
    int seconds = (milliseconds ~/ 1000) % 60;
    int minutes = (milliseconds ~/ (1000 * 60)) % 60;
    int milliSeconds = milliseconds % 1000;
    String time = '$minutes:${seconds.toString().padLeft(2, '0')}';
    return '$time.${milliSeconds.toString().padLeft(3, '0')}';
  }

  Future<void> _saveCompletedDay(int day) async {
    await RunFunction.saveCompletedDay(day);
    _loadCompletedDays();
  }

  Future<void> _checkDailyCompletion() async {
    int nextDay =
        _completedDaysCount.isEmpty ? 1 : _completedDaysCount.length + 1;

    if (nextDay <= 30) {
      if (_completedDaysCount.containsKey(nextDay)) {
        _completedDaysCount[nextDay] = _completedDaysCount[nextDay]! + 1;
      } else {
        _completedDaysCount[nextDay] = 1;
      }

      await _saveCompletedDay(nextDay);
      debugPrint(
          'Marked Day $nextDay as completed, count: ${_completedDaysCount[nextDay]}');
    } else {
      debugPrint('Cannot complete beyond 30 days');
    }

    setState(() {}); // Update UI
  }

  Future<void> _restartChallenge() async {
    await RunFunction.clearCompletedDays(); // Clear completed days
    await RunFunction.clearRunRecords(); // Clear run records
    setState(() {
      _completedDaysCount.clear(); // Reset completed days map
      _runRecords.clear(); // Reset run records list
      _currentDayIndex = 0; // Reset to the first chunk
    });
  }

  void _nextChunk() {
    if (_currentDayIndex + _daysToShow < 30) {
      setState(() {
        _currentDayIndex += _daysToShow; // Move to next set of days
      });
    }
  }

  void _previousChunk() {
    if (_currentDayIndex - _daysToShow >= 0) {
      setState(() {
        _currentDayIndex -= _daysToShow; // Move to previous set of days
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isChallengeComplete = _completedDaysCount.length == 30;

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'RUN A WHILE',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 19),
        ),
        leading: IconButton(
          iconSize: 21,
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Hero Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[400]!, Colors.purple[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'images/runningnew.png',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Time Constraints Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(17),
                child: Column(
                  children: [
                    const Text(
                      'Time Constraints',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer,
                          color: _minTimeReached ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          '5 minutes',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer_off,
                          color: _maxTimeReached ? Colors.red : Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Maximum: 10 minutes',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Stopwatch Display
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.purple[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: RichText(
                  text: TextSpan(
                    text: _formatTime(_stopwatch.elapsedMilliseconds)
                        .substring(0, 5),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: _formatTime(_stopwatch.elapsedMilliseconds)
                            .substring(5),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _stopwatch.isRunning ? null : _startStopwatch,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    elevation: 2,
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Start',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: _stopwatch.isRunning ? _stopStopwatch : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Stop',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: (_stopwatch.elapsedMilliseconds > 0)
                      ? _resetStopwatch
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    elevation: 2,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 30-Day Challenge Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '30-Day Challenge',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 350,
                      child: ListView.builder(
                        itemCount: _daysToShow,
                        itemBuilder: (context, index) {
                          int day = _currentDayIndex + index + 1;
                          if (day > 30) return Container(); // Avoid overflow
                          int count = _completedDaysCount[day] ?? 0;

                          return ListTile(
                            leading: Icon(
                              count > 0 ? Icons.check_circle : Icons.pending,
                              color: count > 0 ? Colors.green : Colors.grey,
                            ),
                            title: Text(
                              'Day $day - Completed: $count time(s)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: count > 0 ? Colors.green : Colors.red,
                              ),
                            ),
                            subtitle:
                                Text(count > 0 ? '10 min' : 'Not yet started'),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentDayIndex > 0)
                          TextButton(
                            onPressed: _previousChunk,
                            child: const Text('Previous Days'),
                          ),
                        if (_currentDayIndex + _daysToShow < 30)
                          TextButton(
                            onPressed: _nextChunk,
                            child: const Text('Next Days'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "After completing the 30 days, you will see a button here to restart from day 1.. 🔄 .Let's find that button!..🔄",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),

            if (isChallengeComplete)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: _restartChallenge,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Restart Challenge',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
