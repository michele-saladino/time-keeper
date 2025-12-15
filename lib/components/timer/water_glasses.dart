import 'package:flutter/material.dart';

class WaterGlasses extends StatefulWidget {
  const WaterGlasses({super.key, required this.numberOfGlasses, this.removeGlass});

  final int numberOfGlasses;
  final VoidCallback? removeGlass;

  @override
  State<WaterGlasses> createState() => _WaterGlassesState();
}

class _WaterGlassesState extends State<WaterGlasses> {
  final List<int> _glassIds = [];
  final Set<int> _exitingGlassIds = {};
  int _nextId = 0;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.numberOfGlasses; i++) {
      _glassIds.add(_nextId++);
    }
  }

  @override
  void didUpdateWidget(covariant WaterGlasses oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.numberOfGlasses != widget.numberOfGlasses) {
      _updateGlasses();
    }
  }

  void _updateGlasses() {
    final currentCount = _glassIds.length - _exitingGlassIds.length;
    final targetCount = widget.numberOfGlasses;

    if (targetCount > currentCount) {
      int toAdd = targetCount - currentCount;
      for (int i = 0; i < toAdd; i++) {
        _glassIds.add(_nextId++);
      }
    } else if (targetCount < currentCount) {
      int toRemove = currentCount - targetCount;
      for (int i = _glassIds.length - 1; i >= 0 && toRemove > 0; i--) {
        int id = _glassIds[i];
        if (!_exitingGlassIds.contains(id)) {
          _exitingGlassIds.add(id);
          toRemove--;

          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              setState(() {
                _glassIds.remove(id);
                _exitingGlassIds.remove(id);
              });
            }
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _glassIds.map((id) {
        return _AnimatedGlass(
          key: ValueKey(id),
          isExiting: _exitingGlassIds.contains(id),
          onTap: () {
            if (widget.removeGlass != null) {
              widget.removeGlass!();
            }
          },
        );
      }).toList(),
    );
  }
}

class _AnimatedGlass extends StatefulWidget {
  final bool isExiting;
  final VoidCallback onTap;

  const _AnimatedGlass({
    super.key,
    required this.isExiting,
    required this.onTap,
  });

  @override
  State<_AnimatedGlass> createState() => _AnimatedGlassState();
}

class _AnimatedGlassState extends State<_AnimatedGlass>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void didUpdateWidget(_AnimatedGlass oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExiting && !oldWidget.isExiting) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: GestureDetector(
        onTap: widget.onTap,
        child: const Icon(Icons.local_drink, color: Colors.white, size: 18),
      ),
    );
  }
}