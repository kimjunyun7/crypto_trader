import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:crypto_trader/models/market_model.dart';
import 'package:crypto_trader/services/api_service.dart';
import 'package:crypto_trader/utils/generate_dialogs.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../shared/providers.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({Key? key}) : super(key: key);

  final MARKETLIST_SIZE = const Size(400, 200);

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final count = ref.watch(counterProvider);
    final timerResponse = ref.watch(timeProvider);
    final logs = ref.watch(logListProvider);
    final tradeInfo = ref.watch(tradeInfoProvider);
    final marketList = ref.watch(marketListProvider);
    final topListMap = ref.watch(topListProvider);

    final tickProvider = ref.watch(tradeTickProvider);
    // developer.log('her: ${topListMap.length}');
    // developer.log('her: ${topListMap[0]}');
    // developer.log('her: ${topListMap[1]}');

    // ref.read(topListProvider.notifier).fetchMarketList();

    // ref.listen(
    //   counterProvider,
    //   ((prev, next) {
    //     developer.log('현재 상태: $prev, $next');
    //   }),
    // );\

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Timer: $timerResponse',
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //   Text("Count: ${count.toString()}"),
              //   TextButton(
              //     onPressed: () {
              //       ref.watch(counterProvider.notifier).increment();
              //       addLog(count.toString());
              //     },
              //     child: const Text('증가'),
              //   ),
              //   const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '자금: ${tradeInfo.total.toString()} 원',
                  ),
                  Text(
                    '이익: ${tradeInfo.profit.toString()} 원',
                  ),
                  Text(
                    '이율: ${tradeInfo.profitPercentage.toString()} %',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('$timerResponse 회'),
                  ElevatedButton(
                      onPressed: () {
                        developer.log(
                            'count: ${ref.watch(timeProvider.notifier).isRunning}');
                        ref.read(timeProvider.notifier);
                      },
                      child: const Text('isOn?')),
                  //   Text('${ref.read(timerProvider.notifier).count} 초'),
                  ElevatedButton(
                      onPressed: () {
                        // UtilsDialogs.showSnackBar(context, 'updated: hi');
                        if (!ref.read(timeProvider.notifier).isRunning) {
                          ref.read(timeProvider.notifier).startTimer();
                          developer.log('start pressed');
                        }
                      },
                      child: const Text('start')),
                  ElevatedButton(
                      onPressed: () {
                        // UtilsDialogs.showSnackBar(context, 'updated: hi');
                        if (ref.read(timeProvider.notifier).isRunning) {
                          ref.read(timeProvider.notifier).pauseTimer();
                          developer.log('pause pressed');
                        }
                      },
                      child: const Text('pause'))
                ],
              ),
              //   marketListData를 timer에서 빼버리고 해 얘는 변하는게 없으니까.
              //   그리고 FutureBuilder[] 이거였나처럼 .when()을 한번에 묶어 하는거 없나 봐바

              //   timer.when(
              //     data: (index) {
              //       final marketListData = ref.watch(marketListProvider(index));

              //       return marketListData.when(
              //         data: (marketList) {
              //           final topListData =
              //               ref.watch(topListProvider(marketList));
              //           return topListData.when(
              //             data: (topList) {
              //               return Column(
              //                 children: [
              //                   SingleChildScrollView(
              //                     child: ListBoxWidget(
              //                       size: MARKETLIST_SIZE,
              //                       child: ListView.builder(
              //                           itemCount: topList.length,
              //                           itemBuilder: (context, index) {
              //                             final market = topList[index];
              //                             return SizedBox(
              //                               height: 50.0,
              //                               child: ListTile(
              //                                 dense: true,
              //                                 title: Text(market.currency),
              //                                 subtitle: Text(market.englishName),
              //                               ),
              //                             );
              //                           }),
              //                     ),
              //                   ),
              //                   SingleChildScrollView(
              //                     child: ListBoxWidget(
              //                       size: MARKETLIST_SIZE,
              //                       child: ListView.builder(
              //                         controller: scrollController,
              //                         reverse: false,
              //                         itemCount: marketList.length,
              //                         itemBuilder: (context, index) {
              //                           final market =
              //                               marketList.values.elementAt(index);
              //                           return SizedBox(
              //                             height: 50.0,
              //                             child: ListTile(
              //                               dense: true,
              //                               title: Text(market.koreanName),
              //                               subtitle: Text(market.market),
              //                             ),
              //                           );
              //                         },
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               );
              //             },
              //             loading: () {
              //               return ListBoxWidget(
              //                 size: MARKETLIST_SIZE,
              //                 child: const Center(
              //                   child: CircularProgressIndicator(),
              //                 ),
              //               );
              //             },
              //             error: (error, stackTrace) {
              //               return const Text("error");
              //             },
              //           );
              //         },
              //         loading: () {
              //           return ListBoxWidget(
              //             size: MARKETLIST_SIZE,
              //             child: const Center(
              //               child: CircularProgressIndicator(),
              //             ),
              //           );
              //         },
              //         error: (error, stackTrace) {
              //           return const Text("error");
              //         },
              //       );
              //     },
              //     loading: () {
              //       // Render a loading indicator
              //       return const CircularProgressIndicator();
              //     },
              //     error: (error, stackTrace) {
              //       // Render an error message
              //       return Text('Error: $error');
              //     },
              //   ),
              SingleChildScrollView(
                child: ListBoxWidget(
                  size: MARKETLIST_SIZE,
                  child: ListView.builder(
                      itemCount: topListMap.topMarketMap.length,
                      itemBuilder: (context, index) {
                        final key =
                            topListMap.topMarketMap.keys.elementAt(index);
                        return SizedBox(
                          height: 50.0,
                          child: ListTile(
                            dense: true,
                            title: Text(
                                topListMap.topMarketMap[key]?.currency ??
                                    'none'),
                            subtitle: Text(
                                topListMap.topMarketMap[key]?.englishName ??
                                    'none coin'),
                          ),
                        );
                      }),
                ),
              ),
              SingleChildScrollView(
                child: ListBoxWidget(
                  size: MARKETLIST_SIZE,
                  child: ListView.builder(
                    controller: scrollController,
                    reverse: false,
                    itemCount: marketList.length,
                    itemBuilder: (context, index) {
                      final market = marketList.values.elementAt(index);
                      return SizedBox(
                        height: 50.0,
                        child: ListTile(
                          dense: true,
                          title: Text(market.koreanName),
                          subtitle: Text(market.market),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              //   Text('${ref.read(tickProvider)}'),
              SingleChildScrollView(
                child: ListBoxWidget(
                  size: MARKETLIST_SIZE,
                  child: ListView.builder(
                      itemCount: tickProvider.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 50.0,
                          child: ListTile(
                            dense: true,
                            title: Text(tickProvider[index].market ?? 'none'),
                            subtitle:
                                Text("${tickProvider[index].tradePrice ?? 0}"),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListBoxWidget extends StatelessWidget {
  const ListBoxWidget({
    super.key,
    required this.size,
    required this.child,
  });

  final Size size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurple.shade100)),
        width: size.width,
        height: size.height,
        child: child);
  }
}

class TradeInfoNotifier extends StateNotifier<TradeState> {
  TradeInfoNotifier() : super(const TradeState());

  void updateTotal(double total) {
    state = state.copyWith(total: total);
  }

  void updateProfit(double profit) {
    state = state.copyWith(profit: profit);
  }

  void updateProfitPercentage(double profitPercentage) {
    state = state.copyWith(profitPercentage: profitPercentage);
  }

  void randomUpdate() {
    final random = Random();
    final profit =
        random.nextDouble() * 1000; // Random profit between 0 and 1000
    final profitPercentage =
        random.nextDouble() * 100; // Random profit percentage between 0 and 100
    updateProfit(profit.toInt().toDouble());
    updateProfitPercentage(profitPercentage.toInt().toDouble());
  }
}

@immutable
class TradeState {
  final double total;
  final double profit;
  final double profitPercentage;

  const TradeState({
    this.total = 100.0,
    this.profit = 10.0,
    this.profitPercentage = 5.0,
  });

  TradeState copyWith({
    double? total,
    double? profit,
    double? profitPercentage,
  }) {
    return TradeState(
      total: total ?? this.total,
      profit: profit ?? this.profit,
      profitPercentage: profitPercentage ?? this.profitPercentage,
    );
  }
}
