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
    
    
    func makeDecision(price: Double) -> TradeType {
        
        if buyPrice == nil {
            
            if price < 76 {
                
                return .buy
                
            } else {
                
                return .ignore
                
            }
            
        } else {
            
            if price > 80 {
                
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
            print("\(priceData.formattedValue) \(currency) - покупка")
            print(" куплено по цене \(priceData.formattedValue)")
            
        case .sell:
            if let entryPrice = buyPrice {
                let profit = calculateProfit(entryPrice: entryPrice, exitPrice: price)
                balance += profit
                
                print("\(priceData.formattedValue) \(currency) - продажа")
                print("Продажа From = \(String(format: "%.2f", entryPrice)) -> TO = \(priceData.formattedValue), INCOME = \(String(format: "%.2f", profit))")
                print("Новый баланс: \(String(format: "%.2f", balance))")
                
                buyPrice = nil
            }
            
        case .hold:
            print("\(priceData.formattedValue) \(currency) - игнор (держим)")
            
        case .ignore:
            print("\(priceData.formattedValue) \(currency) - игнор")
            
        }
    }
}


extension TradingSimulator {
    
    func runSimulation(iterations: Int, priceRange: ClosedRange<Double>) {
        
        for iteration in 1...iterations {
            
            print("\n Цена \(iteration)")
            let randomPrice = Double.random(in: priceRange)
            executeTrade(price: randomPrice)
            
        }
    }
    
    func printFinalResult() {
        
        print("\n=== ИТОГОВЫЙ РЕЗУЛЬТАТ ===")
        print("Баланс: \(String(format: "%.2f", balance)) \(currency)")
        print("Прибыль/убыток: \(String(format: "%.2f", balance - 200.0)) \(currency)")
    }
}


let simulator = TradingSimulator(initialBalance: 200.0, currency: "Rub/Usd")

simulator.runSimulation(iterations: 10, priceRange: 60...100)

simulator.printFinalResult()

