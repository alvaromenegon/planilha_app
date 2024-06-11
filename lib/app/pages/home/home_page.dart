// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/classes/month_data_overview.dart';
import 'package:planilla_android/app/core/ui/components/button.dart';
import 'package:planilla_android/app/core/ui/components/table.dart';
import 'package:planilla_android/app/core/ui/styles/text_styles.dart';
import 'package:planilla_android/app/services/firebase/firebase_authentication.dart';
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

  Future<void> loadData() async {
    List<MonthDataOverview> data =
        await fs.getYearDataOverview('${DateTime.now().year}');
    setState(() {
      yearData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Spacer(),
              const Text('Planilla'),
              const Spacer(),
              IconButton(
                onPressed: () {
                  FirebaseAuthServices.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Button.primary(
                  label: 'Abrir Planilha',
                  onPressed: () {
                    Navigator.pushNamed(context, '/month');
                  }),
              Text(style: TextStyles.instance.title, 'Visão geral'),
              Tabela(data: yearData, headers: MonthDataOverview.getHeaders()),
              Button.primary(
                label: 'Atualizar',
                onPressed: loadData,
                outline: true,
              ),
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
              Platform.isAndroid
                  ? Button.secondary(
                      label: 'Backup',
                      onPressed: () async {
                        Navigator.pushNamed(context, '/backup');
                      },
                    )
                  : Container(),
            ],
          ),
        ));
  }
}
