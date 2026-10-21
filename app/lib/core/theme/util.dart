import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme createTextTheme(
  BuildContext context,
  String bodyFontString,
  String displayFontString,
) {
  final TextTheme baseTextTheme = Theme.of(context).textTheme;
  final TextTheme bodyTextTheme = _applyGoogleFont(
    bodyFontString,
    baseTextTheme,
  );
  final TextTheme displayTextTheme = _applyGoogleFont(
    displayFontString,
    baseTextTheme,
  );
  return displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
}

/// Applies a Google Font family to a Flutter [TextTheme] at the [TextStyle]
/// level. [GoogleFonts.getTextTheme] returns `material_ui`'s [TextTheme], which
/// is a different type from Flutter's [TextTheme].
TextTheme _applyGoogleFont(String fontFamily, TextTheme theme) {
  TextStyle? apply(TextStyle? style) =>
      style == null ? null : GoogleFonts.getFont(fontFamily, textStyle: style);

  return theme.copyWith(
    displayLarge: apply(theme.displayLarge),
    displayMedium: apply(theme.displayMedium),
    displaySmall: apply(theme.displaySmall),
    headlineLarge: apply(theme.headlineLarge),
    headlineMedium: apply(theme.headlineMedium),
    headlineSmall: apply(theme.headlineSmall),
    titleLarge: apply(theme.titleLarge),
    titleMedium: apply(theme.titleMedium),
    titleSmall: apply(theme.titleSmall),
    bodyLarge: apply(theme.bodyLarge),
    bodyMedium: apply(theme.bodyMedium),
    bodySmall: apply(theme.bodySmall),
    labelLarge: apply(theme.labelLarge),
    labelMedium: apply(theme.labelMedium),
    labelSmall: apply(theme.labelSmall),
  );
}
