import 'package:flutter/material.dart';

class Progress extends StatelessWidget{
  final double progress;
  final bool loading;
  final String? message;

  const Progress({super.key, required this.progress, required this.loading, this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(value: progress),
        if (message != null) Text(message!),
      ],
    );
  }
}