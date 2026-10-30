import 'package:app/core/widgets/extensions.dart';
import 'package:flutter/material.dart';

enum ButtonType { primary, secondary, error }

/// A custom button widget that can be used throughout the app. For primary actions, use [ButtonType.primary], for secondary actions, use [ButtonType.secondary], and for error actions, use [ButtonType.error].
class Button extends StatelessWidget {
  const Button({
    this.buttonType = ButtonType.primary,
    required this.text,
    required this.onClick,
    this.disabled = false,
    this.width,
    this.height,
    super.key,
  });

  final ButtonType buttonType;
  final void Function()? onClick;
  final String text;
  final bool disabled;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final Color disabledBackgroundColor =
        context.colors.surfaceContainerHighest;

    final Widget button = switch (buttonType) {
      ButtonType.primary => FilledButton(
        onPressed: disabled ? null : onClick,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            disabled ? disabledBackgroundColor : context.colors.primary,
          ),
          foregroundColor: WidgetStatePropertyAll(context.colors.primary),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          // Set minimum size if height is provided
          minimumSize: height != null
              ? WidgetStatePropertyAll(Size(0, height!))
              : null,
        ),
        child: Text(text, style: TextStyle(color: context.colors.onPrimary)),
      ),
      ButtonType.secondary => OutlinedButton(
        onPressed: onClick,
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: context.colors.secondary),
            ),
          ),
          foregroundColor: WidgetStatePropertyAll(context.colors.secondary),
          // Set minimum size if height is provided
          minimumSize: height != null
              ? WidgetStatePropertyAll(Size(0, height!))
              : null,
        ),
        child: Text(text, style: TextStyle(color: context.colors.onSurface)),
      ),
      ButtonType.error => FilledButton(
        onPressed: disabled ? null : onClick,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            disabled ? disabledBackgroundColor : context.colors.error,
          ),
          foregroundColor: WidgetStatePropertyAll(
            disabled
                ? context.colors.onSurface.withValues(alpha: 0.38)
                : context.colors.onError,
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          // Set minimum size if height is provided
          minimumSize: height != null
              ? WidgetStatePropertyAll(Size(0, height!))
              : null,
        ),
        child: Text(text),
      ),
    };

    // Wrap with SizedBox if width or height is specified
    if (width != null || height != null) {
      return SizedBox(width: width, height: height, child: button);
    }

    return button;
  }
}
