import Foundation

enum TradeType {
    case buy
    case sell
    case hold
    case ignore
}

struct PriceData {
    let value: Double
    let currency: String
    
    var formattedValue: String {
        return String(format: "%.2f", value)
    }
}

protocol TradingProtocol {
    var balance: Double { get set }
    var currency: String { get }
    
    func makeDecision(price: Double) -> TradeType
}

class TradingSimulator: TradingProtocol {
    
    public var balance: Double
    public let currency: String
    private var buyPrice: Double?
    private var stopProfit: Double = 80.0
    
    var hasOpenPosition: Bool {
        return buyPrice != nil
    }
    
    var currentPositionPrice: Double? {
        return buyPrice
    }
    
    init(initialBalance: Double, currency: String) {
        self.balance = initialBalance
        self.currency = currency
        self.buyPrice = nil
    }
    
    func setStopProfit(_ value: Double) {
        self.stopProfit = value
    }
    
    func makeDecision(price: Double) -> TradeType {
        if buyPrice == nil {
            if price < 76 {
                return .buy
            } else {
                return .ignore
            }
        } else {
            if price > stopProfit {
                return .sell
            } else {
                return .hold
            }
        }
    }
    
    private func calculateProfit(entryPrice: Double, exitPrice: Double) -> Double {
        return exitPrice - entryPrice
    }
    
    func executeTrade(price: Double) {
        let decision = makeDecision(price: price)
        let priceData = PriceData(value: price, currency: currency)
        
        switch decision {
        case .buy:
            buyPrice = price
            print("\(priceData.formattedValue) \(currency) - ПОКУПКА")
            print("Куплено по цене \(priceData.formattedValue) \(currency)")
            
        case .sell:
            if let entryPrice = buyPrice {
                let profit = calculateProfit(entryPrice: entryPrice, exitPrice: price)
                balance += profit
                
                print("\(priceData.formattedValue) \(currency) - ПРОДАЖА")
                print("Вход: \(String(format: "%.2f", entryPrice)) → Выход: \(priceData.formattedValue)")
                let profitSymbol = profit >= 0 ? "📈" : "📉"
                print("\(profitSymbol) Прибыль: \(String(format: "%.2f", profit)) \(currency)")
                print("Новый баланс: \(String(format: "%.2f", balance)) \(currency)")
                
                buyPrice = nil
            }
            
        case .hold:
            print("\(priceData.formattedValue) \(currency) - ДЕРЖИМ")
            print("Ожидаем роста до \(String(format: "%.2f", stopProfit))")
            
        case .ignore:
            print("\(priceData.formattedValue) \(currency) - ИГНОР")
            print("Цена не подходит для входа")
        }
    }
}

extension TradingSimulator {
    
    func runSimulation(iterations: Int, priceRange: ClosedRange<Double>) {
        print("Диапазон цен: \(Int(priceRange.lowerBound))...\(Int(priceRange.upperBound))")
        print("Стоп-профит: \(String(format: "%.2f", stopProfit)) \(currency)")
        print("Начальный баланс: \(String(format: "%.2f", balance)) \(currency)")
        print("----------------------------------------\n")
        
        for iteration in 1...iterations {
            print("Шаг \(iteration)/\(iterations)")
            let randomPrice = Double.random(in: priceRange)
            executeTrade(price: randomPrice)
            print("")
        }
    }
    
    func printFinalResult() {
        print("\n========================================")
        print("          ИТОГОВЫЙ РЕЗУЛЬТАТ")
        print("========================================")
        print("Баланс: \(String(format: "%.2f", balance)) \(currency)")
        
        let profit = balance - 200.0
        if profit >= 0 {
            print("Общая прибыль: +\(String(format: "%.2f", profit)) \(currency)")
        } else {
            print("Общий убыток: \(String(format: "%.2f", profit)) \(currency)")
        }
        
        if hasOpenPosition {
            print("Открытая позиция: \(String(format: "%.2f", currentPositionPrice ?? 0)) \(currency)")
            print("   (ожидаем продажи при достижении \(String(format: "%.2f", stopProfit)))")
        }
        print("========================================")
    }
}
