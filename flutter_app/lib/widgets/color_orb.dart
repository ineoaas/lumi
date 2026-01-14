import 'package:flutter/material.dart';

class ColorOrb extends StatefulWidget {
  final Color color;
  final double size;
  final Duration animationDuration;

  const ColorOrb({
    Key? key,
    required this.color,
    this.size = 150.0,
    this.animationDuration = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  State<ColorOrb> createState() => _ColorOrbState();
}

class _ColorOrbState extends State<ColorOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  Color? _previousColor;

  @override
  void initState() {
    super.initState();
    _previousColor = widget.color;
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(ColorOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) {
      _previousColor = oldWidget.color;
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedContainer(
            duration: widget.animationDuration,
            curve: Curves.easeInOutCubic,
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
                BoxShadow(
                  color: widget.color.withOpacity(0.2),
                  blurRadius: 50,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
