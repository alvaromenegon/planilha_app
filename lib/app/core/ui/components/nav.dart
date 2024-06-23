import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/ui/components/button_with_icon.dart';
import 'package:planilla_android/app/core/ui/styles/colors_app.dart';
import 'package:universal_platform/universal_platform.dart';

class Nav extends StatelessWidget {
  const Nav({super.key});

  @override
  Widget build(BuildContext context) {
    bool isWeb = UniversalPlatform.isWeb;
    List<Widget> navItems = [
      ButtonWithIcon.onPrimary(
          iconName: Icons.table_chart_outlined,
          outline: true,
          label: 'Abrir',
          onPressed: () {
            Navigator.pushNamed(context, '/month');
          }),
      ButtonWithIcon.onPrimary(
          iconName: Icons.search_outlined,
          outline: true,
          label: 'Pesquisar',
          onPressed: () {
            Navigator.pushNamed(context, '/queries');
          }),
      ButtonWithIcon.onPrimary(
          iconName: Icons.backup_outlined,
          outline: true,
          label: 'Backup',
          onPressed: () {
            Navigator.pushNamed(context, '/backup');
          })
    ];
    return DecoratedBox(
        decoration: BoxDecoration(
          color: ColorsApp.instance.primary,
        ),
        child: Row(
          mainAxisAlignment: UniversalPlatform.isAndroid
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.spaceEvenly,
          children: [
            isWeb ? navItems[0] : Expanded(child: navItems[0]),
            isWeb ? navItems[1] : Expanded(child: navItems[1]),
            if (UniversalPlatform.isAndroid) Expanded(child: navItems[2]),
          ],
        ));
  }
}
