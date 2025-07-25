import 'package:flutter/material.dart';
import 'package:animated_keyword_text/animated_keyword_text.dart';

void main() {
  runApp(const MaterialApp(home: AnimatedTextDemo()));
}

class AnimatedTextDemo extends StatelessWidget {
  const AnimatedTextDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final keywords = [
      'House Cleaning',
      'Floor Cleaning',
      'Window Washing',
      'Pool Cleaning'
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Search for '", style: TextStyle(fontSize: 24)),
            AnimatedKeywordText(
              keywords: keywords,
              textStyle: const TextStyle(color: Colors.orange, fontSize: 24),
            ),
            const Text("'", style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
