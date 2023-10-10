import 'package:flutter/material.dart';

class ExplicitAnimationsScreen extends StatefulWidget {
  const ExplicitAnimationsScreen({super.key});

  @override
  State<ExplicitAnimationsScreen> createState() =>
      _ExplicitAnimationsScreenState();
}

class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 3,
    ),
  )..addListener(() {
      _range.value = _animationController.value;
    });

  @override
  void initState() {
    super.initState();
    // _animationController.repeat();
  }

  final mainColor = Colors.orange.shade100;
  final subColor = Colors.orange.shade900;

  Animation<double> _turn(double start) {
    return Tween(begin: 0.0, end: 0.25).animate(_curved(start));
  }

  CurvedAnimation _curved(double start) {
    return CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        start,
        start + 0.15,
        curve: Curves.easeOut,
      ),
    );
  }

  Widget _box(int index) {
    // 행과 열을 계산
    int row = index ~/ 8;
    int col = index % 8;

    // 행과 열의 합이 짝수이면 회색, 홀수이면 검은색을 배경으로 설정
    Color color = (row + col) % 2 == 0 ? mainColor : subColor;

    double start;
    if ((row + col) % 2 == 0) {
      // 회색 사각형의 시작과 끝
      start = row * 0.03;
    } else {
      // 검은색 사각형의 시작과 끝
      start = 0.5 + row * 0.03;
    }

    return RotationTransition(
      turns: _turn(start),
      child: Container(color: color),
    );
  }

  Color? _backgroundColor() {
    // 회색 사각형 회전 시간대에 배경색을 검정색으로 설정
    if (_animationController.value < 0.5) {
      return subColor;
    }
    // 검정색 사각형 회전 시간대에 배경색을 회색으로 설정
    else {
      return mainColor;
    }
  }

  void _play() {
    _animationController.forward();
  }

  void _pause() {
    _animationController.stop();
  }

  void _reverse() {
    _animationController.reverse();
  }

  final ValueNotifier<double> _range = ValueNotifier(0.0);

  void _onChanged(double value) {
    _range.value = 0;
    _animationController.value = value;
  }

  bool _looping = false;
  void _toggleLooping() {
    if (_looping) {
      _animationController.stop();
    } else {
      _animationController.repeat();
    }
    setState(() {
      _looping = !_looping;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explicit Animations"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => Container(
                  color: _backgroundColor(),
                  child: child,
                ),
                child: GridView.count(
                  crossAxisCount: 8,
                  children: List.generate(64, _box),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _play,
                  child: const Icon(Icons.play_arrow),
                ),
                ElevatedButton(
                  onPressed: _pause,
                  child: const Icon(Icons.pause),
                ),
                ElevatedButton(
                  onPressed: _reverse,
                  child: const Text("Reverse"),
                ),
                ElevatedButton(
                  onPressed: _toggleLooping,
                  child: Text(_looping ? "Stop Loop" : "Loop"),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            ValueListenableBuilder(
              valueListenable: _range,
              builder: (context, value, child) {
                return Slider(
                  value: value,
                  onChanged: _onChanged,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
