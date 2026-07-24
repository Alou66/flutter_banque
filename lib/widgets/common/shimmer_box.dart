import 'package:flutter/material.dart';
import '../../core/theme/app_colors_extension.dart';

/// Rectangle animé (dégradé qui balaie de gauche à droite), brique de base
/// des Skeleton Loaders affichés pendant le chargement.
class ShimmerBox extends StatefulWidget {
  const ShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 8,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = context.appColors.border;
    final highlight = context.appColors.surface;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1 - _controller.value * 3, 0),
              end: Alignment(1 - _controller.value * 3, 0),
              colors: [base, highlight, base],
            ),
          ),
        );
      },
    );
  }
}
