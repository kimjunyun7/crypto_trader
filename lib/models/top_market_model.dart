import 'package:crypto_trader/models/market_model.dart';

class TopMarketModel {
  final String englishName;
  final String currency;
//   final String warning;

  TopMarketModel({
    required this.englishName,
    required this.currency,
    // required this.warning,
  });

  Map<String, dynamic> toJson() => {
        'englishName': englishName,
        'currency': currency,
        // 'warning': warning,
      };

  factory TopMarketModel.fromJson(Map<String, dynamic> json) {
    return TopMarketModel(
      englishName: json['englishName'],
      currency: json['currency'],
      //   warning: json['warning'],
    );
  }
}
