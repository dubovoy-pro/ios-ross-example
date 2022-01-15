//
//  Asset.swift
//  bcoin
//
//  Created by Yury Dubovoy on 11.01.2022.
//

import Foundation

extension CoincapAPI {

    struct Asset: Decodable, Encodable, Equatable, Hashable {
        
        let changePercent24Hr: String?
        let id: String
        let marketCapUsd: String?
        let name: String
        let priceUsd: String?
        let rank: String
        let supply: String?
        let symbol: String
        let volumeUsd24Hr: String?

        var formattedMarketCap: String? {
            guard let strValue = marketCapUsd else {
                return nil
            }
            guard let value = Double(strValue) else {
                return nil
            }

            return Formatters.shared.bigCurrencyFormatter
                .string(from: NSNumber(value: value))!
        }

        var formattedChangePercent24HrDouble: Double? {
            guard let strValue = changePercent24Hr else {
                return nil
            }
            return (strValue as NSString).doubleValue
        }

        var formattedChangePercent24Hr: String? {
            guard let strValue = changePercent24Hr else {
                return nil
            }
            let accuracy = 100.0
            let value = (strValue as NSString).doubleValue
            let roundedValue = round(value * accuracy) / accuracy
            return "\(roundedValue)%"
        }
        
        var formattedPrice: String? {
            guard let strValue = priceUsd else {
                return nil
            }
            let accuracy = 1000.0
            let value = (strValue as NSString).doubleValue
            let roundedValue = round(value * accuracy) / accuracy
            return "$\(roundedValue)"
        }

        var formattedSupply: String? {
            guard let strValue = supply else {
                return nil
            }
            guard let value = Double(strValue) else {
                return nil
            }

            return Formatters.shared.bigCurrencyFormatter
                .string(from: NSNumber(value: value))!
        }

        var formattedVolume24: String? {
            guard let strValue = volumeUsd24Hr else {
                return nil
            }
            guard let value = Double(strValue) else {
                return nil
            }

            return Formatters.shared.bigCurrencyFormatter
                .string(from: NSNumber(value: value))!
        }
    }

}

