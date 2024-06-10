import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/classes/item.dart';
import 'package:planilla_android/app/core/ui/components/button.dart';
import 'package:planilla_android/app/core/ui/components/table.dart';
import 'package:planilla_android/app/core/ui/styles/colors_app.dart';
import 'package:planilla_android/app/services/file_services.dart';
import 'package:planilla_android/app/services/firebase/firestore_services.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  BackupPageState createState() => BackupPageState();
}

class BackupPageState extends State<BackupPage> {
  List<Item> importedData = [];
  bool importing = false;
  bool saving = false;

  void importData(List<Item> data) {
    setState(() {
      importedData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Backup'),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Button.primary(
                label: saving ? 'Salvando backup...' : 'Salvar backup',
                onPressed: () async {
                  setState(() {
                    saving = true;
                  });
                  int result = await FileServices.saveBackup();
                  if (result == FileOperationResult.error.index) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Erro ao salvar backup')));
                    }
                  } else if (result == FileOperationResult.noData.index) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Não há dados para salvar')));
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Backup salvo com sucesso!')));
                    }
                  }
                  setState(() {
                    saving = false;
                  });
                },
              ),
              Divider(
                height: 10,
                thickness: 2,
                color: ColorsApp.instance.primary,
              ),
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
                  ? Column(children: [
                      const Text('Dados a serem importados'),
                      Tabela(data: importedData, headers: Item.getHeaders()),
                      Button.primary(
                        label: importing
                            ? 'Importando dados...'
                            : 'Importar dados',
                        onPressed: () async {
                          setState(() {
                            importing = true;
                          });
                          List<int> results = await FirestoreServices()
                              .importItems(importedData);
                          if (results
                              .contains(SaveItemResults.invalidData.index)) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Alguns dados não puderam ser importados')));
                            }
                          } else if (results
                              .contains(SaveItemResults.noBalance.index)) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Alguns dados não puderam ser importados pois não há saldo suficiente')));
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Dados importados com sucesso!')));
                            }
                          }
                          setState(() {
                            importing = false;
                          });
                        },
                      ),
                    ])
                  : Container(),
            ],
          ),
        )));
  }
}
