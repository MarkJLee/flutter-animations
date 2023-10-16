import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animations/mock_data/games_data.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

bool isReturningFromHero = false;

class TestGameStoreScreen extends StatefulWidget {
  const TestGameStoreScreen({super.key});

  @override
  State<TestGameStoreScreen> createState() => _TestGameStoreScreenState();
}

class _TestGameStoreScreenState extends State<TestGameStoreScreen> {
  final PageController _pageController = PageController(
    viewportFraction: 1,
  );

  late int _currentPage;
  double slideBegin = 0.2;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    print("Init Current Page: $_currentPage");
    _pageController.addListener(() {
      setState(() {
        if (_pageController.page == null) return;
        _scroll.value = _pageController.page!;
      });
      _handleScroll();
    });
  }

  void _handleScroll() {
    if (_pageController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      // User is scrolling to the left
      slideBegin = 0.3;
    } else {
      // User is scrolling to the right
      slideBegin = -0.3;
    }
  }

  final ValueNotifier<double> _scroll = ValueNotifier(0.0);

  void _onPageChanged(int newPage) {
    setState(() {
      _currentPage = newPage;

      print("newPage: $newPage");
    });
  }

  void _onTap(int index) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 1),
        reverseTransitionDuration: const Duration(seconds: 1),
        pageBuilder: (context, animation, secondaryAnimation) {
          return GameDetailScreen(index: index);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // 'CurvedAnimation'은 애니메이션 효과에 곡선을 적용합니다.
          var begin = const Offset(0.0, -1.0); // 애니메이션 시작 지점 (화면 아래쪽)
          var end = Offset.zero; // 애니메이션 종료 지점 (기본 위치)
          var curve = Curves.ease;

          // 애니메이션을 조절하는 곡선을 설정합니다.
          var curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          // 'Tween'은 시작 지점과 종료 지점 사이의 선형 보간을 정의합니다.
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          // 'AnimatedBuilder'를 사용하여 트윈 애니메이션을 현재 상태로 빌드합니다.
          return SlideTransition(
            position: tween
                .animate(curvedAnimation), // 현재 애니메이션 값을 사용하여 슬라이드 전환을 수행합니다.
            child: child, // 실제 전환될 페이지의 내용
          );
        },
      ),
    ).then((value) {
      setState(() {
        isReturningFromHero = false;
        print("isReturningFromHero: $isReturningFromHero");
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool animation = true;
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: GestureDetector(
          onTap: () => _onTap(_currentPage),
          child: Icon(
            Icons.expand_less,
            size: size.width * 0.1,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Container(
              key: ValueKey(_currentPage),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/games/${_currentPage + 1}_1.jpg"),
                    fit: BoxFit.cover),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 2,
                  sigmaY: 2,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
          ),
          PageView.builder(
            onPageChanged: _onPageChanged,
            controller: _pageController,
            itemCount: 3,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              print("_currentPage: $_currentPage");
              return Hero(
                tag: "game_$index",
                child: Stack(
                  children: [
                    Positioned(
                      top: size.height * 0.3,
                      left: size.width * 0.05,
                      child: Animate(
                        effects: [
                          if (animation)
                            FadeEffect(
                              begin: 0.5,
                              duration: 1.seconds,
                            ),
                        ],
                        child: Container(
                          height: size.height * 0.6,
                          width: size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(0, 8),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: size.height * 0.05),
                              Material(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: size.height * 0.15),
                                      Text(
                                        gameInfoList[index].title,
                                        style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                          gameInfoList[index].shortDescription),
                                      const SizedBox(height: 20),
                                      const Text(
                                        "Official Rating",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      RatingBarIndicator(
                                        rating: gameInfoList[index].rating,
                                        itemBuilder: (context, index) =>
                                            const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 5,
                                        itemSize: size.width * 0.05,
                                        direction: Axis.horizontal,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // thumnail
                    Positioned(
                      top: size.height * 0.2,
                      left: size.width * 0.18,
                      right: size.width * 0.18,
                      child: Animate(
                        effects: [
                          if (!isReturningFromHero)
                            SlideEffect(
                              end: const Offset(0.0, 0.0),
                              begin: Offset(slideBegin, 0),
                              duration: 500.milliseconds,
                              curve: Curves.easeOut,
                            )
                        ],
                        child: Container(
                          height: size.height * 0.3,
                          width: size.width * 0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(0, 8),
                              )
                            ],
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/games/${index + 1}.jpg'),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: size.height * 0.81,
                      left: size.width * 0.05,
                      right: size.width * 0.05,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0))),
                        height: size.height * 0.09,
                        width: size.width * 0.1,
                        child: const Center(
                          child: Material(
                            color: Colors.blue,
                            child: Text(
                              textAlign: TextAlign.center,
                              "Add to cart +",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class GameDetailScreen extends StatefulWidget {
  final int index;

  const GameDetailScreen({super.key, required this.index});

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  void _onTapBottomAppBar() {
    setState(() {
      isReturningFromHero = true;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    var backgroundImage = Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/games/${widget.index + 1}_1.jpg"), // 이미지 경로
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          color: Colors.black.withOpacity(0.3),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          backgroundImage,
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.1),
                Text(
                  gameInfoList[widget.index].title,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Official Rating",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                RatingBarIndicator(
                  rating: gameInfoList[widget.index].rating,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: size.width * 0.05,
                  direction: Axis.horizontal,
                ),
                const Divider(),
                Text(
                  gameInfoList[widget.index].longDescription,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _onTapBottomAppBar,
                  child: Hero(
                    tag: "game_${widget.index}",
                    child: Icon(
                      Icons.expand_more,
                      size: size.width * 0.1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
