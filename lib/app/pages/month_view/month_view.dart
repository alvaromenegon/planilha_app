import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/classes/item.dart';
import 'package:planilla_android/app/core/ui/components/button.dart';
import 'package:planilla_android/app/core/ui/components/dropdown.dart';
import 'package:planilla_android/app/core/ui/components/table.dart';
import 'package:planilla_android/app/services/firebase/firestore_services.dart';

class MonthViewPage extends StatefulWidget {
  const MonthViewPage({super.key});

  @override
  MonthViewPageState createState() => MonthViewPageState();
}

class MonthViewPageState extends State<MonthViewPage> {
  String selectedMonth = DateTime.now().month.toString();
  String selectedYear = DateTime.now().year.toString();
  List<Item> monthData = [];
  final List<String> _months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];
  final List<String> _years = List.generate(
      2025 // Max year to show in the dropdown
          -
          2024 +
          1,
      (i) => (2024 + i).toString());

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
                        items: _months,
                        value: _months[int.parse(selectedMonth) - 1],
                        onChanged: (value) {
                          setState(() {
                            selectedMonth =
                                (_months.indexOf(value!) + 1).toString();
                          });
                        }),
                  ),
                  Expanded(
                    child: Dropdown(
                        label: 'Ano',
                        items: _years,
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
              Tabela(data: monthData, headers: Item.getHeaders()),
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
