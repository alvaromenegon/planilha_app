import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/ui/styles/colors_app.dart';

class TextStyles{
  static TextStyles? _instance;
  // Avoid self isntance
  TextStyles._();
  static TextStyles get instance{
    _instance??=  TextStyles._();
    return _instance!;
   }
  TextStyle get title => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold
  );

  TextStyle get subtitle => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold
  );

  TextStyle get primary => TextStyle(
    fontSize: 16,
    color: ColorsApp.instance.primary
  );

  TextStyle get success => TextStyle(
    fontSize: 16,
    color: ColorsApp.instance.success
  );

  TextStyle get error => TextStyle(
    fontSize: 16,
    color: ColorsApp.instance.error
  );

  TextStyle get label => const TextStyle(
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.w500
  );

  TextStyle get buttonLabel => const TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.bold
  );

  TextStyle get outlinePrimaryButtonLabel => TextStyle(
    fontSize: 16,
    color: ColorsApp.instance.primary,
    fontWeight: FontWeight.bold
  );

  TextStyle get outlineSecondaryButtonLabel => TextStyle(
    fontSize: 16,
    color: ColorsApp.instance.secondary,
    fontWeight: FontWeight.bold
  );



  // Add more text styles here if needed

}

extension TextStylesExtensions on BuildContext{
  TextStyles get textStyles => TextStyles.instance;
}