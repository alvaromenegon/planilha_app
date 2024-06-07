import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/ui/styles/colors_app.dart';
import './label.dart';

class Input extends StatefulWidget {
  final String label;
  final String value;
  final String type;
  final bool invalid;
  final void Function(String) onChanged;

  const Input({
    super.key,
    required this.label,
    required this.value,
    this.type = 'text',
    this.invalid = false,
    required this.onChanged,
  });

  @override
  InputState createState() => InputState();
}
class InputState extends State<Input> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  Widget build(BuildContext context) {
    InputDecorationTheme themeData = Theme.of(context).inputDecorationTheme;
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(widget.label),
            TextField(
              decoration: InputDecoration(
                fillColor: widget.invalid ? ColorsApp.instance.error : themeData.fillColor,
              ),
              keyboardType:
                  widget.type == 'number' ? TextInputType.number : TextInputType.text,
              controller: _controller,
              onChanged: widget.onChanged,
            ),
          ],
        ));
  }
}
