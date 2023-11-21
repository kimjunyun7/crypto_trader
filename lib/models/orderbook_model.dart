class Orderbook {
  final String market;
  final int timestamp;
  final double totalAskSize;
  final double totalBidSize;
  final List<OrderbookUnit> orderbookUnits;

  Orderbook({
    required this.market,
    required this.timestamp,
    required this.totalAskSize,
    required this.totalBidSize,
    required this.orderbookUnits,
  });

  factory Orderbook.fromJson(Map<String, dynamic> json) => Orderbook(
        market: json["market"],
        timestamp: json["timestamp"],
        totalAskSize: json["total_ask_size"]?.toDouble(),
        totalBidSize: json["total_bid_size"]?.toDouble(),
        orderbookUnits: List<OrderbookUnit>.from(
            json["orderbook_units"].map((x) => OrderbookUnit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "market": market,
        "timestamp": timestamp,
        "total_ask_size": totalAskSize,
        "total_bid_size": totalBidSize,
        "orderbook_units":
            List<dynamic>.from(orderbookUnits.map((x) => x.toJson())),
      };
}

class OrderbookUnit {
  final int askPrice;
  final int bidPrice;
  final double askSize;
  final double bidSize;

  OrderbookUnit({
    required this.askPrice,
    required this.bidPrice,
    required this.askSize,
    required this.bidSize,
  });

  factory OrderbookUnit.fromJson(Map<String, dynamic> json) => OrderbookUnit(
        askPrice: json["ask_price"],
        bidPrice: json["bid_price"],
        askSize: json["ask_size"]?.toDouble(),
        bidSize: json["bid_size"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "ask_price": askPrice,
        "bid_price": bidPrice,
        "ask_size": askSize,
        "bid_size": bidSize,
      };
}
