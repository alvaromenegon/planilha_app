import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/classes/json_object.dart';

class MonthDataOverview implements JsonObject{
  final String month;
  final num total;

  MonthDataOverview({required this.month, required this.total});

  @override
  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'total': total
    };
  }

  static List<String> getHeaders() {
    return ['Mês', 'Total'];
  }

  Color get colorForTotal {
    if (total > 600){
      return const Color.fromRGBO(234,67,53,0.5);
    } else if (total > 420 && total <= 600){
      return const Color.fromRGBO(247,152,29,0.5);
    } else {
      return const Color.fromRGBO(183,225,205,1);
    }

  }

}