import 'dart:io';
import 'package:planilla_android/app/core/classes/item.dart';
import 'package:planilla_android/app/core/errors/errors.dart';
import 'package:planilla_android/app/services/firebase/firestore_services.dart';
import 'package:planilla_android/app/util/file_util.dart';

enum FileOperationResult { success, error, noData }

class FileServices {
  static Future<int> saveBackup() async {
    String fileContent = '';
    List<Item> data = await FirestoreServices().getAllItems();
    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        fileContent += data[i].convertToCSV();
        if (i < data.length - 1) {
          fileContent += '\n'; // Add a new line if it's not the last item
        }
      }

      await FileUtil.writeToFile('${DateTime.now().millisecondsSinceEpoch}-backup.csv', fileContent);
      return FileOperationResult.success.index;
    }
    return FileOperationResult.noData.index;
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
      writeLog(e.message);
      return null;
    } on InvalidLine catch (e) {
      writeLog('Erro ao importar dados: ${e.message}');
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

  static Future<void> writeLog(String message) async {
    String date = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
    await FileUtil.writeToFile('pa-log-$date.txt', 'Generated file at ${DateTime.now()}\nError: $message');
  }
}
