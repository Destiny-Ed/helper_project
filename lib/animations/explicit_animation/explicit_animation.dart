import 'package:flutter/material.dart';

class ExplicitAnimationScreen extends StatefulWidget {
  const ExplicitAnimationScreen({super.key});

  @override
  State<ExplicitAnimationScreen> createState() => _ExplicitAnimationScreenState();
}

class _ExplicitAnimationScreenState extends State<ExplicitAnimationScreen> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: Duration(seconds: 2), vsync: this);

    animation = Tween<double>(begin: 0.0, end: 2 * 3.14159).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explicit Animation Example'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Hello, Flutter!'),
            Transform.rotate(
              angle: animation.value,
              child: Icon(
                Icons.star,
                size: 100,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (animationController.isAnimating) {
                  animationController.stop();
                } else {
                  animationController.repeat();
                }
              },
              child: Text('Start Animation'),
            ),
          ],
        ),
      ),
    );
  }
}
