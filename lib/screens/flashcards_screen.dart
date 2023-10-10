import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animations/mock_data/dart_syntax_quiz_data.dart';

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen>
    with TickerProviderStateMixin {
  int _index = 0;
  final GlobalKey<_CardState> cardKey = GlobalKey<_CardState>();
  late final size = MediaQuery.of(context).size;
  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 2,
    ),
    lowerBound: (size.width + 100) * -1,
    upperBound: (size.width + 100),
    value: 0.0,
  );

  late final AnimationController _barController = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 250,
    ),
  );

  late Animation<double> _bar;

  @override
  void initState() {
    super.initState();
    _updateBarTween();
    _barController.forward();
  }

  void _updateBarTween() {
    _bar = Tween<double>(
      begin: (_index) / 10,
      end: (_index + 1) / 10,
    ).animate(_barController);
  }

  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  late final Tween<double> _scale = Tween(
    begin: 0.8,
    end: 1,
  );

  late final Tween<double> _opacity = Tween(
    begin: 0.0,
    end: 1.0,
  );

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx;
  }

  void _whenComplete() {
    _position.value = 0;
    setState(() {
      _index = _index == 9 ? 0 : _index + 1;
      if (cardKey.currentState != null) {
        cardKey.currentState!.resetCard();
      }
      _updateBarTween();
      _barController.reset();
      _barController.forward();
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width - 200;
    final dropZone = size.width + 100;
    if (_position.value.abs() >= bound) {
      final factor = _position.value.isNegative ? -1 : 1;
      _position
          .animateTo(
            dropZone * factor,
            curve: Curves.easeOut,
          )
          .whenComplete(_whenComplete);
    } else {
      _position.animateTo(
        0,
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _position.dispose();
    _barController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_position, _barController]),
      builder: (context, child) {
        Color backgroundColor;
        String swipeText;
        const colorRed = Colors.redAccent;
        const colorBlue = Colors.lightBlueAccent;
        const colorGreen = Colors.lightGreen;

        if (_position.value < 0) {
          backgroundColor = colorRed;

          swipeText = "Need to review";
        } else if (_position.value > 0) {
          backgroundColor = colorGreen;
          swipeText = "I got it!";
        } else {
          backgroundColor = colorBlue;
          swipeText = "Swipe the card";
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Flashcards'),
            backgroundColor: backgroundColor,
          ),
          backgroundColor: backgroundColor,
          body: Column(
            children: [
              SizedBox(height: size.height * 0.1),
              Text(
                swipeText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Flexible(
                child: AnimatedBuilder(
                  animation: _position,
                  builder: (context, child) {
                    final angle = _rotation.transform(
                            (_position.value + size.width / 2) / size.width) *
                        pi /
                        180;
                    final scale =
                        _scale.transform(_position.value.abs() / size.width);

                    final opacity = min(1.0,
                        _opacity.transform(_position.value.abs() / size.width));

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 50,
                          child: Transform.scale(
                            scale: min(scale, 1.0),
                            child: Opacity(
                                opacity: opacity,
                                child:
                                    Card(index: _index == 9 ? 0 : _index + 1)),
                          ),
                        ),
                        Positioned(
                          top: 50,
                          child: GestureDetector(
                            onHorizontalDragUpdate: _onHorizontalDragUpdate,
                            onHorizontalDragEnd: _onHorizontalDragEnd,
                            child: Transform.translate(
                              offset: Offset(_position.value, 0),
                              child: Transform.rotate(
                                angle: angle,
                                child: Card(index: _index, key: cardKey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                width: size.width * 0.8,
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 10,
                  backgroundColor: Colors.white.withOpacity(0.5),
                  color: Colors.white,
                  value: _bar.value,
                ),
              ),
              SizedBox(height: size.height * 0.1),
            ],
          ),
        );
      },
    );
  }
}

class Card extends StatefulWidget {
  final int index;

  const Card({super.key, required this.index});

  @override
  State<Card> createState() => _CardState();
}

class _CardState extends State<Card> with SingleTickerProviderStateMixin {
  bool flipped = false;
  late final AnimationController _cardController;

  void resetCard() {
    flipped = false;
    _cardController.value = 0.0;
  }

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  void _flipCard() {
    flipped = !flipped;
    if (flipped) {
      _cardController.forward();
    } else {
      _cardController.reverse();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: _flipCard,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(pi * _cardController.value),
        child: IndexedStack(
          index: _cardController.value < 0.5 ? 0 : 1,
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity(),
              child: CardMaterial(
                size: size,
                widget: widget,
                text: dartQuizzes[widget.index].question,
              ),
            ),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(pi),
              child: CardMaterial(
                size: size,
                widget: widget,
                text: dartQuizzes[widget.index].answer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardMaterial extends StatelessWidget {
  const CardMaterial({
    super.key,
    required this.size,
    required this.widget,
    required this.text,
  });

  final Size size;
  final Card widget;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.4,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: size.width * 0.06,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
