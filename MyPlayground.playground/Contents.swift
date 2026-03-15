import Foundation

var balance: Double = 200.0

let currency = "Rub/Usd"

var buePrice: Double? = nil

for iteration in 1...10 {
    
    print("\n Цена \(iteration)")
    
    let randomPrice = Double.random(in: 60...100)
    let formattedPrice = String(format: "%.2f", randomPrice)
    
    var decision = "игнор"
    
    if buePrice == nil {

        if randomPrice < 76 {
            
            buePrice = randomPrice
            decision = "покупка"
            print("\(formattedPrice) \(currency) - \(decision)")
            print(" куплено по цене \(formattedPrice)")
            
        } else {
            
            print("\(formattedPrice) \(currency) - \(decision)")
            
        }
        
    } else {
        
        let entryPrice = buePrice!
        
        if randomPrice > 80 {
            
            let profit = randomPrice - entryPrice
            balance += profit
            
            print("\(formattedPrice) \(currency) - продажа")
            print("Продажа  From = \(String(format: "%.2f", entryPrice)) -> TO =\(formattedPrice), INCOME = \(String(format: "%.2f", profit))")
            
            print("Новый баланс: \(String(format: "%.2f", balance))")
            
            buePrice = nil
            
        } else {
            
            print("\(formattedPrice) \(currency) - \(decision) (держим)")
            
        }
    }
}

print("\n=== ИТОГОВЫЙ РЕЗУЛЬТАТ ===")
print("Баланс: \(String(format: "%.2f", balance)) \(currency)")
print("Прибыль/убыток: \(String(format: "%.2f", balance - 200.0)) \(currency)")
