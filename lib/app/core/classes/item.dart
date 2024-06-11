import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planilla_android/app/core/classes/json_object.dart';
import 'package:csv/csv.dart';

class Item implements JsonObject {
  num eurValue;
  num brlValue;
  num eurBalance;
  num brlBalance;
  String item;
  String? detail;
  String date;
  String type;
  Timestamp? timestamp;

  Item(
      {required this.eurValue,
      required this.brlValue,
      required this.eurBalance,
      required this.brlBalance,
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
        brlValue: json['brlValue'],
        date: json['date'],
        eurBalance: json['eurBalance'],
        brlBalance: json['brlBalance'],
        timestamp: json['timestamp']);
  }

  @override
  Map<String, dynamic> toJson() {
    //DateTime? date = timestamp?.toDate();
    //String dateStr = date != null ? '${date.year}-${date.month}-${date.day} - ${date.hour}:${date.minute}' : '';
    return {
      'item': item,
      'type': type,
      'detail': detail,
      'eurValue': eurValue,
      'brlValue': brlValue,
      'date': date,
      'eurBalance': eurBalance,
      'brlBalance': brlBalance,
      'timestamp': timestamp
    };
  }

  static List<String> getHeaders() {
    return [
      'Item',
      'Tipo',
      'Detalhes',
      'Valor (EUR)',
      'Valor (BRL)',
      'Data',
      'Saldo (EUR)',
      'Saldo (BRL)',
      'Timestamp'
    ];
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

  String toJsonFile() {
    return '''{
      "item": "$item",
      "type": "$type",
      "detail": "$detail",
      "eurValue": $eurValue,
      "brlValue": $brlValue,
      "date": "$date",
      "eurBalance": $eurBalance,
      "brlBalance": $brlBalance,
      "timestamp": "$timestamp"
    }''';
  }

  String convertToCSV() {
    //Formatar strings para não quebrar o CSV
    String formatItem = '"${item.replaceAll('"', '""')}"';
    String formatDetail = '"${detail?.replaceAll('"', '""')}"';
    String? formatTimestamp;
    if (timestamp != null){
      formatTimestamp = '${timestamp?.seconds}=${timestamp?.nanoseconds}';
    } 
    return '$formatItem,$type,$formatDetail,$eurValue,$brlValue,$date,$eurBalance,$brlBalance,$formatTimestamp';
  }

  static List<Item> convertFromCSV(String csv) {
    List<Item> items = [];
    List<List<dynamic>> csvList = const CsvToListConverter().convert(csv, eol: '\n');
    for (List<dynamic> values in csvList) {
      List<String>? timestampValues;
      if (values[8].contains('=')){
        timestampValues = values[8].split('=');
      } else {
        timestampValues = null;
      }
      Timestamp? timestamp = timestampValues != null ? Timestamp(int.parse(timestampValues[0]), int.parse(timestampValues[1])) : null;
      Item newItem = Item(
          item: values[0],
          type: values[1],
          detail: values[2],
          eurValue: values[3],
          brlValue: values[4],
          date: values[5],
          eurBalance: values[6],
          brlBalance: values[7],
          timestamp: timestamp
      );
      items.add(newItem);
    }

    /*List<String> lines = csv.split('\n');
    try {
      for (String line in lines) {        
        List<String> values;
        int detailStart = line.indexOf('"');
        int detailEnd = line.lastIndexOf('"');
        String? details;
        bool contains = false;
        if (detailStart != -1 && detailEnd != -1){
          details = line.substring(detailStart + 1, detailEnd);
        }

        contains = details?.contains(',') ?? false;
        if (contains){
          values = ('${line.substring(0, detailStart)}, ,${line.substring(detailEnd + 1)}').split(',');
        } else {
          values = line.split(',');
        }

        List<String>? timestampStr = values[8].split('=');
        Timestamp? timestamp = Timestamp(int.parse(timestampStr[0]), int.parse(timestampStr[1]));*/
        
          /*items.add(Item(
              item: values[0],
              type: values[1],
              detail: details,
              eurValue: double.parse(values[3]),
              brlValue: double.parse(values[4]),
              date: values[5],
              eurBalance: double.parse(values[6]),
              brlBalance: double.parse(values[7]),
              timestamp: timestamp
          ));
      }
    } on Exception catch (e){
      print('Error converting from CSV: $e');
      throw InvalidBackup();
    }*/
    return items;
  }
}
