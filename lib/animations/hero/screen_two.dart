import 'package:flutter/material.dart';

class HeroAnimationScreenTwo extends StatefulWidget {
  final String heroTag;
  final String imageUrl;
  const HeroAnimationScreenTwo({super.key, required this.heroTag, required this.imageUrl});

  @override
  State<HeroAnimationScreenTwo> createState() => _HeroAnimationScreenTwoState();
}

class _HeroAnimationScreenTwoState extends State<HeroAnimationScreenTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Hero(
            tag: widget.heroTag,
            flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
              return RotationTransition(
                turns: animation,
                child: toHeroContext.widget,
              );
            },
            child: Image.network(
              widget.imageUrl,
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            )),
      ),
    );
  }
}
