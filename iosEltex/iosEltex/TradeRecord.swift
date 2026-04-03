import Foundation

struct TradeRecord {
    let iteration: Int
    let price: Double
    let currency: String
    let type: TradeType
    var hasTradeExecuted: Bool = false
    var tradeInfo: String?
}
