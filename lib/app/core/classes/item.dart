import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planilla_android/app/core/classes/json_object.dart';
import 'package:csv/csv.dart';

class Item implements JsonObject {
  num eurValue;
  String item;
  String? detail;
  String date;
  String type;
  Timestamp? timestamp;

  Item(
      {required this.eurValue,
      required this.item,
      this.detail,
      required this.date,
      required this.type,
      this.timestamp});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        item: json['item'],
        type: json['type'],
        detail: json['detail'] ?? '',
        eurValue: json['eurValue'],
        date: json['date'],
        timestamp: json['timestamp']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'item': item,
      'type': type,
      'detail': detail,
      'eurValue': eurValue,
      'date': date,
      'timestamp': timestamp
    };
  }

  static List<String> getHeaders() {
    return ['Item', 'Tipo', 'Detalhes', 'Valor', 'Data', 'Timestamp'];
  }

  ///Apenas faz uma pré-validação se os dados principais estão preenchidos
  ///Pois os demais serão calculados com base nesses
  bool preValidate() {
    if (item.isEmpty || type.isEmpty || eurValue == 0 || date.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  String toString() {
    return '${toJson().toString()},\n';
  }

  String convertToCSV() {
    //Formatar strings para não quebrar o CSV
    String formatItem = '"${item.replaceAll('"', '""')}"';
    String formatDetail = '"${detail?.replaceAll('"', '""')}"';
    String? formatTimestamp;
    if (timestamp != null){
      formatTimestamp = '${timestamp?.seconds}=${timestamp?.nanoseconds}';
    }
    return '$formatItem,$type,$formatDetail,$eurValue,$date,$formatTimestamp';
  }

  static List<Item> convertFromCSV(String csv) {
    List<Item> items = [];
    List<List<dynamic>> csvList =
        const CsvToListConverter().convert(csv, eol: '\n');

    for (List<dynamic> values in csvList) {
      bool oldBackup = false;
      if (values.length == 9) {
        oldBackup = true;
      }
      List<String>? timestampValues;
      if (values[5].contains('=')) {
        timestampValues = values[5].split('=');
      } else if (oldBackup && values[8].contains('=')) {
        timestampValues = values[8].split('=');
      } else {
        timestampValues = null;
      }
      Timestamp? timestamp = timestampValues != null
          ? Timestamp(
              int.parse(timestampValues[0]), int.parse(timestampValues[1]))
          : null;
      Item newItem = Item(
          item: values[0],
          type: values[1],
          detail: values[2],
          eurValue: values[3],
          date: oldBackup? values[5] :values[4],
          timestamp: timestamp);
      items.add(newItem);
    }
    return items;
  }
}
