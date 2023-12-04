import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:crypto_trader/models/log_entry_model.dart';
import 'package:crypto_trader/models/market_model.dart';
import 'package:crypto_trader/models/my_account_model.dart';
import 'package:crypto_trader/models/top_market_list_item.dart';
import 'package:crypto_trader/models/top_market_model.dart';
import 'package:crypto_trader/models/trade_tick_model.dart';
import 'package:crypto_trader/screens/home_screen.dart';
import 'package:crypto_trader/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Define MACD and RSI parameters
final fast_period = 12;
final slow_period = 26;
final signal_period = 9;
final rsi_period = 14;

final logListProvider = Provider<List<LogEntryModel>>((ref) => []);
final tradeInfoProvider =
    StateNotifierProvider<TradeInfoNotifier, HoldingState>((ref) {
  final topMarketList = ref.read(topListProvider.notifier);

  return TradeInfoNotifier();
});

class TradeInfoNotifier extends StateNotifier<HoldingState> {
  TradeInfoNotifier() : super(const HoldingState());

  void updateAmount(double amount) {
    state = state.copyWith(amount: amount);
  }

  void updateProfit(double profit) {
    state = state.copyWith(profit: profit);
  }

  void updateProfitPercentage(double profitPercentage) {
    state = state.copyWith(profitPercentage: profitPercentage);
  }

  void trade() {
    final random = Random();
    final profit =
        random.nextDouble() * 1000; // Random profit between 0 and 1000
    final profitPercentage =
        random.nextDouble() * 100; // Random profit percentage between 0 and 100
    updateProfit(profit.toInt().toDouble());
    updateProfitPercentage(profitPercentage.toInt().toDouble());
  }

  bool checkBuySignal(ticker, prevPrice, curPrice) {}

  bool checkSellSignal(ticker, curPrice, buyPrice) {
    final priceChange = (curPrice - buyPrice) / buyPrice;

    return priceChange < SELL_THRESHOLD
        ? true
        : priceChange < STOP_LOSS_THRESHOLD
            ? true
            : false;
  }
}

final marketListProvider =
    StateNotifierProvider<MarketListNotifier, Map<String, MarketModel>>((ref) {
  return MarketListNotifier();
});

class MarketListNotifier extends StateNotifier<Map<String, MarketModel>> {
  MarketListNotifier() : super({}) {
    fetchMarketList();
  }

  /// 리턴 예시
  /// {'KRW-BTC':
  /// MarketModel(
  ///   "market_warning": "NONE",
  ///   "market": "KRW-BTC",
  ///   "korean_name": "비트코인",
  ///   "english_name": "Bitcoin"
  /// )}
  Future<void> fetchMarketList() async {
    final list = await ApiServices().fetchMarketList();
    Map<String, MarketModel> map = {};
    for (final item in list) {
      map[item.market] = item;
    }

    state = map;
  }
}

final topListProvider =
    StateNotifierProvider<TopListNotifier, TopMarketList>((ref) {
  final marketListMap = ref.watch(marketListProvider);

  return TopListNotifier(marketListMap);
});

class TopListNotifier extends StateNotifier<TopMarketList> {
  @override
  bool mounted = true;
  List<MarketModel> topMarketList = [];
  TopListNotifier(Map<String, MarketModel> marketMap) : super(TopMarketList()) {
    fetchTopList(marketMap);
  }
  @override
  void dispose() {
    mounted = false;
    super.dispose();
  }

  void updateTopList(Map<String, TopMarketModel> list) {
    state = state.copyWith(topMarketList: list);
  }

  void updateMarketList(Map<String, MarketModel> list) {
    state = state.copyWith(marketList: list);
  }

  // 파라미터 쓰려면 state라고 해야 함
  Future<List<MarketModel>> fetchTopList(
      Map<String, MarketModel> marketMap) async {
    final list = await ApiServices().getWebData(marketMap);
    Map<String, TopMarketModel> map = {};
    for (final item in list) {
      if (item.currency.isNotEmpty && marketMap[item.currency] != null) {
        topMarketList.add(marketMap[item.currency]!);
      }
      map[item.currency] = item;
    }
    if (mounted) {
      updateTopList(map);
      updateMarketList(marketMap);
      developer.log('mounted');
    }
    final tempMap = topMarketList;
    developer.log('tempMap: $tempMap');
    return tempMap;
  }
}

final tradeTickProvider =
    StateNotifierProvider<TradeTickNotifier, List<List<TradeTickModel>>>((ref) {
  final topListMap = ref.watch(topListProvider);
  return TradeTickNotifier(topListMap);
});

class TradeTickNotifier extends StateNotifier<List<List<TradeTickModel>>> {
  TradeTickNotifier(TopMarketList topList) : super([]) {
    fetchTradeTick(topList.marketMap);
  }

  Future<void> fetchTradeTick(Map<String, MarketModel> marketMap) async {
    // developer.log('hi: ${topListMap.length}');
    if (marketMap.isNotEmpty) {
      developer.log('@@@: ${marketMap.values.first.toJson()}');
      final list = await ApiServices().fetchTradeTicks(marketMap.values.first);
      //   log('tradeTick: ${list.first.toJson()}');
      state = [...state, list];
    }
  }
}

final timeProvider = StateNotifierProvider<TimerNotifier, int>((ref) {
  final tradeInfo = ref.read(tradeInfoProvider.notifier);

  final marketListNotifier = ref.read(marketListProvider.notifier);
  final marketList = ref.read(marketListProvider);
  final topListNotifier = ref.read(topListProvider.notifier);
  final topMarketList = ref.read(topListProvider);

  final tradeTickNotifier = ref.read(tradeTickProvider.notifier);
  return TimerNotifier(tradeInfo, marketListNotifier, marketList,
      topListNotifier, topMarketList, tradeTickNotifier);
});

class TimerNotifier extends StateNotifier<int> {
  final TradeInfoNotifier tradeInfo;
  final MarketListNotifier marketListNotifier;
  final Map<String, MarketModel> marketList;
  final TopListNotifier topListNotifier;
  final TopMarketList topMarketList;

  final TradeTickNotifier tradeTickNotifier;

  TimerNotifier(this.tradeInfo, this.marketListNotifier, this.marketList,
      this.topListNotifier, this.topMarketList, this.tradeTickNotifier)
      : super(0) {
    // startTimer();
  }

  Timer? timer;
  bool isRunning = false;

  @override
  set state(int value) {
    super.state = value;
  }

  void startTimer({int interval = 3}) {
    isRunning = true;
    timer = Timer.periodic(Duration(seconds: interval), (_) async {
      if (mounted) {
        isRunning = true;

        state++;
      }

      tradeInfo.trade();
      await marketListNotifier.fetchMarketList();
      final temp = await topListNotifier.fetchTopList(marketList);

      await tradeTickNotifier.fetchTradeTick(topMarketList.marketMap);
    });
  }

  void pauseTimer() {
    isRunning = false;
    timer?.cancel();
  }

  void resetTimer() {
    isRunning = false;
    state = 0;
  }
}
