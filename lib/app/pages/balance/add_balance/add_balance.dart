import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/classes/balance.dart';
import 'package:planilla_android/app/core/ui/components/button.dart';
import 'package:planilla_android/app/core/ui/components/date_picker.dart';
import 'package:planilla_android/app/core/ui/components/input.dart';
import 'package:planilla_android/app/core/ui/components/table.dart';
import 'package:planilla_android/app/services/firebase/firestore_services.dart';

class AddBalancePage extends StatefulWidget {
  const AddBalancePage({super.key});

  @override
  AddBalancePageState createState() => AddBalancePageState();
}

class AddBalancePageState extends State {
  List<Balance> balanceList = [];

   Future<void> loadBalances() async {
    try {
      List<Balance> balances = await FirestoreServices().getBalances();
      setState(() {
        balanceList = balances;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState(){
    super.initState();
    loadBalances();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Balance'),
        ),
        body: Column(children: [
          Tabela(data: balanceList, headers: Balance.getHeaders()),
          const AddBalanceForm(),
        ]));
  }
}

class AddBalanceForm extends StatefulWidget {
  const AddBalanceForm({super.key});

  @override
  AddBalanceFormState createState() => AddBalanceFormState();
}

class AddBalanceFormState extends State {
  final _formKey = GlobalKey<FormState>();
  int _success = AddBalanceResults.idle.index;
  final _balance = Balance(
    balanceId: '',
    eurValue: 0.0,
    brlValue: 0.0,
    currentEurValue: 0.0,
    currentBrlValue: 0.0,
    date:
        "${DateTime.now().toLocal()}".split(' ')[0],
    excRateAtDate: 0.0,
  );
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                // Wrap Input in Expanded
                child: Input(
                  label: 'Valor',
                  value: _balance.eurValue.toString(),
                  onChanged: (value) {
                    setState(() {
                      _balance.eurValue = double.parse(value);
                    });
                  },
                ),
              ),
              Expanded(
                // Wrap Input in Expanded
                child: Input(
                  label: 'Taxa',
                  value: _balance.excRateAtDate.toString(),
                  onChanged: (value) {
                    setState(() {
                      _balance.excRateAtDate = double.parse(value);
                    });
                  },
                ),
              ),
            ],
          ),
          DatePicker(
              label: 'Data',
              selectedDate: _balance.date,
              onChanged: (value) {
                setState(() {
                  _balance.date = value;
                });
              }),
          Button.primary(
              label: _success == AddBalanceResults.loading.index
                  ? 'Aguarde'
                  : 'Adicionar',
              onPressed: () async {
                if (!_formKey.currentState!.validate() || _success == AddBalanceResults.loading.index) {
                  return;
                }
                setState(() {
                  _success = AddBalanceResults.loading.index;
                });
                final FirestoreServices fs = FirestoreServices();
                _success = await fs.addBalance(_balance);
                if (_success == AddBalanceResults.success.index) {
                  print('Success');
                  print(_balance.toString());
                  setState(() {
                    _balance.reset();
                  });
                  
                } else if (_success == AddBalanceResults.invalidData.index) {
                  print('Invalid Data');               
                } else {
                  print('Error.');                  
                }
                setState(() {
                  _success = AddBalanceResults.idle.index;
                });
              }),
              Button.secondary(label: 'Limpar', onPressed: (){
                setState(() {
                  _balance.reset();
                });
              })
        ]));
  }
}
