import 'package:flutter/material.dart';

class PressableDeleteButton extends StatefulWidget {
  final double height;
  final double initWidth;
  final double maxWidth;
  final Duration animDuration;
  final Function() onPressAct;
  final Widget child;

  const PressableDeleteButton({
    super.key,
    required this.height,
    required this.initWidth,
    required this.maxWidth,
    required this.animDuration,
    required this.onPressAct,
    required this.child,
  });

  @override
  State<PressableDeleteButton> createState() => _PressableDeleteButtonState();
}

class _PressableDeleteButtonState extends State<PressableDeleteButton>
    with TickerProviderStateMixin {
  late AnimationController _animationSizeController;
  late Animation<double> _animationSize;
  late AnimationController _animationColorController;
  late Animation<Color?> _animationColor;

  @override
  void initState() {
    super.initState();
    _animationSizeController = AnimationController(
      vsync: this,
      duration: widget.animDuration,
    );

    _animationColorController = AnimationController(
      vsync: this,
      duration: widget.animDuration,
    );

    _animationSize = CurvedAnimation(
      parent: _animationSizeController,
      curve: Curves.easeOutQuart,
    )
      ..addListener(() {
        if (_animationSize.value >= 1.0) {
          widget.onPressAct();
          _resetAnimation();
        }
      });

    _animationColor = ColorTween(
      begin: const Color.fromARGB(255, 79, 0, 0),
      end: const Color.fromARGB(255, 183, 0, 0),
    ).animate(_animationColorController);
  }

  void _resetAnimation() {
    _animationSizeController.reset();
    _animationColorController.reset();
  }

  void _pressDownHandler() {
    _animationSizeController.duration = widget.animDuration;
    _animationColorController.duration = widget.animDuration;

    _animationSizeController.forward();
    _animationColorController.forward();
  }

  void _pressUpHandler() {
    _animationSizeController.duration = const Duration(milliseconds: 500);
    _animationColorController.duration = const Duration(milliseconds: 500);

    _animationSizeController.reverse();
    _animationColorController.reverse();
  }

  @override
  void dispose() {
    _animationSizeController.dispose();
    _animationColorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressDownHandler(),
      onTapUp: (_) => _pressUpHandler(),
      onTapCancel: () => _pressUpHandler(),
      child: AnimatedBuilder(
        animation: _animationSize,
        builder: (context, child) {
          return AnimatedBuilder(
            animation: _animationColor,
            builder: (context, child) {
              return Container(
                width: widget.initWidth + (widget.maxWidth * _animationSize.value),
                height: widget.height,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: const Radius.circular(28),
                    bottomRight: const Radius.circular(28),
                    topLeft: Radius.circular(28 * _animationSize.value),
                    bottomLeft: Radius.circular(28 * _animationSize.value),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      _animationColor.value!.withOpacity(.7),
                      _animationColor.value!.withOpacity(_animationSize.value / 1.67),
                    ],
                  ),
                ),
                child: widget.child,
              );
            },
          );
        },
      ),
    );
  }
}
