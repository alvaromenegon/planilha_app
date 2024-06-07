// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/classes/month_data_overview.dart';
import 'package:planilla_android/app/core/ui/components/button.dart';
import 'package:planilla_android/app/core/ui/components/table.dart';
import 'package:planilla_android/app/core/ui/styles/text_styles.dart';
import 'package:planilla_android/app/services/firebase/firestore_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<MonthDataOverview> yearData = [];
  FirestoreServices fs = FirestoreServices();
  @override
  void initState() {
    super.initState();
    fs
        .getYearDataOverview('${DateTime.now().year}')
        .then((value) => setState(() {
              yearData = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planilla App'),
      ),
      body: Column(
        children: [
          Button.primary(
              label: 'Abrir Planilha',
              onPressed: () {
                Navigator.pushNamed(context, '/month');
              }),
          Text(style: TextStyles.instance.title, 'Visão geral'),
          Tabela(data: yearData, headers: MonthDataOverview.getHeaders()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Button.primary(
                  label: 'Consultas',
                  onPressed: () {
                    Navigator.pushNamed(context, '/queries');
                  }),
              Button.primary(
                  label: 'Ver saldo',
                  onPressed: () {
                    Navigator.pushNamed(context, '/balance');
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
