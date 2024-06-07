import 'package:flutter/material.dart';

class PasswordInput extends StatelessWidget {
  final String label;
  final String value;
  final void Function(String) onChanged;

  const PasswordInput({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextField(
            decoration: InputDecoration(
              fillColor: Colors.grey[200],
            ),
            obscureText: true,
            controller: TextEditingController(text: value),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}