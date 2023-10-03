import 'dart:async';

import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TextScreenState();
}

class _TextScreenState extends State<TestScreen> {
  bool _toggle = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => setState(
        () {
          _toggle = !_toggle;
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Test Screen"),
        ),
        body: Center(
          child: AnimatedContainer(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.5,
            duration: const Duration(seconds: 1),
            transform: _toggle
                ? Matrix4.translationValues(10, -10, 0)
                : Matrix4.translationValues(-10, 10, 0),
            decoration: BoxDecoration(
              color: _toggle ? Colors.red : Colors.blue,
            ),
          ),
        ));
  }
}
