import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:planilla_android/app/core/ui/theme/theme_config.dart';
import 'package:planilla_android/app/pages/add_item/add_item_page.dart';
import 'package:planilla_android/app/pages/backup/backup_page.dart';
import 'package:planilla_android/app/pages/balance/add_balance/add_balance.dart';
import 'package:planilla_android/app/pages/home/home_page.dart';
import 'package:planilla_android/app/pages/login/login_page.dart';
import 'package:planilla_android/app/pages/month_view/month_view.dart';
import 'package:planilla_android/app/pages/queries/queries_page.dart';
import 'package:planilla_android/app/pages/splash/splash_page.dart';

class PlanillaApp extends StatelessWidget {
  const PlanillaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterGetIt(
      
      pages: [
        FlutterGetItPageBuilder(
            page: (context) =>  const SplashPage(), path: '/'),
        FlutterGetItPageBuilder(
            page: (context) => const LoginPage(), path: '/auth/login'),
        FlutterGetItPageBuilder(
            page: (context) => const HomePage(), path: '/home'),
        FlutterGetItPageBuilder(
            page: (context) => const MonthViewPage(), path: '/month'),
        FlutterGetItPageBuilder(
            page: (context) => const AddItemPage(), path: '/add_item'),
        FlutterGetItPageBuilder(
            page: (context) => const BackupPage(), path: '/backup'),
        FlutterGetItPageBuilder(
            page: (context) => const AddBalancePage(), path: '/balance'),
        FlutterGetItPageBuilder(
            page: (context) => const QueryPage(), path: '/queries'),
      ],
      builder: (context, routes, flutterGetItNavObserver) {
        return MaterialApp(
          title: 'Planilla App',
          theme: ThemeConfig.theme,
          navigatorObservers: [flutterGetItNavObserver],
          routes: routes,
        );
      },
    );
  }
}
