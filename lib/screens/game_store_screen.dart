import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animations/mock_data/games_data.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class GameStoreScreen extends StatefulWidget {
  const GameStoreScreen({super.key});

  @override
  State<GameStoreScreen> createState() => _GameStoreScreenState();
}

class _GameStoreScreenState extends State<GameStoreScreen> {
  final PageController _pageController = PageController(
    viewportFraction: 1,
  );
  final PageController _verticalPageController = PageController();

  late int _currentPage;
  double slideBeginX = 0.2;
  double slideBeginY = 0.4;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    print("Init Current Page: $_currentPage");
    _pageController.addListener(() {
      setState(() {
        if (_pageController.page == null) return;
        _scrollHorizontal.value = _pageController.page!;
      });
    });

    _verticalPageController.addListener(() {
      setState(() {
        if (_verticalPageController.page == null) return;
        _scrollVertical.value = _verticalPageController.page!;
      });
    });
  }

  final ValueNotifier<double> _scrollHorizontal = ValueNotifier(0.0);
  final ValueNotifier<double> _scrollVertical = ValueNotifier(0.0);

  void _onPageChanged(int newPage) {
    setState(() {
      _currentPage = newPage;

      print("newPage: $newPage");
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _verticalPageController.dispose();
    super.dispose();
  }

  Offset _getSlideBeginOffset() {
    // Check if the page controllers are attached to a scroll view
    if (_pageController.hasClients && _verticalPageController.hasClients) {
      // Check the scroll direction of the page controllers
      if (_pageController.positions.any((position) =>
          position.userScrollDirection == ScrollDirection.reverse)) {
        // If the user is scrolling to the left, use positive slideBeginX
        return Offset(slideBeginX, 0);
      } else if (_pageController.positions.any((position) =>
          position.userScrollDirection == ScrollDirection.forward)) {
        // If the user is scrolling to the right, use negative slideBeginX
        return Offset(-slideBeginX, 0);
      } else if (_verticalPageController.positions.any((position) =>
          position.userScrollDirection == ScrollDirection.reverse ||
          position.userScrollDirection == ScrollDirection.forward)) {
        // If the user is scrolling vertically, use slideBeginY
        return Offset(0, slideBeginY);
      }
    }

    // Default to no offset if none of the conditions are met
    return const Offset(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Container(
              key: ValueKey(_currentPage),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/games/${_currentPage + 1}_1.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 1,
                  sigmaY: 1,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
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

              return PageView(
                reverse: true,
                scrollDirection: Axis.vertical,
                controller: _verticalPageController,
                children: [
                  Stack(
                    children: [
                      Positioned(
                        top: size.height * 0.1,
                        left: size.width * 0.45,
                        child: Icon(
                          Icons.expand_less,
                          size: size.width * 0.1,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        top: size.height * 0.3,
                        left: size.width * 0.05,
                        child: Animate(
                          effects: [
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                        Text(gameInfoList[index]
                                            .shortDescription),
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
                            SlideEffect(
                              end: const Offset(0.0, 0.0),
                              begin: _getSlideBeginOffset(),
                              duration: 1.seconds,
                              curve: Curves.ease,
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
                                  image: AssetImage(
                                      'assets/games/${index + 1}.jpg'),
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
                  GameDetailScreen(index: index),
                ],
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
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    _youtubeController = YoutubePlayerController(
      initialVideoId:
          gameInfoList[widget.index].youtubeId, // Add your own video id
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
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
                const SizedBox(height: 10),
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
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                const Divider(),
                const Text(
                  "Watch Trailer",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                YoutubePlayer(
                  controller: _youtubeController,
                  showVideoProgressIndicator: true,
                  onReady: () {
                    print('Player is ready.');
                  },
                ),
                const Spacer(),
                Icon(
                  Icons.expand_more,
                  size: size.width * 0.1,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
