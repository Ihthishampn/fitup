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

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    await RunFunction.initHive();
    _loadRunRecords();
    _loadCompletedDays();
  }

  void _startStopwatch() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_stopwatch.elapsedMilliseconds >= 6000000) {
          _stopStopwatch();
          _maxTimeReached = true;
        } else if (_stopwatch.elapsedMilliseconds >= 3000000) {
          _minTimeReached = true;
        }
      });
    });
  }

  void _stopStopwatch() async {
    _stopwatch.stop();
    _timer?.cancel();

    if (_stopwatch.elapsedMilliseconds >= 60000) {
      _maxTimeReached = true;
      await _saveRunRecord(_stopwatch.elapsedMilliseconds);
      await _checkDailyCompletion();
    } else if (_stopwatch.elapsedMilliseconds >= 30000) {
      _minTimeReached = true;
      await _saveRunRecord(_stopwatch.elapsedMilliseconds);
    }

    setState(() {});
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
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isChallengeComplete = _completedDaysCount.length == 30;

    return Scaffold(
      backgroundColor: Colors.white,
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
                color: Colors.grey[100], // Neutral background
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
              elevation: 2,
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
              color: Colors.white,
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: RichText(
                    text: TextSpan(
                      text: _formatTime(_stopwatch.elapsedMilliseconds)
                          .substring(0, 5),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: _maxTimeReached ? Colors.red : Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: _formatTime(_stopwatch.elapsedMilliseconds)
                              .substring(5),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _maxTimeReached ? Colors.red : Colors.black,
                          ),
                        ),
                      ],
                    ),
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
              elevation: 2,
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
                        height: 500,
                        child: ListView.builder(
                          itemCount: 30,
                          itemBuilder: (context, index) {
                            int day = index + 1;
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
                              subtitle: Text(
                                  count > 0 ? '10 min' : 'Not yet started'),
                            );
                          },
                        )),
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
