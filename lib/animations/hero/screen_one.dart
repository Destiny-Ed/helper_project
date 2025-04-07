import 'package:flutter/material.dart';
import 'package:helper_app/animations/hero/screen_two.dart';

class HeroAnimationScreenOne extends StatefulWidget {
  const HeroAnimationScreenOne({super.key});

  @override
  State<HeroAnimationScreenOne> createState() => _HeroAnimationScreenOneState();
}

class _HeroAnimationScreenOneState extends State<HeroAnimationScreenOne> {
  final image = "https://picsum.photos/200/300";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hero Animation Example'),
      ),
      body: Center(
        child: Column(
          spacing: 10,
          children: [
            Hero(
                tag: image,
                child: Image.network(
                  image,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                )),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HeroAnimationScreenTwo(
                        heroTag: image,
                        imageUrl: image,
                      ),
                    ));
                  });
                },
                child: Text("Move to the next page"))
          ],
        ),
      ),
    );
  }
}
