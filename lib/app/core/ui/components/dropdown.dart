import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/ui/components/label.dart';
import 'package:planilla_android/app/core/ui/styles/colors_app.dart';
import 'package:planilla_android/app/core/ui/theme/theme_config.dart';

class Dropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final String value;
  final void Function(String?) onChanged;
  final MainAxisAlignment mainAxisAlign;
  final CrossAxisAlignment crossAxisAlign;

  const Dropdown({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    this.mainAxisAlign = MainAxisAlignment.spaceBetween,
    this.crossAxisAlign = CrossAxisAlignment.start,
    required this.onChanged,
  });
/*
  _buildDropdownButton(
      List<String> items, String value, void Function(String?) onChanged) {
    return DropdownButton<String>(
      icon: const Icon(Icons.arrow_drop_down_circle_outlined),
      iconEnabledColor: ColorsApp.instance.primary,
      value: value,
      onChanged: onChanged,
      underline: Container(),
      borderRadius: ThemeConfig.defaultBorderRadius,
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      items: items
          .map((String item) => DropdownMenuItem<String>(
                enabled: item == '' ? false : true,
                value: item,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      style: TextStyle(
                        color: item == value
                            ? Colors.black
                            : ColorsApp.instance.secondary,
                      ),
                      item),
                ),
              ))
          .toList(),
    );
  }*/
  _buildDropdownButton(
      List<String> items, String value, void Function(String?) onChanged) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return DropdownButton<String>(
          icon: const Icon(Icons.arrow_drop_down_circle_outlined),
          iconEnabledColor: ColorsApp.instance.primary,
          value: value,
          onChanged: onChanged,
          underline: Container(),
          borderRadius: ThemeConfig.defaultBorderRadius,
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          items: items
              .map((String item) => DropdownMenuItem<String>(
                    enabled: item == '' ? false : true,
                    value: item,
                    child: SizedBox(
                      width: constraints.maxWidth-(8*5), //correção dos valores de padding
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            style: TextStyle(
                              color: item == value
                                  ? Colors.black
                                  : ColorsApp.instance.secondary,
                            ),
                            item),
                      ),
                    ),
                  ))
              .toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: mainAxisAlign,
          crossAxisAlignment: crossAxisAlign,
          children: [
            Label(label),
            DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: ThemeConfig.defaultBorderRadius,
                  border: ThemeConfig.defaultBorder['border'] as Border,
                ),
                child: _buildDropdownButton(items, value, onChanged))
          ],
        ));
  }
}
