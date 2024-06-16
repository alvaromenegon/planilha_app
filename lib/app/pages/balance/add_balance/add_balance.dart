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
  final formKey = GlobalKey<FormState>();
  int success = AddBalanceResults.idle.index;
  final balance = Balance(
    balanceId: '',
    eurValue: 0.0,
    brlValue: 0.0,
    currentEurValue: 0.0,
    currentBrlValue: 0.0,
    date: "${DateTime.now().toLocal()}".split(' ')[0],
    excRateAtDate: 0.0,
  );

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
  void initState() {
    super.initState();
    loadBalances();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Saldo'),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Tabela(data: balanceList, headers: Balance.getHeaders()),
          Form(
              key: formKey,
              child: Column(children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      // Wrap Input in Expanded
                      child: Input(
                        label: 'Valor',
                        value: balance.eurValue.toString(),
                        type: 'number',
                        onChanged: (value) {
                          setState(() {
                            try{
                              balance.eurValue = (num.parse(value))/100;
                            } on FormatException {
                              balance.eurValue = 0;
                            }
                          });
                        },
                      ),
                    ),
                    Expanded(
                      // Wrap Input in Expanded
                      child: Input(
                        label: 'Taxa',
                        value: balance.excRateAtDate.toString(),
                        type: 'number',
                        onChanged: (value) {
                          setState(() {
                            try{
                              balance.excRateAtDate = (num.parse(value))/100;
                            } on FormatException {
                              balance.excRateAtDate = 0;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                DatePicker(
                    label: 'Data',
                    selectedDate: balance.date,
                    onChanged: (value) {
                      setState(() {
                        balance.date = value;
                      });
                    }),
                Button.primary(
                    label: success == AddBalanceResults.loading.index
                        ? 'Aguarde'
                        : 'Adicionar',
                    onPressed: () async {
                      if (!formKey.currentState!.validate() ||
                          success == AddBalanceResults.loading.index) {
                        return;
                      }
                      setState(() {
                        success = AddBalanceResults.loading.index;
                      });
                      final FirestoreServices fs = FirestoreServices();
                      success = await fs.addBalance(balance);
                      if (success == AddBalanceResults.success.index) {
                        setState(() {
                          balance.reset();
                          loadBalances();
                        });
                      } else if (success ==
                          AddBalanceResults.invalidData.index) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Dados Inválidos')));
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Erro ao adicionar saldo')));
                        }
                      }

                      setState(() {
                        success = AddBalanceResults.idle.index;
                      });
                    }),
                Button.secondary(
                    label: 'Limpar',
                    onPressed: () {
                      setState(() {
                        balance.reset();
                      });
                    })
              ]))
        ])));
  }
}
