import 'package:flutter/material.dart';

class NumberScroll extends StatefulWidget {
  final int value;
  final TextStyle? style;
  final Duration duration;

  const NumberScroll({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<NumberScroll> createState() => _NumberScrollState();
}

class _NumberScrollState extends State<NumberScroll> {
  int _oldValue = 0;

  @override
  void didUpdateWidget(covariant NumberScroll oldWidget) {
    if (widget.value != oldWidget.value) {
      _oldValue = oldWidget.value;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.duration,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final isIncrement = widget.value > _oldValue;
        final isNew = child.key == ValueKey(widget.value);
        final offsetAnimation = Tween<Offset>(
          begin: isNew
              ? (isIncrement ? const Offset(0, 1) : const Offset(0, -1))
              : (isIncrement ? const Offset(0, -1) : const Offset(0, 1)),
          end: Offset.zero,
        ).animate(animation);

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      },
      child: Text(
        '${widget.value}',
        key: ValueKey<int>(widget.value),
        style: widget.style ?? Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}