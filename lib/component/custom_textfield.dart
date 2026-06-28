import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/constants/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LabelTextFormField extends StatefulWidget {
  final bool noBorder;
  final bool readOnly;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final Function()? onEditingComplete;
  final ValueChanged<String?>? onSaved;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? labelText;
  final bool obscureText;
  final TextEditingController? controller;
  final String? initialValue;
  final bool autocorrect;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? prefix;
  final TextInputType keyboardType;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final bool enableInteractiveSelection;
  final GestureTapCallback? onTap;
  final bool enabled;
  final TextAlign textAlign;
  final String? errorText;
  final String? counterText;
  final String? helperText;
  final bool expanded;
  final int maxLines;
  final int? minLines;
  final EdgeInsets? contentPadding;
  final TextAlignVertical? textAlignVertical;
  final Widget? suffix;
  final double radius;
  final String? Function(String?)? validator;
  final bool hideCounter;
  final String? prefixText;
  final String? suffixText;
  final TextStyle? prefixStyle;
  final bool hasFloatingPlaceholder;
  final TextStyle? style;
  final TextStyle? labelstyle;
  final Color? fillColor;
  final bool isSmsListener;
  final bool trim;
  final bool hideBorders;
  final bool isRequired;
  final Color? cursorColor;
  final bool isProfile;
  final TextCapitalization textCapitalization;
  final bool useSpace;
  final AutovalidateMode? autovalidateMode;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final double borderWidth;
  final double focusedBorderWidth;

  const LabelTextFormField(
      {super.key,
      this.cursorColor,
      this.isProfile = false,
      this.readOnly = false,
      this.hideBorders = false,
      this.autovalidateMode = AutovalidateMode.onUserInteraction,
      this.useSpace = true,
      this.focusNode,
      this.onChanged,
      this.onSaved,
      this.hintText,
      this.labelText,
      this.obscureText = false,
      this.controller,
      this.autocorrect = true,
      this.suffixIcon,
      this.prefixIcon,
      this.prefix,
      this.keyboardType = TextInputType.text,
      this.maxLength,
      this.inputFormatters,
      this.textInputAction,
      this.autofocus = false,
      this.enableInteractiveSelection = true,
      this.onTap,
      this.enabled = true,
      this.textAlign = TextAlign.start,
      this.errorText,
      this.counterText,
      this.helperText,
      this.expanded = false,
      this.maxLines = 1,
      this.minLines,
      this.contentPadding,
      this.textAlignVertical,
      this.suffix,
      this.radius = 30,
      this.validator,
      this.hideCounter = false,
      this.initialValue,
      this.prefixText,
      this.suffixText,
      this.hasFloatingPlaceholder = false,
      this.prefixStyle,
      this.style,
      this.fillColor,
      this.isSmsListener = false,
      this.hintStyle,
      this.trim = false,
      this.isRequired = false,
      this.noBorder = false,
      this.labelstyle,
      this.onEditingComplete,
      this.textCapitalization = TextCapitalization.none,
      this.borderColor,
      this.focusedBorderColor,
      this.errorBorderColor,
      this.borderWidth = 1,
      this.focusedBorderWidth = 1});

  @override
  State<LabelTextFormField> createState() => _LabelTextFormFieldState();
}

class _LabelTextFormFieldState extends State<LabelTextFormField> {
  final TextEditingController _textController = TextEditingController(text: '');

  Color get _defaultBorderColor => widget.isProfile
      ? const Color.fromRGBO(47, 47, 47, 1)
      : AppColors.primaryColor;

  OutlineInputBorder _border({
    Color? color,
    double? width,
  }) =>
      OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(widget.isProfile ? 12 : widget.radius),
        borderSide: BorderSide(
          color: color ?? widget.borderColor ?? _defaultBorderColor,
          width: widget.hideBorders ? 0 : width ?? widget.borderWidth,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.labelText == null
            ? const SizedBox.shrink()
            : Text(
                widget.labelText!,
                style: widget.labelstyle ??
                    context.textTheme.bodyMedium!.copyWith(
                      color: AppColors.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
              ),
        widget.labelText == null
            ? const SizedBox.shrink()
            : const SizedBox(
                height: 10,
              ),
        TextFormField(
          // obscuringCharacter: '●',
          autovalidateMode: widget.autovalidateMode,
          cursorColor: widget.cursorColor ?? AppColors.primaryColor,
          textCapitalization: widget.textCapitalization,
          validator: widget.validator,
          focusNode: widget.focusNode,
          expands: widget.expanded,
          controller:
              widget.isSmsListener ? _textController : widget.controller,
          initialValue: widget.initialValue,
          autocorrect: widget.autocorrect,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          enabled: widget.enabled,
          textAlign: widget.textAlign,
          textAlignVertical: widget.textAlignVertical,
          obscureText: widget.obscureText,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          readOnly: widget.readOnly,
          decoration: InputDecoration(
            errorStyle: context.textTheme.bodyMedium!.copyWith(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: widget.fillColor ?? AppColors.backgroundColor,
            prefixText: widget.prefixText,
            suffixText: widget.suffixText,
            prefixStyle: widget.prefixStyle,
            prefixIcon: widget.prefixIcon,
            prefix: widget.prefix,
            suffixIcon: widget.suffixIcon,
            suffix: widget.suffix,
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 13,
                ),
            errorText: widget.errorText,
            counterText: widget.counterText,
            counterStyle: const TextStyle(fontSize: 14),
            helperText: widget.helperText,
            hintText: widget.isRequired
                ? ("${_capitalizeFirstLetter(widget.hintText)}*")
                : _capitalizeFirstLetter(widget.hintText),
            hintStyle:
                //  widget.hintStyle ??
                context.textTheme.bodyMedium!.copyWith(
              fontFamily: AppFonts.spaceGrotesk,
              letterSpacing: 0,
              color: AppColors.textGrey,
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
            floatingLabelBehavior: widget.hasFloatingPlaceholder
                ? FloatingLabelBehavior.always
                : FloatingLabelBehavior.never,
            border: widget.noBorder ? InputBorder.none : _border(),
            focusedBorder: widget.noBorder
                ? InputBorder.none
                : _border(
                    color: widget.focusedBorderColor,
                    width: widget.focusedBorderWidth,
                  ),
            enabledBorder: widget.noBorder ? InputBorder.none : _border(),
            disabledBorder: widget.noBorder ? InputBorder.none : _border(),
            errorBorder: widget.noBorder
                ? InputBorder.none
                : _border(color: widget.errorBorderColor ?? Colors.redAccent),
            focusedErrorBorder: widget.noBorder
                ? InputBorder.none
                : _border(
                    color: widget.errorBorderColor ?? Colors.redAccent,
                    width: widget.focusedBorderWidth,
                  ),
          ),
          style: widget.style ??
              context.textTheme.bodyMedium!
                  .copyWith(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  )
                  .copyWith(
                    letterSpacing: widget.obscureText ? 0.0 : 0.0,
                  ),
          onSaved: widget.onSaved,
          onEditingComplete: widget.onEditingComplete,
          textInputAction: widget.textInputAction,
          autofocus: widget.autofocus,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          onTap: widget.onTap,
        ),
        widget.useSpace
            ? const SizedBox(
                height: 18,
              )
            : const SizedBox.shrink()
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  String? _capitalizeFirstLetter(String? text) {
    if (text == null || text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
