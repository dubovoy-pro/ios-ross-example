//
//  HistPriceBuilder.swift
//  bcoin
//
//  Created by Yury Dubovoy on 13.01.2022.
//

import Foundation

extension CoincapAPI.HistPrice {
    static func fromFile(fileName: String, bundle: Bundle) -> [CoincapAPI.HistPrice] {
        let url = bundle.url(forResource: "JsonEntities/History/\(fileName)", withExtension: "json")!
        let jsonData = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        let list = try! decoder.decode(CoincapAPI.List<CoincapAPI.HistPrice>.self, from: jsonData)
        return list.data
    }
}
