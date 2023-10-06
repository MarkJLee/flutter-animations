import 'dart:async';

import 'package:flutter/material.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int minutes = 25;
  int seconds = 0;
  int totalSeconds = 0;
  int initMinutes = 25;
  int initSeconds = 0;

  Timer? _timer;
  bool isRunning = false;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds == 0) {
        if (minutes == 0) {
          timer.cancel();
          isRunning = false;
        } else {
          minutes--;
          seconds = 59;
          totalSeconds++;
        }
      } else {
        seconds--;
        totalSeconds++;
      }

      setState(() {});
    });
  }

  void _setTime() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  initMinutes = int.parse(value);
                },
                decoration: const InputDecoration(
                  labelText: 'Minutes',
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  initSeconds = int.parse(value);
                },
                decoration: const InputDecoration(
                  labelText: 'Seconds',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  minutes = initMinutes;
                  seconds = initSeconds;
                });
                Navigator.pop(context);
              },
              child: const Text('Set'),
            ),
          ],
        );
      },
    );
  }

  String get _timeLabel {
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  String _totalTimeLabel(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Watch'),
      ),
      body: Center(
        child: Container(
          width: width,
          height: width * 1.222,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(width / 8),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: width * 0.8,
                  height: width * 0.5,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _setTime,
                        child: Text(
                          _timeLabel,
                          style: TextStyle(
                              color: Colors.white, fontSize: width * 0.2),
                        ),
                      ),
                      Text(
                        _totalTimeLabel(totalSeconds),
                        style: TextStyle(
                            color: Colors.amberAccent, fontSize: width * 0.1),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: width * 0.05,
                left: width * 0.05,
                child: IconButton(
                  icon:
                      Icon(Icons.stop, color: Colors.white, size: width * 0.15),
                  onPressed: () {
                    setState(() {
                      minutes = initMinutes;
                      seconds = initSeconds;
                      _timer?.cancel();
                      isRunning = false;
                    });
                  },
                ),
              ),
              Positioned(
                bottom: width * 0.05,
                right: width * 0.05,
                child: IconButton(
                  icon: isRunning
                      ? Icon(Icons.pause,
                          color: Colors.white, size: width * 0.15)
                      : Icon(Icons.play_arrow,
                          color: Colors.white, size: width * 0.15),
                  onPressed: () {
                    setState(() {
                      if (isRunning) {
                        _timer?.cancel();
                      } else {
                        _startTimer();
                      }
                      isRunning = !isRunning;
                    });
                  },
                ),
              ),
              Positioned(
                top: width * 0.05,
                right: width * 0.05,
                child: IconButton(
                  icon: Icon(Icons.refresh,
                      color: Colors.white, size: width * 0.15),
                  onPressed: () {
                    setState(() {
                      if (isRunning) {
                        _timer?.cancel();
                        isRunning = !isRunning;
                      }

                      totalSeconds = 0;
                      minutes = initMinutes;
                      seconds = initSeconds;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
