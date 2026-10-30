import 'package:flutter/material.dart';

extension ColorSchemeExtension on BuildContext {
  /// Extension that gives us access to the color's for the application with respect to the Material Design theme
  ///
  /// [Official Usage Documentation](https://m3.material.io/styles/color/system/how-the-system-works)
  ColorScheme get colors => Theme.of(this).colorScheme;
}
