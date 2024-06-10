import 'dart:io';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileUtil {
  static Future<String> get localPath async {
    Directory? directory = await getExternalStorageDirectory();
    directory??= await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> getLocalFile(String filename) async {
    //final path = await localPath;
    return File('/storage/emulated/0/Documents/$filename');
  }

  static Future<File> writeToFile(String filename, String content) async {
    final file = await getLocalFile(filename);
    return file.writeAsString(content);
  }

  static Future<String> readFromFile(String filename) async {
    try {
      final file = await getLocalFile(filename);
      return file.readAsString();
    } catch (e) {
      return 'Error reading file: $e';
    }
  }

  static Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false,allowedExtensions: ['csv'], type: FileType.custom);
    if (result == null) {
      return null;
    }
    return File(result.files.single.path!);
  }
}