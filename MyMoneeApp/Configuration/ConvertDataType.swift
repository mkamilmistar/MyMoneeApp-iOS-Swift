//
//  AppConfig.swift
//  MyMoneeApp
//
//  Created by MacBook on 14/05/21.
//

import Foundation

// ============================================ CURRENCY TYPE CONVERT

extension Decimal {
    var setDecimalToStringCurrencyWithIDR: String {
        let formatter = NumberFormatter()
        formatter.currencyCode = "IDR"
        formatter.groupingSeparator = "."
        formatter.numberStyle = NumberFormatter.Style.currencyISOCode
        
        if let formatterStr: String = formatter.string(
            from: NSDecimalNumber(decimal: self)) {
            return formatterStr
        } else {
            return "0.0"
        }
    }
    
    var setDecimalToStringCurrency: String {
        let formatter = NumberFormatter()
        
        formatter.groupingSeparator = "."
        formatter.numberStyle = NumberFormatter.Style.decimal
        
        if let formatterStr: String = formatter.string(
            from: NSDecimalNumber(decimal: self)) {
            return formatterStr
        } else {
            return "0.0"
        }
    }
}

extension String {
    var setStringToDecimal: Decimal {
        if let formatterDecimal: Decimal = Decimal(string: self) {
            return formatterDecimal
        } else {
            return 0.0
        }
    }
}
extension Decimal {
    var setDecimalToInt: Int {
        return NSDecimalNumber(decimal: self).intValue
    }
}

extension Decimal {
    var setDecimalToDouble: Double {
        let formatterDouble = Double(truncating: self as NSNumber)
        return formatterDouble
    }
}

// ============================================ END OF CURRENCY TYPE CONVERT

// ============================================ DATE CONVERT
extension Date {
    var setDateToString: String {
        let outputFormat = DateFormatter()
        return outputFormat.string(from: self as Date)
    }
    
    var hour: Int { return Calendar.current.component(.hour, from: self) }
}

extension String {
    var setStringToDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "WIB")
        formatter.locale = NSLocale(localeIdentifier: "id") as Locale
        return formatter.date(from: self)!
    }
    
    var setStringDateFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        let myDate = dateFormatter.date(from: self)
        
        dateFormatter.dateFormat = "d MMMM yyyy' - 'HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "WIB")
        dateFormatter.locale = NSLocale(localeIdentifier: "id") as Locale
        return dateFormatter.string(from: myDate!)
    }
    
//    var setStringDateToISO: String {
//        
//    }
    
}

// ============================================ END OF DATE CONVERT

extension String {
    static func randomCapitalizeWithNumber(length: Int = 6) -> String {
        let base = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return "MM-\(randomString)"
    }
}
