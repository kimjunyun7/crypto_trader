// To parse this JSON data, do
//
//     final tradeTickModel = tradeTickModelFromJson(jsonString);

import 'dart:developer';

import 'package:crypto_trader/models/market_model.dart';
import 'package:crypto_trader/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TradeTickModel {
  final String market;
  final DateTime tradeDateUtc;
  final String tradeTimeUtc;
  final int timestamp;
  final double tradePrice;
  final double tradeVolume;
  final double prevClosingPrice;
  final double changePrice;
  final String askBid;
  final int sequentialId;

  TradeTickModel({
    required this.market,
    required this.tradeDateUtc,
    required this.tradeTimeUtc,
    required this.timestamp,
    required this.tradePrice,
    required this.tradeVolume,
    required this.prevClosingPrice,
    required this.changePrice,
    required this.askBid,
    required this.sequentialId,
  });

  factory TradeTickModel.fromJson(Map<String, dynamic> json) => TradeTickModel(
        market: json["market"],
        tradeDateUtc: DateTime.parse(json["trade_date_utc"]),
        tradeTimeUtc: json["trade_time_utc"],
        timestamp: json["timestamp"],
        tradePrice: json["trade_price"],
        tradeVolume: json["trade_volume"]?.toDouble(),
        prevClosingPrice: json["prev_closing_price"],
        changePrice: json["change_price"],
        askBid: json["ask_bid"],
        sequentialId: json["sequential_id"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "market": market,
        "trade_date_utc":
            "${tradeDateUtc.year.toString().padLeft(4, '0')}-${tradeDateUtc.month.toString().padLeft(2, '0')}-${tradeDateUtc.day.toString().padLeft(2, '0')}",
        "trade_time_utc": tradeTimeUtc,
        "timestamp": timestamp,
        "trade_price": tradePrice,
        "trade_volume": tradeVolume,
        "prev_closing_price": prevClosingPrice,
        "change_price": changePrice,
        "ask_bid": askBid,
        "sequential_id": sequentialId,
      };
}

// class TradeTickNotifier extends StateNotifier<List<TradeTickModel>> {
//   TradeTickNotifier() : super([]);

//   Future<void> fetchAndUpdateTradeTick(MarketModel market) async {
//     log('TradeTick updated');
//     // Replace this with your actual API call
//     final response = await ApiServices().fetchTradeTicks(market);

//     if (response.isNotEmpty) {
//       // Assuming the response body is a Map<String, dynamic> that can be passed to TradeTickModel.fromJson
//       final newTradeTick = response.first;
//       state[0] = newTradeTick;
//     } else {
//       // Handle error
//     }
//   }
// }
