import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({super.key, this.height = 160, this.padding, this.radius});
  final double height;
  final EdgeInsetsGeometry? padding;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    Image logo = Image.asset('assets/images/icon.png', height: height);
    if (padding != null) {
      return Padding(padding: padding!, child: logo);
    }
    if (radius != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius!),
        child: logo,
      );
    }
    return logo;
  }
}
