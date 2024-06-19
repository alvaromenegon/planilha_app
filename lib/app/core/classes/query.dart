class CQuery{
  String year;
  String month;
  String field;
  String queryOperator;
  String value;

  CQuery({
    required this.year, 
    required this.month, 
    required this.field,
    required this.queryOperator,
    required this.value
  });

  @override
  String toString(){
    return 'PATH: data/$year/$month, WHERE $field $queryOperator $value';
  }

  static List<String> get fields => ['Item', 'Tipo','Valor','Data','Detalhes'];
  static List<String> get numericOperators => ['==', '>', '<', '>=', '<=', '!='];
  static List<String> get stringOperators => ['==', '!='];//, 'in', 'not-in']; 

  static String fieldConversion(String field){
    final Map<String, String> conversion = {
      'Item': 'item',
      'Tipo': 'type',
      'Valor': 'value',
      'Data': 'date',
      'Detalhes': 'details',
    };
    return conversion[field]!;
  } 

  bool validate(){
    if(value.isEmpty){
      return false;
    }
    return true;
  }

}