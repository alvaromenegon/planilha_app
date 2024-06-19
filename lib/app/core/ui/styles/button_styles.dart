import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/ui/styles/colors_app.dart';
import 'package:planilla_android/app/core/ui/styles/text_styles.dart';

class ButtonStyles{
  static ButtonStyles? _instance;
  ButtonStyles._();
  static ButtonStyles get instance{
    _instance ??= ButtonStyles._();
    return _instance!;
  }


  ButtonStyle get primary => ElevatedButton.styleFrom(
    backgroundColor: ColorsApp.instance.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15)
    ),
    textStyle: TextStyles.instance.label
  );

  ButtonStyle get secondary => ElevatedButton.styleFrom(
    backgroundColor: ColorsApp.instance.secondary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15)
    ),
    textStyle: TextStyles.instance.label
  );

  ButtonStyle get primaryOutline => OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    side: BorderSide(
      color: ColorsApp.instance.primary,
    ),
    textStyle: TextStyles.instance.label.copyWith(
      color: ColorsApp.instance.primary
    )
  );

  ButtonStyle get secondaryOutline => OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    side: BorderSide(
      color: ColorsApp.instance.secondary,
    ),
    textStyle: TextStyles.instance.label.copyWith(
      color: ColorsApp.instance.secondary
    )
  );

  ButtonStyle get danger => ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15)
    ),
    textStyle: TextStyles.instance.label
  );

  ButtonStyle get dangerOutline => OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    side: const BorderSide(
      color: Colors.red,
    ),
    textStyle: TextStyles.instance.label.copyWith(
      color: Colors.red[400]
    )
  );

  ButtonStyle get onPrimary => ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    side: const BorderSide(
      color: Colors.white,
    ),
    textStyle: TextStyles.instance.label.copyWith(
      color: Colors.white
    ),
  );
}

extension ButtonStylesExtensions on BuildContext{
  ButtonStyles get buttonStyles => ButtonStyles.instance;
}