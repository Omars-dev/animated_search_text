import 'package:flutter/material.dart';

class AnimatedKeywordText extends StatefulWidget {
  final List<String> keywords;
  final TextStyle? textStyle;
  final Duration delay;
  final Duration duration;

  const AnimatedKeywordText({
    Key? key,
    required this.keywords,
    this.textStyle,
    this.delay = const Duration(seconds: 2),
    this.duration = const Duration(milliseconds: 600),
  }) : super(key: key);

  @override
  State<AnimatedKeywordText> createState() => _AnimatedKeywordTextState();
}

class _AnimatedKeywordTextState extends State<AnimatedKeywordText>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideOut;
  late Animation<Offset> _slideIn;
  late Animation<double> _fadeOut;
  late Animation<double> _fadeIn;

  int _currentIndex = 0;
  int _nextIndex = 1;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _slideOut = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1))
        .animate(CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOut)));

    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut)));

    _slideIn = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.5, 1.0, curve: Curves.easeIn)));

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn)));

    _startLoop();
  }

  void _startLoop() async {
    while (mounted) {
      await Future.delayed(widget.delay);
      _nextIndex = (_currentIndex + 1) % widget.keywords.length;

      setState(() => _isAnimating = true);
      await _controller.forward(from: 0);
      setState(() {
        _currentIndex = _nextIndex;
        _isAnimating = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedText() {
    return AnimatedSize(
      duration: widget.duration,
      curve: Curves.easeInOut,
      child: SizedBox(
        height: 30,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            if (_isAnimating)
              SlideTransition(
                position: _slideOut,
                child: FadeTransition(
                  opacity: _fadeOut,
                  child: Text(
                    widget.keywords[_currentIndex],
                    style: widget.textStyle,
                  ),
                ),
              ),
            SlideTransition(
              position: _isAnimating
                  ? _slideIn
                  : const AlwaysStoppedAnimation(Offset.zero),
              child: FadeTransition(
                opacity:
                    _isAnimating ? _fadeIn : const AlwaysStoppedAnimation(1.0),
                child: Text(
                  widget.keywords[_nextIndex],
                  style: widget.textStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildAnimatedText();
  }
}
