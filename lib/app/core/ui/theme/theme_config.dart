import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/ui/styles/colors_app.dart';
import 'package:planilla_android/app/core/ui/styles/text_styles.dart';

// Alterações nas configurações de tema
// precisam que o app seja reiniciado
// ou dar restart no debugger
// para que as alterações tenham efeito

class ThemeConfig {
  ThemeConfig._();

  static final defaultBorderRadius = BorderRadius.circular(18);
  static final defaultBorder = {
    'border': Border.all(color: ColorsApp.instance.primary, width: 1),
    'borderSide': BorderSide(color: ColorsApp.instance.primary, width: 1)
  };

  static final _defaultInputBorder = OutlineInputBorder(
      borderRadius: defaultBorderRadius,
      borderSide: defaultBorder['borderSide'] as BorderSide);

  static final theme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: ColorsApp.instance.primary,
      elevation: 1,
      titleTextStyle: TextStyles.instance.title,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    primaryColor: ColorsApp.instance.primary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorsApp.instance.primary,
      primary: ColorsApp.instance.primary,
      secondary: ColorsApp.instance.secondary,
    ),
    inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.white,
        filled: true,
        isDense: true,
        contentPadding: const EdgeInsets.all(13),
        border: _defaultInputBorder,
        enabledBorder: _defaultInputBorder,
        focusedBorder: _defaultInputBorder,
        labelStyle: TextStyles.instance.label,
      ),
  );
}
