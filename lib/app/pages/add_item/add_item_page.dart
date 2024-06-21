import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/classes/item.dart';
import 'package:planilla_android/app/core/ui/components/button.dart';
import 'package:planilla_android/app/core/ui/components/date_picker.dart';
import 'package:planilla_android/app/core/ui/components/dropdown.dart';
import 'package:planilla_android/app/core/ui/components/input.dart';
import 'package:planilla_android/app/core/ui/helpers/messages.dart';
import 'package:planilla_android/app/services/firebase/firestore_services.dart';
import 'package:planilla_android/app/util/util.dart';

class AddItemPage extends StatelessWidget {
  const AddItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Item'),
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

class AddItemFormState extends State<AddItemForm> with Message {
  final _formKey = GlobalKey<FormState>();
  final _item = Item(
    eurValue: 0,
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
    return SingleChildScrollView(
        child: Form(
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
                try{
                  _item.eurValue = (num.parse(value))/100;
                } on FormatException {
                  _item.eurValue = 0;
                }
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
                if (_success == SaveItemResults.loading.index) {
                  return;
                }
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  FirestoreServices fs = FirestoreServices();
                  _success = await fs.saveItem(_item);
                  //_success = true;
                  if (_success == SaveItemResults.success.index) {
                    showSuccess('Item adicionado.');
                    setState(() {
                      _item.item = '';
                      _item.detail = '';
                      _item.type = '';
                      _item.eurValue = 0;
                      _item.date = Util.getFormattedDate(DateTime.now());
                    });
                  } else if (_success == SaveItemResults.invalidData.index) {
                    showError('Dados inválidos.');
                  } else {
                    showError('Error');
                  }
                  setState(() {
                    _success = SaveItemResults.idle.index;
                  });
                }
              },
              label: _success == SaveItemResults.idle.index
                  ? 'Adicionar'
                  : 'Aguarde...'),          
        ],
      ),
    ));
  }
}
