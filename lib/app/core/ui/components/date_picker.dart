import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/ui/components/button.dart';
import 'package:planilla_android/app/core/ui/styles/button_styles.dart';
import 'package:planilla_android/app/core/ui/styles/text_styles.dart';

class DatePicker extends StatelessWidget {
  final String label;
  final String selectedDate;
  final void Function(String) onChanged;
  const DatePicker({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Button(
          style: context.buttonStyles.primaryOutline,
          labelStyle: context.textStyles.outlinePrimaryButtonLabel,
          label: label,
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            ).then((value) {
              if (value != null) {
                String dateString = '${value.toLocal()}'.split(' ')[0];
                onChanged(dateString);
              }
            });
          },
        ),
        Text(selectedDate)
      ],
    );
  }
}
