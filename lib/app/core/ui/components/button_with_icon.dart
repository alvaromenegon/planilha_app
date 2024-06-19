import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/ui/styles/button_styles.dart';
import 'package:planilla_android/app/core/ui/styles/colors_app.dart';
import 'package:planilla_android/app/core/ui/styles/text_styles.dart';

class ButtonWithIcon extends StatelessWidget {
  final ButtonStyle style;
  final IconData iconName;
  final String? label;
  final String? labelPosition;
  final double? labelSize;
  final Color? labelColor;
  final double? width;
  final double? height;
  final double padding;
  final VoidCallback? onPressed;
  final bool outline;

  const ButtonWithIcon(
      {super.key,
      required this.style,
      this.label,
      required this.iconName,
      this.labelPosition,
      this.labelColor = Colors.black,
      this.width,
      this.height,
      this.onPressed,
      this.padding = 8.0,
      this.outline = false,
      this.labelSize = 10.0});

  ButtonWithIcon.primary({
    super.key,
    this.label,
    required this.iconName,
    this.labelPosition = 'bottom',
    this.labelSize = 10.0,
    this.width,
    this.height,
    this.onPressed,
    this.padding = 8.0,
    this.outline = false,
  }) : style = outline
            ? ButtonStyles.instance.primaryOutline
            : ButtonStyles.instance.primary,
        labelColor = outline ? ColorsApp.instance.primary : Colors.white;

  ButtonWithIcon.secondary(
      {super.key,
      this.label,
      required this.iconName,
      this.labelPosition = 'bottom',
      this.labelSize = 10.0,
      this.width,
      this.height,
      this.onPressed,
      this.padding = 8.0,
      this.outline = false})
      : style = outline
            ? ButtonStyles.instance.secondaryOutline
            : ButtonStyles.instance.secondary,
            labelColor = outline ? ColorsApp.instance.secondary : Colors.white;

  ButtonWithIcon.onPrimary(
      {super.key,
      this.label,
      required this.iconName,
      this.labelPosition = 'bottom',
      this.labelSize = 10.0,
      this.labelColor = Colors.white,
      this.width,
      this.height,
      this.onPressed,
      this.padding = 8.0,
      this.outline = false})
      : style = ButtonStyles.instance.onPrimary;

  ButtonWithIcon.danger(
      {super.key,
      this.label,
      required this.iconName,
      this.labelPosition = 'bottom',
      this.labelSize = 10.0,
      this.width,
      this.height,
      this.onPressed,
      this.padding = 8.0,
      this.outline = false})
      : style = outline ?
            ButtonStyles.instance.dangerOutline
            : ButtonStyles.instance.danger,
        labelColor = outline ? Colors.red[400] : Colors.white;

  Widget positionLabel() {
    final icon = Icon(iconName,
        color: labelColor);
    if (label == null) {
      return icon;
    }
    final labeltext = Padding(padding: const EdgeInsets.only(top: 2.0) ,
    child: Text(
      label!,
      style: outline
          ? TextStyles.instance.buttonLabel
              .copyWith(fontSize: labelSize, color: labelColor)
          : TextStyles.instance.buttonLabel.copyWith(fontSize: labelSize),
    ));
    switch (labelPosition) {
      case 'top':
        return Column(
          children: [labeltext, icon],
        );
      case 'bottom':
        return Column(
          children: [icon, labeltext],
        );
      case 'left':
        return Row(
          children: [labeltext, icon],
        );
      case 'right':
        return Row(
          children: [icon, labeltext],
        );
      default:
        return Column(
          children: [icon, labeltext],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: outline
            ? Padding(
                padding: EdgeInsets.all(padding),
                child: OutlinedButton(
                    onPressed: onPressed, style: style, child: positionLabel()))
            : Padding(
                padding: EdgeInsets.all(padding),
                child: ElevatedButton(
                    onPressed: onPressed,
                    style: style,
                    child: positionLabel())));
  }
}
