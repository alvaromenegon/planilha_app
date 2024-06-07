import 'package:planilla_android/app/core/classes/json_object.dart';
import 'package:planilla_android/app/util/util.dart';

class Balance implements JsonObject{
  String balanceId;
  num brlValue;
  num eurValue;
  num currentBrlValue;
  num currentEurValue;
  String date;
  num excRateAtDate;

  Balance({
    required this.balanceId,
    required this.brlValue,
    required this.eurValue,
    required this.currentBrlValue,
    required this.currentEurValue,
    required this.date,
    required this.excRateAtDate
  });

  factory Balance.fromJson(Map<String, dynamic> json){
    return Balance(
      balanceId: json['balanceId'],
      brlValue: json['brlValue'],
      eurValue: json['eurValue'],
      currentBrlValue: json['currentBrlValue'],
      currentEurValue: json['currentEurValue'],
      date: json['date'],
      excRateAtDate: json['excRateAtDate']
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'balanceId': balanceId,
      'brlValue': brlValue,
      'eurValue': eurValue,
      'currentBrlValue': currentBrlValue,
      'currentEurValue': currentEurValue,
      'date': date,
      'excRateAtDate': excRateAtDate
    };
  }

  static List<String> getHeaders(){
    return [
      'ID',
      'Valor BRL',
      'Valor EUR',
      'Valor BRL Atual',
      'Valor EUR Atual',
      'Data',
      'Taxa de Câmbio'
    ];
  }

  bool preValidate(){
    if(date.isEmpty || excRateAtDate == 0.0 || eurValue == 0.0){
      return false;
    }
    return true;
  }

  /// Reset all values to default
  /// resetDate: if true, date will be an empty string
  /// if false, date will be the current date
  void reset({bool emptyDate = false}){
    balanceId = '';
    brlValue = 0.0;
    eurValue = 0.0;
    currentBrlValue = 0.0;
    currentEurValue = 0.0;
    date = emptyDate ? '' : Util.getFormattedDate(DateTime.now());
    excRateAtDate = 0.0;
  }

  @override
  String toString() {
    return 'Balance{balanceId: $balanceId, brlValue: $brlValue, eurValue: $eurValue, currentBrlValue: $currentBrlValue, currentEurValue: $currentEurValue, date: $date, excRateAtDate: $excRateAtDate}';
  }

}