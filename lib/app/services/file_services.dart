import 'package:planilla_android/app/core/classes/item.dart';
import 'package:planilla_android/app/services/firebase/firestore_services.dart';
import 'package:planilla_android/app/util/file_utils.dart';

class FileServices {
  static Future<int> saveMonthData(String year, String month) async {
    List<Item> data = [];
    String fileContent = '{\n\t"items": [\n';
    data = await FirestoreServices().getItems(year, month);
    if (data.isNotEmpty) {
      for (var i=0; i<data.length; i++) {
        fileContent += '\t\t${data[i].toJsonFile()}';
        if (i < data.length - 1) {
          fileContent += ',\n';
        }
      }
      fileContent += '\n\t]\n}';

      FileUtils.writeToFile('$year-$month.json', fileContent);
      return 1;
    }
    return 0;
  }
}