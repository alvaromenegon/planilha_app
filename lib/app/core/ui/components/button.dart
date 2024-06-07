import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/ui/styles/button_styles.dart';
import 'package:planilla_android/app/core/ui/styles/text_styles.dart';

class Button extends StatelessWidget {
  final ButtonStyle style;
  final TextStyle labelStyle;
  final String label;
  final double? width;
  final double? height;
  final double padding;
  final VoidCallback? onPressed;
  final bool outline;

  const Button(
      {super.key,
      required this.style,
      required this.labelStyle,
      required this.label,
      this.width,
      this.height,
      this.onPressed,
      this.padding = 8.0,
      this.outline = false});

  Button.primary({
    super.key,
    required this.label,
    this.width,
    this.height,
    this.onPressed,
    this.padding = 8.0,
    this.outline = false,
  })  : style = outline
            ? ButtonStyles.instance.primaryOutline
            : ButtonStyles.instance.primary,
        labelStyle = outline
            ? TextStyles.instance.outlinePrimaryButtonLabel
            : TextStyles.instance.buttonLabel;

  Button.secondary(
      {super.key,
      required this.label,
      this.width,
      this.height,
      this.onPressed,
      this.padding = 8.0,
      this.outline = false})
      : style = outline
            ? ButtonStyles.instance.secondaryOutline
            : ButtonStyles.instance.secondary,
        labelStyle = outline
            ? TextStyles.instance.outlineSecondaryButtonLabel
            : TextStyles.instance.buttonLabel;

  @override
  Widget build(BuildContext context) {
    final labeltext = Text(
      label,
      style: labelStyle,
      overflow: TextOverflow.ellipsis,
    );
    return SizedBox(
        width: width,
        height: height,
        child: outline
            ? Padding(
                padding: EdgeInsets.all(padding),
                child: OutlinedButton(
                  onPressed: onPressed,
                  style: style,
                  child: labeltext,
                ))
            : Padding(
                padding: EdgeInsets.all(padding),
                child: ElevatedButton(
                    onPressed: onPressed, style: style, child: labeltext)));
  }
}
