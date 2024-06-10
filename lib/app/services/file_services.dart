import 'dart:io';
import 'package:planilla_android/app/core/classes/item.dart';
import 'package:planilla_android/app/core/errors/errors.dart';
import 'package:planilla_android/app/services/firebase/firestore_services.dart';
import 'package:planilla_android/app/util/file_util.dart';

class FileServices {
  static Future<int> saveMonthData(String year, String month) async {
    List<Item> data = [];
    String fileContent = '';
    data = await FirestoreServices().getItems(year, month);
    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        fileContent += data[i].convertToCSV();
        if (i < data.length - 1) {
          fileContent += '\n'; // Add a new line if it's not the last item
        }
      }

      await FileUtil.writeToFile('$year-$month-backup.csv', fileContent);
      return 1;
    }
    return 0;
  }

  static Future<List<Item>?> readMonthData() async {
    File? file = await FileUtil.pickFile();
    if (file == null) {
      return null;
    }
    String fileContent = await file.readAsString();
    try {
      List<Item> data = Item.convertFromCSV(fileContent);
      return data;
    } on InvalidBackup catch (e) {
      print(e.message);
      return null;
    } on InvalidLine catch (e) {
      print('Erro ao importar dados: ${e.message}');
      return null;
    }
  }

  static Future<void> writeImportResult(
    List<Item> data, List<int> results) async {
    String fileContent = '';
    String fileName = 'import-result.csv';
    if (!results.contains(SaveItemResults.invalidData.index) &&
        !results.contains(SaveItemResults.noBalance.index)) {
      fileContent = 'Todos os dados foram importados';
      fileName = 'import-success.txt';
    } else {
      for (int i = 0; i < data.length; i++) {
        print('result: ${results[i]}');
        if (results[i] != SaveItemResults.success.index) {
          if (results[i] == SaveItemResults.invalidData.index) {
            await FileUtil.writeToFile('import-invalid.txt', 'Dados inválidos: ${data[i].convertToCSV()}');
          }
          fileContent += data[i].convertToCSV();
          if (i < data.length - 1) {
            fileContent += '\n'; // Add a new line if it's not the last item
          }
        }
      }
      await FileUtil.writeToFile(fileName, fileContent);
    }

  }
}
