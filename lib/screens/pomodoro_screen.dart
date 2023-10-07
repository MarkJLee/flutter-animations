import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  );

  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _animationController,
    curve: Curves.linear,
  );

  late Animation<double> _progressAnimation = Tween(
    begin: 0.0,
    end: 10.0,
  ).animate(_curve);

  int minutes = 0;
  int seconds = 10;
  int partSeconds = 0; // 포모도로 지나간 초
  int totalSeconds = 0;
  int initMinutes = 0;
  int initSeconds = 10;

  Timer? _timer;
  bool isRunning = false;

  bool timerFinished = false;

  void _startTimer() {
    _animationController.forward();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds == 0) {
        if (minutes == 0) {
          timerFinished = true;
          timer.cancel();
          isRunning = false;
          _animationController.stop();
        } else {
          minutes--;
          seconds = 59;
          totalSeconds++;
          partSeconds++;
        }
      } else {
        seconds--;
        totalSeconds++;
        partSeconds++;
      }

      setState(() {});
    });
  }

  // void _setTime() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Set Time'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               keyboardType: TextInputType.number,
  //               onChanged: (value) {
  //                 initMinutes = int.parse(value);
  //               },
  //               decoration: const InputDecoration(
  //                 labelText: 'Minutes',
  //               ),
  //               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //             ),
  //             TextField(
  //               keyboardType: TextInputType.number,
  //               onChanged: (value) {
  //                 initSeconds = int.parse(value);
  //               },
  //               decoration: const InputDecoration(
  //                 labelText: 'Seconds',
  //               ),
  //               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               setState(() {
  //                 minutes = initMinutes;
  //                 seconds = initSeconds;
  //                 partSeconds = 0;
  //               });
  //               Navigator.pop(context);
  //             },
  //             child: const Text('Set'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _setTime() {
    int tempMinutes = initMinutes;
    int tempSeconds = initSeconds;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Time'),
          backgroundColor: Colors.amber.shade100,
          content: SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  child: CupertinoPicker(
                    backgroundColor: Colors.white,
                    itemExtent: 30.0,
                    onSelectedItemChanged: (index) {
                      tempMinutes = index;
                    },
                    children: List<Widget>.generate(
                        61, (index) => Center(child: Text('$index'))),
                  ),
                ),
                const Text('분'),
                const SizedBox(width: 20),
                SizedBox(
                  width: 80,
                  child: CupertinoPicker(
                    backgroundColor: Colors.white,
                    itemExtent: 30.0,
                    onSelectedItemChanged: (index) {
                      tempSeconds = index;
                    },
                    children: List<Widget>.generate(
                        60, (index) => Center(child: Text('$index'))),
                  ),
                ),
                const Text('초'),
              ],
            ),
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
                  initMinutes = tempMinutes;
                  initSeconds = tempSeconds;
                  minutes = initMinutes;
                  seconds = initSeconds;
                  partSeconds = 0;
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

  void _onPressedPlay() {
    if (isRunning) {
      _timer?.cancel();
      _animationController.stop();
    } else {
      timerFinished = false;
      var initTotalSeconds = initMinutes * 60 + initSeconds;

      _animationController.duration = Duration(seconds: initTotalSeconds);

      final startValue = partSeconds / initTotalSeconds;

      _defineProgressAnimation(startValue, 1);
      _animationController.value = startValue;
      _startTimer();
    }
    isRunning = !isRunning;
    setState(() {});
  }

  void _defineProgressAnimation(double begin, double end) {
    _progressAnimation = Tween(
      begin: begin,
      end: end,
    ).animate(_curve);
  }

  void _onPressedRefresh() {
    if (isRunning) {
      _timer?.cancel();
      isRunning = !isRunning;
      timerFinished = false;
    }
    timerFinished = false;
    partSeconds = 0;
    totalSeconds = 0;
    minutes = initMinutes;
    seconds = initSeconds;

    _animationController.reset();
    _defineProgressAnimation(0, 1);
    setState(() {});
  }

  void _onPressedStop() {
    minutes = initMinutes;
    seconds = initSeconds;
    _timer?.cancel();
    isRunning = false;
    timerFinished = false;

    partSeconds = 0;

    _animationController.reset();
    _defineProgressAnimation(0, 1);
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
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
            color: timerFinished ? Colors.deepOrange : Colors.black,
            borderRadius: BorderRadius.circular(width / 8),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: ProgressPainter(
                        progress: _progressAnimation.value,
                        width: width,
                      ),
                    );
                  },
                ),
              ),
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
                  highlightColor: Colors.amberAccent.withOpacity(0.3),
                  icon:
                      Icon(Icons.stop, color: Colors.white, size: width * 0.15),
                  onPressed: _onPressedStop,
                ),
              ),
              Positioned(
                bottom: width * 0.05,
                right: width * 0.05,
                child: IconButton(
                  highlightColor: Colors.amberAccent.withOpacity(0.3),
                  icon: isRunning
                      ? Icon(Icons.pause,
                          color: Colors.white, size: width * 0.15)
                      : Icon(Icons.play_arrow,
                          color: Colors.white, size: width * 0.15),
                  onPressed: _onPressedPlay,
                ),
              ),
              Positioned(
                top: width * 0.05,
                right: width * 0.05,
                child: IconButton(
                  highlightColor: Colors.amberAccent.withOpacity(0.3),
                  icon: Icon(Icons.refresh,
                      color: Colors.white, size: width * 0.15),
                  onPressed: _onPressedRefresh,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double progress;
  final double width;

  ProgressPainter({
    required this.progress,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );
    final radius = size.width / 2.3;

    final circlePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = width * 0.06
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      center,
      radius,
      circlePaint,
    );

    final arcPaint = Paint()
      ..color = Colors.amberAccent
      ..strokeWidth = width * 0.06
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * (pi / 180),
      2 * pi * progress,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
