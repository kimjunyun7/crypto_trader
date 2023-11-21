class MyAccountModel {
  final String currency;
  final double balance;
  final double locked;
  final double avgBuyPrice;
  final bool avgBuyPriceModified;
  final String unitCurrency;

  MyAccountModel({
    required this.currency,
    required this.balance,
    required this.locked,
    required this.avgBuyPrice,
    required this.avgBuyPriceModified,
    required this.unitCurrency,
  });

  Map<String, dynamic> toJson() => {
        'currency': currency,
        'balance': balance,
        'locked': locked,
        'avg_buy_price': avgBuyPrice,
        'avg_buy_price_modified': avgBuyPriceModified,
        'unit_currency': unitCurrency,
      };

  factory MyAccountModel.fromJson(Map<String, dynamic> json) {
    // log('balance: ${json['balance'].runtimeType}');
    // log('locked: ${json['locked']}');
    // log('avgBuyPrice: ${json['avg_buy_price']}');
    // log('avgBuyPrice: ${json['avg_buy_price_modified']}');
    // log('avgBuyPrice: ${json['unit_currency']}');

    return MyAccountModel(
      currency: json['currency'],
      balance: double.parse(json['balance']),
      locked: double.parse(json['locked']),
      avgBuyPrice: double.parse(json['avg_buy_price'] ?? '-123456789'),
      avgBuyPriceModified: json['avg_buy_price_modified'],
      unitCurrency: json['unit_currency'],
    );
  }
  @override
  String toString() {
    return '$currency $balance $locked $avgBuyPrice $avgBuyPriceModified $unitCurrency';
  }
}
