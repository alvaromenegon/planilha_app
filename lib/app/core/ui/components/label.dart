import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/ui/styles/text_styles.dart';

class Label extends StatelessWidget {
  final String label;
  final TextStyle? style;

  const Label(this.label, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(label, style: style ?? TextStyles.instance.label);
  }
}
