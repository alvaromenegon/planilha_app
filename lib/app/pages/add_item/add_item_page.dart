// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/classes/item.dart';
import 'package:planilla_android/app/core/ui/components/button.dart';
import 'package:planilla_android/app/core/ui/components/date_picker.dart';
import 'package:planilla_android/app/core/ui/components/dropdown.dart';
import 'package:planilla_android/app/core/ui/components/input.dart';
import 'package:planilla_android/app/services/firebase/firestore_services.dart';
import 'package:planilla_android/app/util/util.dart';

class AddItemPage extends StatelessWidget {
  const AddItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: const AddItemForm(),
    );
  }
}

class AddItemForm extends StatefulWidget {
  const AddItemForm({super.key});

  @override
  AddItemFormState createState() => AddItemFormState();
}

class AddItemFormState extends State<AddItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _item = Item(
    eurValue: 0,
    brlValue: 0,
    eurBalance: 0,
    brlBalance: 0,
    item: '',
    date: Util.getFormattedDate(DateTime.now()),
    type: '',
  );
  final List<String> _itemTypes = [
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
  ];
  int _success = SaveItemResults.idle.index;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Input(
            label: 'Item',
            value: _item.item,
            onChanged: (value) {
              setState(() {
                _item.item = value;
              });
            },
          ),
          Input(
            label: 'Detalhes',
            value: _item.detail ?? '',
            onChanged: (value) {
              setState(() {
                _item.detail = value;
              });
            },
          ),
          Dropdown(
              label: 'Tipo',
              items: _itemTypes,
              value: _item.type,
              onChanged: (String? newValue) {
                setState(() {
                  _item.type = newValue!;
                });
              }),
          Input(
            label: 'Valor',
            type: 'number',
            value: _item.eurValue.toString(),
            onChanged: (value) {
              setState(() {
                if (value.isEmpty) {
                  value = '0';
                }
                _item.eurValue = double.parse(value);
              });
            },
          ),
          DatePicker(
            label: 'Escolher',
            selectedDate: _item.date,
            onChanged: (value) {
              setState(() {
                _item.date = value;
              });
            },
          ),
          Button.primary(
              onPressed: () async {
                if (_success != SaveItemResults.loading.index) {
                  return;
                }
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  FirestoreServices fs = FirestoreServices();
                  _success = await fs.saveItem(_item);
                  //_success = true;
                  if (_success == SaveItemResults.success.index) {
                    print('Success');
                  } else if (_success == SaveItemResults.invalidData.index) {
                    print('Invalid data');
                  } else if (_success == SaveItemResults.noBalance.index) {
                    if (context.mounted) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Sem saldo disponível.'),
                              content: const Text(
                                  'Não há saldo disponível para adicionar um novo item.\nA operação foi cancelada.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          });
                    }
                    print('No balance');
                  } else {
                    print('Error');
                  }
                }
              },
              label: _success == SaveItemResults.idle.index
                  ? 'Adicionar'
                  : 'Aguarde...'),
        ],
      ),
    );
  }
}
