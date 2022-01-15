//
//  DateFormatters.swift
//  bcoin
//
//  Created by Yury Dubovoy on 13.01.2022.
//

import Foundation


final class Formatters {
    
    static var shared = Formatters()
    
    lazy var serverDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        //exapmle: "2021-10-06T09:00:00.000Z"
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    lazy var bigCurrencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()

}

