// ignore_for_file: slash_for_doc_comments

class ApiConstants {
  static const String baseUrl = 'https://api.upbit.com/v1';

  /**
   * 자산 - 전체 계좌 조회 - GET<br />
   * /accounts
   * - currency [String] : 화폐를 의미하는 영문 대문자 코드
   * - balance [String] : 주문 가능 금액/수량
   * - locked [String] : 주문 중 묶여있는 금액/수량
   * - avg_buy_price [String] : 매수평균가
   * - avg_buy_price_modified [Boolean] : 매수평균가 수정 여부
   * - unit_currency [String] : 편단가 기준 화폐
   */
  static const String accounts = '/accounts';

  ///
  /// 마켓 코드 조회 - GET<br />
  /// /market/all
  /// - market [String] : 업비트에서 제공중인 시장 정보
  /// - korean_name [String] : 거래 대상 암호화폐 한글명
  /// - english_name [String] : 거래 대상 암호화폐 영문명
  /// - market_warning [String] : 유의 종목 여부 (NONE (해당 사항 없음), CAUTION(투자유의))
  ///
  static const String marketAll = '/market/all';

  ///
  /// 시세 최근 체결 내역 - GET<br />
  /// /trades/ticks
  /// - market [String]: 마켓 구분 코드
  /// - trade_date_utc [String]: 체결 일자(UTC 기준) 포맷: yyyy-MM-dd
  /// - trade_time_utc [String]: 체결 시각(UTC 기준) 포맷: HH:mm:ss
  /// - timestamp [long]: 체결 타임스탬프
  /// - trade_price [double]: 체결 가격
  /// - trade_volume [double]: 체결량
  /// - prev_closing_price [double]: 전일 종가(UTC 0시 기준)
  /// - change_price [double]: 변화량
  /// - ask_bid [String]: 매도/매수
  /// - sequential_id [long]: 체결 번호(Unique)
  /// - - sequential_id 필드는 체결의 유일성 판단을 위한 근거로 쓰일 수 있습니다. 하지만 체결의 순서를 보장하지는 못합니다.
  static const String tradesTicks = '/trades/ticks';

  /**
   * 시세 호가 정보 조회 - GET<br />
   * /orderbook
   * - market [String] : 마켓 코드
   * - timestamp [long] : 호가 생성 시각
   * - total_ask_size [double] :	호가 매도 총 잔량
   * - total_bid_size [double] :	호가 매수 총 잔량
   * - orderbook_units [List[Object]] :	호가
   * - ask_price [double] :	매도호가
   * - bid_price [double] :	매수호가
   * - ask_size [double] :	매도 잔량
   * - bid_size [double] :	매수 잔량
   */
  static const String orderBook = '/orderbook';
}
