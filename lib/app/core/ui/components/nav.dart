import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/ui/components/button_with_icon.dart';

class Nav extends StatelessWidget {
  const Nav({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: ButtonWithIcon.primary(
                iconName: Icons.table_chart_outlined,
                outline: true,
                label: 'Abrir',
                onPressed: () {
                  Navigator.pushNamed(context, '/month');
                })),
        Expanded(
            child: ButtonWithIcon.primary(
                iconName: Icons.search_outlined,
                outline: true,
                label: 'Pesquisar',
                onPressed: () {
                  Navigator.pushNamed(context, '/queries');
                })),
        Expanded(
            child: ButtonWithIcon.primary(
                iconName: Icons.backup_outlined,
                outline: true,
                label: 'Backup',
                onPressed: () {
                  Navigator.pushNamed(context, '/backup');
                })),
      ],
    );
  }
}
