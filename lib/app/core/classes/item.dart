import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planilla_android/app/core/classes/json_object.dart';

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
  
  Item({
    required this.eurValue,
    required this.brlValue,
    required this.eurBalance,
    required this.brlBalance,
    required this.item,
    this.detail,
    required this.date,
    required this.type,
    this.timestamp
  });


  factory Item.fromJson(Map<String, dynamic> json){
    return Item(
      item: json['item'],
      type: json['type'],
      detail: json['detail'] ?? '',
      eurValue: json['eurValue'],
      brlValue: json['brlValue'],
      date: json['date'],
      eurBalance: json['eurBalance'],
      brlBalance: json['brlBalance'],
      timestamp: json['timestamp']
    );
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
  bool preValidate(){
    if(item.isEmpty || type.isEmpty || eurValue == 0 || date.isEmpty){
      return false;
    }
    return true;
  }

  @override
  String toString(){
    return '${toJson().toString()},\n';
  }

  String toJsonFile(){
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

}