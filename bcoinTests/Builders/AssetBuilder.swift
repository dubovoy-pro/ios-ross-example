//
//  AssetBuilder.swift
//  bcoinTests
//
//  Created by Yury Dubovoy on 11.01.2022.
//

import Foundation

extension CoincapAPI.Asset {
    static func fromFile(fileName: String, bundle: Bundle) -> [CoincapAPI.Asset] {
        let url = bundle.url(forResource: "JsonEntities/Assets/\(fileName)", withExtension: "json")!
        let jsonData = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        let list = try! decoder.decode(CoincapAPI.List<CoincapAPI.Asset>.self, from: jsonData)
        return list.data
    }
}
