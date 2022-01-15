//
//  HistPrice.swift
//  bcoin
//
//  Created by Yury Dubovoy on 13.01.2022.
//

import Foundation

extension CoincapAPI {

    struct HistPrice: Decodable, Equatable {
        
        let date: String
        let priceUsd: String
        let time: TimeInterval

    }

}


extension CoincapAPI.HistPrice {


    var dateObj: Date {
        return Formatters.shared
            .serverDateFormatter.date(from: date) ?? errorDate
    }

    private var errorDate: Date {
        return Date(timeIntervalSince1970: 0)
    }
    
    var formattedPrice: String {
        let accuracy = 1000.0
        let value = (priceUsd as NSString).doubleValue
        let roundedValue = round(value * accuracy) / accuracy
        return "$\(roundedValue)"
    }

    var priceUsdDouble: Double {
        return (priceUsd as NSString).doubleValue
    }

}

