import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/classes/item.dart';
import 'package:planilla_android/app/core/ui/components/button.dart';
import 'package:planilla_android/app/core/ui/components/dropdown.dart';
import 'package:planilla_android/app/core/ui/components/table.dart';
import 'package:planilla_android/app/services/firebase/firestore_services.dart';
import 'package:planilla_android/app/util/date_util.dart';

class MonthViewPage extends StatefulWidget {
  const MonthViewPage({super.key});

  @override
  MonthViewPageState createState() => MonthViewPageState();
}

class MonthViewPageState extends State<MonthViewPage> {
  String selectedMonth = DateTime.now().month.toString();
  String selectedYear = DateTime.now().year.toString();
  List<Item> monthData = [];
  

  void updateData(String year, String month) async {
    List<Item> data = await FirestoreServices().getItems(year, month);
    setState(() {
      monthData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    updateData(selectedYear, selectedMonth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Gastos do mês'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Dropdown(
                        label: 'Mês',
                        items: DateUtil.months,
                        value: DateUtil.getMonth(selectedMonth) ,//_months[int.parse(selectedMonth) - 1],
                        onChanged: (value) {
                          setState(() {
                            selectedMonth =
                                DateUtil.getMonthNumberAsString(value!);
                          });
                        }),
                  ),
                  Expanded(
                    child: Dropdown(
                        label: 'Ano',
                        items: DateUtil.generateYears(),
                        value: selectedYear,
                        onChanged: (value) {
                          setState(() {
                            selectedYear = value!;
                          });
                        }),
                  ),
                ],
              ),
              Button.secondary(
                label: 'Escolher',
                onPressed: () {
                  updateData(selectedYear, selectedMonth);
                },
              ),
              Tabela(data: monthData, headers: Item.getHeaders(), showIndex: true),
              Button.primary(
                label: 'Adicionar Item',
                onPressed: () {
                  Navigator.pushNamed(context, '/add_item');
                },
              )
            ],
          ),
        ));
  }
}
