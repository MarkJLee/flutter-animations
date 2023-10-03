import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ImplicitAnimationsScreen extends StatefulWidget {
  const ImplicitAnimationsScreen({super.key});

  @override
  State<ImplicitAnimationsScreen> createState() =>
      _ImplicitAnimationsScreenState();
}

class _ImplicitAnimationsScreenState extends State<ImplicitAnimationsScreen> {
  Timer? _timer;
  final random = Random();
  bool _toggle = true;

  late List<List<Color>> _rectColors;
  late List<List<double>> _rotationValues;
  late List<List<int>> _moveSpeeds;

  @override
  void initState() {
    super.initState();
    _rectColors = getElements(getRandomColor);
    _rotationValues = getElements(getRotationValue);
    _moveSpeeds = getElements(getMoveSpeed);
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => setState(
        () {
          _toggle = !_toggle;
        },
      ),
    );
  }

  void _initializeValues() {
    _rectColors = getElements(getRandomColor);
    _rotationValues = getElements(getRotationValue);
    _moveSpeeds = getElements(getMoveSpeed);
  }

  List<List<T>> getElements<T>(T Function() func) {
    return List.generate(10, (i) => List.generate(10, (j) => func()));
  }

  Color getRandomColor() {
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

  double getRotationValue() {
    return (random.nextBool() ? 1 : -1) * random.nextDouble() * 1 * (pi / 32);
  }

  int getMoveSpeed() {
    return random.nextInt(3000) + 300;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalSpacing = MediaQuery.of(context).size.width * 0.025;
    final verticalSpacing = MediaQuery.of(context).size.width * 0.025;

    // 10x10 grid of AniRect
    List<Widget> rows = [];
    for (int i = 0; i < 10; i++) {
      List<Widget> cols = [];
      for (int j = 0; j < 10; j++) {
        double relativeX = j - 4.5;
        double relativeY = i - 4.5;

        cols.add(
          AniRect(
            moveDistanceX: _toggle ? 0 : relativeX * 3,
            moveDistanceY: _toggle ? 0 : relativeY * 3,
            moveDistanceZ: _toggle ? 0 : 100,
            rotationAngle: _rotationValues[i][j],
            size: Size(size.width * 0.06, size.width * 0.06),
            color: _rectColors[i][j],
            sec: _moveSpeeds[i][j],
          ),
        );
        cols.add(SizedBox(width: horizontalSpacing));
      }
      rows.add(
          Row(mainAxisAlignment: MainAxisAlignment.center, children: cols));
      rows.add(SizedBox(height: verticalSpacing));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Implicit Animations"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: rows,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _initializeValues();
                });
              },
              child: const Text("refresh"),
            ),
          ],
        ),
      ),
    );
  }
}

class AniRect extends StatelessWidget {
  const AniRect({
    super.key,
    required this.moveDistanceY,
    required this.moveDistanceX,
    required this.moveDistanceZ,
    required this.rotationAngle,
    required this.size,
    required this.color,
    required this.sec,
  });

  final double moveDistanceY;
  final double moveDistanceX;
  final double moveDistanceZ;
  final double rotationAngle;
  final Size size;
  final Color color;
  final int sec;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: sec),
      transform: Matrix4.rotationZ(rotationAngle)
        ..translate(moveDistanceX, moveDistanceY, moveDistanceZ),
      transformAlignment: Alignment.center,
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
