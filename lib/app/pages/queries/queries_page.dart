import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/classes/item.dart';
import 'package:planilla_android/app/core/ui/components/dropdown.dart';
import 'package:planilla_android/app/core/ui/components/input.dart';
import 'package:planilla_android/app/core/ui/components/table.dart';
import 'package:planilla_android/app/core/ui/components/button.dart';
import 'package:planilla_android/app/core/classes/query.dart';
import 'package:planilla_android/app/core/ui/styles/colors_app.dart';
import 'package:planilla_android/app/services/firebase/firestore_services.dart';
import 'package:planilla_android/app/util/date_util.dart';

class QueryPage extends StatefulWidget {
  const QueryPage({super.key});

  @override
  QueryPageState createState() => QueryPageState();
}

class QueryPageState extends State<QueryPage> {
  final _formKey = GlobalKey<FormState>();
  List<Item> _data = [];

  final List<String> _years = List.generate(
      2025 // Max year to show in the dropdown
          -
          2024 +
          1,
      (i) => (2024 + i).toString());

  CQuery query = CQuery(
      year: DateTime.now().year.toString(),
      month: DateTime.now().month.toString(),
      field: 'Tipo',
      queryOperator: '==',
      value: '');

  void updateData(List<Item> data) {
    setState(() {
      _data = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pesquisa'),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Dropdown(
                              label: 'Mês',
                              items: DateUtil.months,
                              value: DateUtil.getMonth(query.month),
                              onChanged: (value) {
                                setState(() {
                                  query.month =
                                      (DateUtil.months.indexOf(value!) + 1)
                                          .toString();
                                });
                              }),
                        ),
                        Expanded(
                          child: Dropdown(
                              label: 'Ano',
                              items: _years,
                              value: query.year,
                              onChanged: (value) {
                                setState(() {
                                  query.year = value!;
                                });
                              }),
                        )
                      ],
                    ),
                    Button.secondary(
                      label: 'Pesquisar tudo no mês',
                      outline: true,
                      onPressed: () async {
                        // chamar a função de pesquisa
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          //log.info('Data: $_data');
                          FirestoreServices()
                              .getItems(query.year, query.month)
                              .then((value) {
                            updateData(value);
                          });
                        }
                      },
                    ),
                    Row(children: [
                      Expanded(
                          child: Dropdown(
                              label: 'Campo',
                              items: CQuery.fields,
                              value: query.field,
                              onChanged: (value) {
                                setState(() {
                                  query.field = value!;
                                });
                              })),
                      Expanded(
                          child: Dropdown(
                              label: 'Operador',
                              items: query.field == 'Valor'
                                  ? CQuery.numericOperators
                                  : CQuery.stringOperators,
                              value: query.queryOperator,
                              onChanged: (value) {
                                setState(() {
                                  query.queryOperator = value!;
                                });
                              })),
                    ]),
                    query.field == 'Tipo'
                        ? Dropdown(
                            label: 'Valor',
                            items: const [
                              '',
                              'Alimentação',
                              'Aluguel',
                              'Casa',
                              'Contas',
                              'Roupas',
                              'Taxas',
                              'Transporte',
                              'Lazer',
                              'Outros'
                            ],
                            value: query.value,
                            onChanged: (value) {
                              setState(() {
                                query.value = value!;
                              });
                            })
                        : Input(
                            label: 'Valor',
                            value: query.value,
                            type: query.field == 'Valor' ? 'number' : 'text',
                            onChanged: (value) {
                              setState(() {
                                query.value = value;
                              });
                            },
                          ),
                    Button.primary(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            query.validate()) {
                          _formKey.currentState!.save();
                          // chamar a função de pesquisa
                          FirestoreServices()
                              .getItemsWithQuery(query)
                              .then((value) => updateData(value));
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Preencha todos os campos corretamente')));
                          }
                        }
                      },
                      label: 'Consultar',
                    ),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  height: 10,
                  thickness: 2,
                  color: ColorsApp.instance.primary,
                )),
            Tabela(data: _data, headers: Item.getHeaders())
          ],
        )));
  }
}
