import 'dart:io';

import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/classes/item.dart';
import 'package:planilla_android/app/core/ui/components/button.dart';
import 'package:planilla_android/app/core/ui/components/dropdown.dart';
import 'package:planilla_android/app/core/ui/components/table.dart';
import 'package:planilla_android/app/services/file_services.dart';
import 'package:planilla_android/app/services/firebase/firestore_services.dart';

class MonthViewPage extends StatefulWidget {
  const MonthViewPage({super.key});

  @override
  MonthViewPageState createState() => MonthViewPageState();
}

class MonthViewPageState extends State<MonthViewPage> {
  String selectedMonth = DateTime.now().month.toString();
  String selectedYear = DateTime.now().year.toString();
  String saveButtonText = 'Salvar backup';
  List<Item> monthData = [];
  List<Item> importedData = [];
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

  void importData(List<Item> data) {
    setState(() {
      importedData = data;
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
              ),
              Platform.isAndroid
                  ? Button.secondary(
                      label: saveButtonText,
                      onPressed: () async {
                        setState(() {
                          saveButtonText = 'Salvando...';
                        });
                        int result = await FileServices.saveMonthData(
                            selectedYear, selectedMonth);
                        if (result == 1) {
                          setState(() {
                            saveButtonText = 'Salvo!';
                          });
                        } else {
                          setState(() {
                            saveButtonText = 'Erro ao salvar';
                          });
                        }
                      },
                    )
                  : Container(),
                  const Divider(),
              Button.primary(
                label: 'Importar backup',
                outline: true,
                onPressed: () async {
                  final data = await FileServices.readMonthData();
                  if (data != null) {
                    importData(data);
                  }
                },
              ),
              importedData.isNotEmpty
                  ? Column(children:[
                    const Text('Dados a serem importados'),
                    Tabela(data: importedData, headers: Item.getHeaders()),
                    Button.primary(
                      label: 'Importar dados', 
                      onPressed: () async{
                        List<int> results = await FirestoreServices().importItems(importedData);
                        if (results.contains(SaveItemResults.invalidData.index)){
                          print('Erro ao importar dados: Dados inválidos');
                        } else if (results.contains(SaveItemResults.noBalance.index)){
                          print('Não há saldo suficiente para todos os itens');
                        } else {
                          print('Dados importados com sucesso');
                        }
                    },),
                  ]

                    )
                  : Container(),

            ],
          ),
        ));
  }
}
