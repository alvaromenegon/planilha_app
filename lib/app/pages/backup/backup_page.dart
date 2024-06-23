import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/classes/item.dart';
import 'package:planilla_android/app/core/ui/components/button.dart';
import 'package:planilla_android/app/core/ui/components/table.dart';
import 'package:planilla_android/app/core/ui/helpers/messages.dart';
import 'package:planilla_android/app/core/ui/styles/colors_app.dart';
import 'package:planilla_android/app/services/file_services.dart';
import 'package:planilla_android/app/services/firebase/firestore_services.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  BackupPageState createState() => BackupPageState();
}

class BackupPageState extends State<BackupPage> with Message {
  List<Item> importedData = [];
  bool loading = false;
  bool saving = false;

  void importData() async {
    setState(() {
      loading = true;
    });
    try {
      final data = await FileServices.readMonthData();
      if (data != null) {
        setState(() {
          importedData = data;
        });
      }
    } catch (e) {
      showError('Erro ao ler o arquivo. $e');
      await FileServices.writeLog('Erro ao ler o arquivo. $e');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> importItemsToDB() async {
    setState(() {
      loading = true;
    });
    try {
      List<int> results = await FirestoreServices().importItems(importedData);
      if (results.contains(SaveItemResults.invalidData.index)) {
        showError('Alguns dados não puderam ser importados');
      } else {
        showSuccess('Dados importados.');
      }
    } catch (e) {
      showError('Erro ao importar dados. $e');
      await FileServices.writeLog('Erro ao importar dados. $e');
    } finally {
      setState(() {
        loading = false;
      });
    }
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
                    showError('Erro ao salvar backup');
                  } else if (result == FileOperationResult.noData.index) {
                    showError('Não há dados para salvar');
                  } else {
                    showSuccess('Backup salvo com sucesso!');
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
                  importData();
                },
              ),
              importedData.isNotEmpty
                  ? Column(children: [
                      if (loading) const CircularProgressIndicator(),
                      const Text('Dados a serem importados'),
                      Tabela(data: importedData, headers: Item.getHeaders()),
                      Button.primary(
                        label:
                            loading ? 'Importando dados...' : 'Importar dados',
                        onPressed: importItemsToDB,
                      ),
                    ])
                  : Container(),
            ],
          ),
        )));
  }
}
