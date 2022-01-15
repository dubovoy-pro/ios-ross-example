//
//  Network.swift
//  bcoin
//
//  Created by Yury Dubovoy on 10.01.2022.
//

import Foundation


protocol NetworkInterface: AnyObject {
}


protocol NetworkEndpoints: AnyObject {
    
    func getAssets(
        search: String?,
        limit: Int?,
        offset: Int?,
        completion: @escaping NetworkHandler<[CoincapAPI.Asset]>)
    
    func getHistPrices(
        assetId: String,
        start: TimeInterval,
        end: TimeInterval,
        interval: String,
        completion: @escaping NetworkHandler<[CoincapAPI.HistPrice]>
    )

}


protocol Network:
    NetworkInterface,
    NetworkEndpoints
{}


final class NetworkImpl: Network {

    
    // MARK: - NetworkEndpoints
    
    func getAssets(
        search: String?,
        limit: Int?,
        offset: Int?,
        completion: @escaping NetworkHandler<[CoincapAPI.Asset]>
    ) {
        provider.getAssets(
            search: search,
            limit: limit,
            offset: offset,
            completion: completion)
    }
    
    func getHistPrices(
        assetId: String,
        start: TimeInterval,
        end: TimeInterval,
        interval: String,
        completion: @escaping NetworkHandler<[CoincapAPI.HistPrice]>
    ) {
        provider.getHistPrices(
            assetId: assetId,
            start: start,
            end: end,
            interval: interval,
            completion: completion)
    }

    
    // MARK: - NetworkImpl

    private let provider: NetworkProvider
    private let storage: Storage // to save auth token in future
    
    init(storage: Storage, provider: NetworkProvider) {
        self.storage = storage
        self.provider = provider
    }

}
