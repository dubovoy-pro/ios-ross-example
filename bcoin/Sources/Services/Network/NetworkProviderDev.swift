//
//  NetworkProviderDev.swift
//  bcoin
//
//  Created by Yury Dubovoy on 12.01.2022.
//

import Foundation

final class NetworkProviderDev: NetworkProvider {
    
    
    // MARK: - NetworkProvider
    
    func getAssets(
        search: String?,
        limit: Int?,
        offset: Int?,
        completion: @escaping NetworkHandler<[CoincapAPI.Asset]>
    ) {
        
        var assets = self.assets
        
        if let offset = offset {
            if offset >= assets.count {
                completion(.success([]))
                return
            }
            assets = Array(assets[offset...])
        }
        
        if var limit = limit {
            if limit > assets.count {
                limit = assets.count
            }
            assets = Array(assets.prefix(limit))
        }
        
        var filteredAssets: [CoincapAPI.Asset] = []
        var hasFilters = false
        
        if let query = search?.lowercased(), query.count > 0 {
            hasFilters = true
            let inNameResult = assets.filter{ $0.name.lowercased().contains(query) }
            filteredAssets.append(contentsOf: inNameResult)

            let inSymbolResult = assets.filter{ $0.symbol.lowercased().contains(query) }
            filteredAssets.append(contentsOf: inSymbolResult)
        }
        
        if hasFilters {
            assets = Array(Set(filteredAssets)) // remove duplicates
            assets = assets.sorted { $0.rank < $1.rank }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(.success(assets))
        }

    }
    
    func getHistPrices(
        assetId: String,
        start: TimeInterval,
        end: TimeInterval,
        interval: String,
        completion: @escaping NetworkHandler<[CoincapAPI.HistPrice]>
    ) {
        let histPrices = self.histPrices
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(.success(histPrices))
        }

    }

    
    // MARK: - NetworkProviderDev
    
    let assets: [CoincapAPI.Asset]
    
    let histPrices: [CoincapAPI.HistPrice]

    let bundle: Bundle
    
    let delay: TimeInterval = 1.0
    
    init() {
        bundle = Bundle(for: type(of: self.self))
        assets = CoincapAPI.Asset.fromFile(fileName: "assets_100", bundle: bundle)
        histPrices = CoincapAPI.HistPrice.fromFile(fileName: "bitcoin_last_24h", bundle: bundle)
    }
    
}
