class TotalBalance extends Object{
  num totalEurBalance;
  num totalBrlBalance;
  TotalBalance({required this.totalEurBalance, required this.totalBrlBalance});
  factory TotalBalance.fromJson(Map<String, dynamic> json) {
    return TotalBalance(
      totalEurBalance: json['totalEurBalance'],
      totalBrlBalance: json['totalBrlBalance'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'totalEurBalance': totalEurBalance,
      'totalBrlBalance': totalBrlBalance,
    };
  }
}