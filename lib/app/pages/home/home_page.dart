// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/classes/month_data_overview.dart';
import 'package:planilla_android/app/core/ui/components/button_with_icon.dart';
import 'package:planilla_android/app/core/ui/components/nav.dart';
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
  bool loading = false;

  Future<void> loadData() async {
    setState(() {
      loading = true;
    });
    List<MonthDataOverview> data =
        await fs.getYearDataOverview('${DateTime.now().year}');
    setState(() {
      yearData = data;
      loading = false;
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
                tooltip: 'Sair',
                onPressed: () {
                  FirebaseAuthServices.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                },
                icon: const Icon(Icons.logout),
                color: Colors.red[400],
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Nav(),
              Padding(
                  padding: const EdgeInsets.only(top: 24.0,bottom: 24.0),
                  child: Text(style: TextStyles.instance.title, 'Visão geral')),
              loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(children: [
                      Tabela(
                          data: yearData,
                          headers: MonthDataOverview.getHeaders()),
                      ButtonWithIcon.primary(
                        iconName: Icons.refresh,
                        onPressed: loadData,
                        outline: true,
                      )
                    ]),
            ],
          ),
        ));
  }
}
