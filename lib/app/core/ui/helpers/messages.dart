import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/ui/styles/colors_app.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

mixin Message<T extends StatefulWidget> on State<T> {
  void showError(String message){
    showTopSnackBar(Overlay.of(context), CustomSnackBar.error(message: message,
    backgroundColor: context.colors.primary,
    ));
  }
  void showInfo(String message){
    showTopSnackBar(Overlay.of(context), CustomSnackBar.info(message: message));
  }

  void showSuccess(String message){
    showTopSnackBar(Overlay.of(context),
    CustomSnackBar.success(message: message));
  }
}