class AverageExcRate{
  List<String> balancesUsed;
  double exchangeRate;
  DateTime lastUpdate;

  AverageExcRate({
    required this.balancesUsed,
    required this.exchangeRate,
    required this.lastUpdate
  });

  factory AverageExcRate.fromJson(Map<String, dynamic> json){
    return AverageExcRate(
      balancesUsed: json['balancesUsed'],
      exchangeRate: json['exchangeRate'],
      lastUpdate: json['lastUpdate'].toDate()
    );
  }
}