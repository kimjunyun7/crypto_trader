class MarketModel {
  MarketModel({
    required this.market,
    required this.koreanName,
    required this.englishName,
    required this.marketWarning,
  });

  final String market;
  final String koreanName;
  final String englishName;
  final String marketWarning;

  factory MarketModel.fromJson(Map<String, dynamic> json) => MarketModel(
      market: json["market"],
      koreanName: json["korean_name"],
      englishName: json["english_name"],
      marketWarning: json["market_warning"]);

  Map<String, dynamic> toJson() => {
        "market": market,
        "korean_name": koreanName,
        "english_name": englishName,
        "market_warning": marketWarning,
      };
}
