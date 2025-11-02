import 'package:diet_lenz/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ButtonVariant {
  filled,
  outline,
}

enum ButtonSize {
  small,
  medium,
  large,
}

class CustomYafButton extends StatefulWidget {
  final String text;
  final ButtonVariant variant;
  final ButtonSize size;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? color;
  final Color? borderColor;
  final Color textColor;
  final double width;
  final double height;
  final bool isDisabled;
  final double radius;
  final double? fontSize;
  final Widget? iconWidget;
  final FontWeight? weight;
  final bool iconPositionLeft;
  final AppHapticFeedbackType feedbackType;

  const CustomYafButton({
    super.key,
    required this.text,
    this.iconPositionLeft = true,
    this.iconWidget,
    this.fontSize,
    this.isDisabled = false,
    this.textColor = Colors.white,
    this.variant = ButtonVariant.filled,
    this.size = ButtonSize.medium,
    this.onPressed,
    this.isLoading = false,
    this.color = AppColors.primaryColor,
    this.borderColor,
    this.radius = 12,
    this.width = 154,
    this.height = 50,
    this.weight,
    this.feedbackType = AppHapticFeedbackType.mediumImpact,
  });

  @override
  State<CustomYafButton> createState() => _CustomYafButtonState();
}

class _CustomYafButtonState extends State<CustomYafButton> {
  @override
  Widget build(BuildContext context) {
    bool isDisabled = widget.onPressed == null;
    // Default color is primary color if not specifie
    final defaultColor = Theme.of(context).primaryColor;
    final buttonBackgroundColor = widget.color ?? defaultColor;
    // Define size mappings
    final Map<ButtonSize, double> heightMap = {
      ButtonSize.small: 32,
      ButtonSize.medium: 44,
      ButtonSize.large: 52,
    };

    final Map<ButtonSize, EdgeInsets> paddingMap = {
      ButtonSize.small: const EdgeInsets.symmetric(horizontal: 12),
      ButtonSize.medium: const EdgeInsets.symmetric(horizontal: 16),
      ButtonSize.large: const EdgeInsets.symmetric(horizontal: 24),
    };

    final Map<ButtonSize, double> fontSizeMap = {
      ButtonSize.small: 14,
      ButtonSize.medium: 16,
      ButtonSize.large: 18,
    };

    // Build the button based on variant
    Widget button;
    switch (widget.variant) {
      case ButtonVariant.filled:
        button = ElevatedButton(
          onPressed: widget.isLoading || isDisabled
              ? null
              : () {
                  HapticService.feedback(widget.feedbackType);
                  if (widget.onPressed != null) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    widget.onPressed!();
                  }
                },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return Color.fromRGBO(204, 204, 204, 1);
                }
                return widget.color!;
              },
            ),
            foregroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                return Colors.white;
              },
            ),
            elevation: WidgetStateProperty.resolveWith<double>(
              (Set<WidgetState> states) {
                return states.contains(WidgetState.pressed) ? 2 : 0;
              },
            ),
            padding: WidgetStateProperty.all(paddingMap[widget.size]),
            minimumSize:
                WidgetStateProperty.all(Size(widget.width, widget.height)),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                side: BorderSide(
                  color: isDisabled
                      ? widget.color!.withOpacity(0.3)
                      : widget.borderColor ?? widget.color!,
                  width: isDisabled ? 0 : 1.0,
                ),
                borderRadius: BorderRadius.circular(widget.radius),
              ),
            ),
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return Colors.white.withOpacity(0.1);
                }
                if (states.contains(WidgetState.hovered)) {
                  return Colors.white.withOpacity(0.05);
                }
                return null;
              },
            ),
          ).copyWith(
            // Override the theme's button style
            elevation: MaterialStateProperty.all(0),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
          ),
          child: _buildChild(widget.textColor, isDisabled),
        );
        break;

      case ButtonVariant.outline:
        button = OutlinedButton(
          onPressed: widget.isLoading || isDisabled ? null : widget.onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            side: BorderSide(color: widget.color ?? Colors.white),
            padding: paddingMap[widget.size],
            minimumSize: Size(widget.width, widget.height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.radius),
            ),
          ),
          child: _buildChild(widget.textColor, isDisabled),
        );
        break;
    }

    return button;
  }

  Widget _buildChild(Color textColor, bool isDisabled) {
    if (widget.isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.variant == ButtonVariant.filled
                ? Colors.white
                : widget.color ?? Colors.blue,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.iconWidget != null && widget.iconPositionLeft)
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: widget.iconWidget!,
          ),
        Text(
          widget.text,
          style: TextStyle(
            fontSize: widget.fontSize ?? 15,
            color: isDisabled ? AppColors.white : textColor,
            fontWeight: widget.weight ?? FontWeight.w400,
          ),
        ),
        if (widget.iconWidget != null && !widget.iconPositionLeft)
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: widget.iconWidget!,
          ),
      ],
    );
  }
}

class HapticService {
  static void feedback(AppHapticFeedbackType type) {
    switch (type) {
      case AppHapticFeedbackType.lightImpact:
        HapticFeedback.lightImpact();
        break;
      case AppHapticFeedbackType.mediumImpact:
        HapticFeedback.mediumImpact();
        break;
      case AppHapticFeedbackType.heavyImpact:
        HapticFeedback.heavyImpact();
        break;
      case AppHapticFeedbackType.selectionClick:
        HapticFeedback.selectionClick();
        break;
      case AppHapticFeedbackType.vibrate:
        HapticFeedback.vibrate();
        break;
    }
  }
}

// First, define the enum for different feedback types
enum AppHapticFeedbackType {
  lightImpact,
  mediumImpact,
  heavyImpact,
  selectionClick,
  vibrate,
}
