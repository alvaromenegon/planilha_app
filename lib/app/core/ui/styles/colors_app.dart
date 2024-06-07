import 'package:flutter/material.dart';

class ColorsApp{
  static ColorsApp? _instance;
  ColorsApp._();
  static ColorsApp get instance{
    _instance ??= ColorsApp._();
    return _instance!;
  }

  Color get primary => const Color(0xFF0D47A1); 
  Color get secondary => const Color(0xFF42A5F5);
  Color get error => const Color(0xFFD32F2F);
  Color get success => const Color(0xFF388E3C);
}

extension ColorsExtensions on BuildContext{
  ColorsApp get colors => ColorsApp.instance;
}