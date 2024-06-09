import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/ui/components/label.dart';
import 'package:planilla_android/app/core/ui/styles/colors_app.dart';
import 'package:planilla_android/app/core/ui/theme/theme_config.dart';

class Dropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final String value;
  final void Function(String?) onChanged;
  final bool expand;
  final MainAxisAlignment mainAxisAlign;
  final CrossAxisAlignment crossAxisAlign;

  const Dropdown({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    this.expand = false,
    this.mainAxisAlign = MainAxisAlignment.spaceBetween,
    this.crossAxisAlign = CrossAxisAlignment.start,
    required this.onChanged,
  });

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
                enabled: item==''?false:true,
                value: item,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    style: TextStyle(
                      color: item==value?Colors.black:ColorsApp.instance.secondary,
                    ),
                    item),
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!expand) {
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
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Label(label),
            DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: _buildDropdownButton(items, value, onChanged))
            //_buildDropdownButton(items, value, onChanged),
          ],
        ));
  }
}
