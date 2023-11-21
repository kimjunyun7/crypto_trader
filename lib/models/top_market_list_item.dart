import 'package:crypto_trader/models/market_model.dart';
import 'package:crypto_trader/models/top_market_model.dart';

class TopMarketList {
  final Map<String, TopMarketModel> topMarketMap;
  final Map<String, MarketModel> marketMap;

  TopMarketList({
    Map<String, TopMarketModel>? topMarketMap,
    Map<String, MarketModel>? marketMap,
  })  : topMarketMap = topMarketMap ?? {},
        marketMap = marketMap ?? {};

  TopMarketList copyWith({
    Map<String, TopMarketModel>? topMarketList,
    Map<String, MarketModel>? marketList,
  }) {
    return TopMarketList(
      topMarketMap: topMarketList ?? topMarketMap,
      marketMap: marketList ?? marketMap,
    );
  }

// 	TradeState copyWith({
//     double? total,
//     double? profit,
//     double? profitPercentage,
//   }) {
//     return TradeState(
//       total: total ?? this.total,
//       profit: profit ?? this.profit,
//       profitPercentage: profitPercentage ?? this.profitPercentage,
//     );
//   }
}
