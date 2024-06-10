import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planilla_android/app/core/classes/json_object.dart';
import 'package:planilla_android/app/core/errors/errors.dart';

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
    return '$item,$type,$detail,$eurValue,$brlValue,$date,$eurBalance,$brlBalance,$timestamp';
  }

  static List<Item> convertFromCSV(String csv) {
    List<Item> items = [];
    List<String> lines = csv.split('\n');
    try {
      for (String line in lines) {        
        List<String> values = line.split(',');
        Timestamp? timestamp;
        if (values[8] == 'null'){
          timestamp = null;
        } else {
          String milis = values[8].split('=')[1];
          String nanos = values[9].split('=')[1].replaceAll(')','');
          try{
            timestamp = Timestamp(int.parse(milis), int.parse(nanos));
          } catch (e) {
            timestamp = null;
            print('Error converting timestamp: $e');
          }
        }
        if ((timestamp == null && values.length == 9) || (timestamp != null && values.length == 10)) {
          items.add(Item(
              item: values[0],
              type: values[1],
              detail: values[2],
              eurValue: double.parse(values[3]),
              brlValue: double.parse(values[4]),
              date: values[5],
              eurBalance: double.parse(values[6]),
              brlBalance: double.parse(values[7]),
              timestamp: timestamp
          ));
        } else {
          print('Invalid line: $line');
          throw InvalidLine();
        }
      }
    } on Exception catch (e){
      print('Error converting from CSV: $e');
      throw InvalidBackup();
    }
    print('items:');
    print(items);

    return items;
  }
}
