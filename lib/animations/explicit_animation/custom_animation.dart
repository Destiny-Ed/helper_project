import 'package:flutter/material.dart';

class CustomAnimationScreen extends StatefulWidget {
  const CustomAnimationScreen({super.key});

  @override
  State<CustomAnimationScreen> createState() => _CustomAnimationScreenState();
}

class _CustomAnimationScreenState extends State<CustomAnimationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _height;
  late Animation<double> _size;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1))..repeat(reverse: true);

    _height =
        Tween<double>(begin: 0, end: 200).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceInOut));

    _size = Tween<double>(begin: 50, end: 30).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Bouncing Ball"),
        ),
        body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              children: [
                Positioned(
                  bottom: MediaQuery.of(context).size.height / 2 - _height.value / 2,
                  left: MediaQuery.of(context).size.width / 2 - _size.value / 2,
                  child: Container(
                    height: _size.value,
                    width: _size.value,
                    decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                  ),
                )
              ],
            );
          },
        ));
  }
}
