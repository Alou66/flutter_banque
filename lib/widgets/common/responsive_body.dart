import 'package:flutter/material.dart';

/// Plafonne la largeur du contenu et le centre horizontalement, pour éviter
/// qu'un écran pensé pour mobile ne s'étire de manière disgracieuse sur
/// tablette. N'a aucun effet visible sur un écran de téléphone classique.
class ResponsiveBody extends StatelessWidget {
  const ResponsiveBody({super.key, required this.child, this.maxWidth = 480});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
