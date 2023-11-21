import 'dart:convert' show ascii, base64, json, jsonDecode;
import 'dart:developer';

import 'package:crypto_trader/models/market_model.dart';
import 'package:crypto_trader/models/my_account_model.dart';
import 'package:crypto_trader/models/orderbook_model.dart';
import 'package:crypto_trader/models/top_market_model.dart';
import 'package:crypto_trader/models/trade_tick_model.dart';
import 'package:crypto_trader/shared/constants.dart';
import 'package:crypto_trader/shared/user_secure_storage.dart';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class ApiServices {
  final Map<String, MarketModel> marketList = {};

  ///
  /// 토큰 생성
  Future<String> generateJWTToken() async {
    try {
      String accessKey = await UserSecureStorage.getAccessKey() ?? '';
      String secretKey = await UserSecureStorage.getSecretKey() ?? '';

      if (accessKey == '' || secretKey == '') {
        throw Exception('Access Key 혹은 Secret Key가 저장되어 있지 않음');
      }

      var uuid = const Uuid();

      final jwt = JWT(
        {
          'access_key': accessKey,
          'nonce': uuid.v4(),
        },
      );

      String token =
          jwt.sign(SecretKey(secretKey), algorithm: JWTAlgorithm.HS256);
      // log("token: $token");
      try {
        // Verify a token
        final jwt = JWT.verify(token, SecretKey(secretKey));
        log('token: $token');
        log('Payload: ${jwt.payload}');
      } on JWTExpiredException {
        log('jwt expired');
      } on JWTException catch (ex) {
        log('jwt error: ${ex.message}'); // ex: invalid signature
      }
      return token;
    } catch (e) {
      log('토큰 생성 오류: ${e.toString()}');
    }
    throw Exception('토큰 생성 실패');
  }

  /// 전체 계좌 확인
  /// return: Future<List<AccountModel>>
  Future<List<MyAccountModel>> fetchAccountList() async {
    try {
      String token = await generateJWTToken();
      // log("token 새로운: $token");
      final header = {
        "Authorization": 'Bearer $token',
        "Content-Type": "application/json"
      };

      var uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.accounts);
      // log("uri: $uri");
      final response = await http.get(uri, headers: header);

      final List<MyAccountModel> list = [];
      if (response.statusCode == 200) {
        // log("전체 계좌 조회 확인: ${response.body}");
        log("전체 계좌 조회 성공");

        MyAccountModel temp;
        for (var account in jsonDecode(response.body)) {
          temp = MyAccountModel.fromJson(account);
          list.add(temp);
        }
        // log("account list: $list");

        return list;
      }
      log("전체 계좌 조회 Status: ${response.statusCode}");
      log("전체 계좌 조회 PostOUTOFIF: ${response.body}");
    } catch (e) {
      log('전체 계좌 조회: ${e.toString()}');
    }
    throw Exception('전체 계좌 조회 실패');
  }

  // ### Quotation API ###

  /// ### 마켓 코드 조회
  /// 예시:
  /// [{
  ///   "market_warning": "NONE",
  ///   "market": "KRW-BTC",
  ///   "korean_name": "비트코인",
  ///   "english_name": "Bitcoin"
  /// },]
  Future<List<MarketModel>> fetchMarketList() async {
    try {
      final header = {"accept": "application/json"};

      String isDetail = '?isDetails=true'; // market_warning도 같이 줌

      var uri =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.marketAll + isDetail);
      final response = await http.get(uri, headers: header);

      final List<MarketModel> list = [];
      if (response.statusCode == 200) {
        // log("마켓 코드 조회 확인: ${response.body}");
        log("마켓 코드 조회 성공");

        MarketModel temp;
        for (var account in jsonDecode(response.body)) {
          temp = MarketModel.fromJson(account);
          list.add(temp);
        }

        return list;
      }
      log("마켓 코드 조회 Status: ${response.statusCode}");
      log("마켓 코드 조회 PostOUTOFIF: ${response.body}");
    } catch (e) {
      log('마켓 코드 조회: ${e.toString()}');
    }
    throw Exception('마켓 코드 조회 실패');
  }

  Future<List<TradeTickModel>> fetchTradeTicks(MarketModel market) async {
    try {
      final header = {"Content-Type": "application/json"};
      var uri = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.tradesTicks}?market=${market.market}');
      log('uri: ${uri.toString()}');
      final response = await http.get(uri, headers: header);

      final List<TradeTickModel> list = [];
      if (response.statusCode == 200) {
        log("최근 체결 내역 확인: ${response.body}");

        TradeTickModel temp;
        for (var tick in jsonDecode(response.body)) {
          temp = TradeTickModel.fromJson(tick);
          list.add(temp);
        }
        // log("orderbook list: $list");

        return list;
      }
      log("최근 체결 내역 Status: ${response.statusCode}");
      log("최근 체결 내역 PostOUTOFIF: ${response.body}");
    } catch (e) {
      log('최근 체결 내역: ${e.toString()}');
    }
    throw Exception('최근 체결 내역 실패');
  }

//   Future<List<Orderbook>> fetchOrderbook() async {
//     try {
//       final queryParameters = {
//         'markets': HomeTopMarketListController().topMarketList.toList(),
//       };

//       log('queryParameters: $queryParameters');

//       final header = {"Content-Type": "application/json"};
//       var uri = Uri.parse(ApiConstants.baseUrl +
//           ApiConstants.orderBook +
//           queryParameters.toString());
//       final response = await http.get(uri, headers: header);

//       final List<Orderbook> list = [];
//       if (response.statusCode == 200) {
//         log("호가 정보 조회 확인: ${response.body}");

//         Orderbook temp;
//         for (var orderbook in jsonDecode(response.body)) {
//           temp = Orderbook.fromJson(orderbook);
//           list.add(temp);
//         }
//         // log("orderbook list: $list");

//         return list;
//       }
//       log("호가 정보 조회 Status: ${response.statusCode}");
//       log("호가 정보 조회 PostOUTOFIF: ${response.body}");
//     } catch (e) {
//       log('호가 정보 조회: ${e.toString()}');
//     }
//     throw Exception('호가 정보 조회 실패');
//   }

////////// TOP 리스트 (업비트 아님) //////////
  Future<List<TopMarketModel>> getWebData(
      Map<String, MarketModel> marketMap) async {
    final url =
        Uri.parse('https://coinmarketcap.com/ko/exchanges/upbit/?type=spot');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final englishNameList = html
        .querySelectorAll('a > div > div > p')
        .map((element) => element.innerHtml.trim())
        .toList();

    final currencyList = html
        .querySelectorAll('div > a.sc-cefb3d9b-0.iTwyIj.cmc-link')
        .map((element) {
      String response = element.innerHtml.trim();
      int divisionIndex = response.indexOf('/');
      String fromCurrency = response.substring(0, divisionIndex);
      String toCurrency = response.substring(divisionIndex + 1); // 슬래시(/) 넘김
      return "$toCurrency-$fromCurrency";
    }).toList();
    List<TopMarketModel> list = [];
    for (int i = 0; i < 10; i++) {
      list.add(TopMarketModel(
          englishName: englishNameList[i], currency: currencyList[i]));
    }
    List<TopMarketModel> topList = [];
    for (final item in list) {
      final temp = TopMarketModel(
          englishName: marketMap[item]?.englishName ?? 'none',
          currency: marketMap[item]?.market ?? 'NO currency');
      topList.add(temp);
    }
    // List<TopMarketModel> list =
    //     filterMarketList(map, englishNameList, currencyList);

    return list;
  }

// 문제 없는 TOP10 찾음
//   List<TopMarketModel> filterMarketList(Map<String, TopMarketModel> map,
//       List<String> englishNameList, List<String> currencyList) {
//     log('len: ${englishNameList.length}');
//     List<TopMarketModel> list = [];
//     for (var i = 0; i < englishNameList.length; i++) {
//       TopMarketModel market = TopMarketModel(
//           englishName: englishNameList[i],
//           currency: currencyList[i],
//           warning: 'NONE');
//       if (map[currencyList[i]]?.warning == 'NONE') {
//         list.add(market);
//         if (list.length == 10) break;
//       }
//     }
//     return list;
//   }
}
