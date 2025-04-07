import 'package:flutter/material.dart';

class ImplicitAnimationScreen extends StatefulWidget {
  const ImplicitAnimationScreen({super.key});

  @override
  State<ImplicitAnimationScreen> createState() => _ImplicitAnimationScreenState();
}

class _ImplicitAnimationScreenState extends State<ImplicitAnimationScreen> {
  bool _isExpanded = false;

  bool _isVisible = true;

  bool _showFirst = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Implicit Animation"),
      ),
      body: Center(
        child: Column(
          spacing: 20,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                width: _isExpanded ? 200 : 100,
                height: _isExpanded ? 200 : 100,
                color: _isExpanded ? Colors.blue : Colors.red,
                curve: Curves.easeInOut,
              ),
            ),
            AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: Text(
                "Hello, Destiny Ed",
                style: TextStyle(fontSize: 30),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
                child: Text("Toogle Text Fading"),
                onPressed: () {
                  setState(() {
                    _isVisible = !_isVisible;
                  });
                }),

            ///cross fade
            AnimatedCrossFade(
              firstChild: Container(
                width: 200,
                height: 200,
                color: Colors.green,
              ),
              secondChild: Container(
                width: 200,
                height: 200,
                color: Colors.red,
              ),
              crossFadeState: _showFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: Duration(seconds: 1),
            ),

            SizedBox(height: 10),
            ElevatedButton(
                child: Text("Switch Widget"),
                onPressed: () {
                  setState(() {
                    _showFirst = !_showFirst;
                  });
                }),
          ],
        ),
      ),
    );
  }
}
