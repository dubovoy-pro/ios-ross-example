//
//  NetworkMock.swift
//  bcoinTests
//
//  Created by Yury Dubovoy on 11.01.2022.
//

import Foundation


final class NetworkMock: Network {
    
    
    // MARK: NetworkEndpoints

    func getAssets(
        search: String?,
        limit: Int?,
        offset: Int?,
        completion: @escaping NetworkHandler<[CoincapAPI.Asset]>
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { fatalError() }
            completion(.success(self.assets))
            self.onAssetsLoadingFinish?()
        }
    }

    func getHistPrices(
        assetId: String,
        start: TimeInterval,
        end: TimeInterval,
        interval: String,
        completion: @escaping NetworkHandler<[CoincapAPI.HistPrice]>
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { fatalError() }
            completion(.success(self.histPrices))
            self.onHistPricesLoadingFinish?()
        }
    }

    
    // MARK: NetworkMock
    
    let delay: TimeInterval = 0.5

    var onAssetsLoadingFinish: Block?

    var onHistPricesLoadingFinish: Block?

    var assets: [CoincapAPI.Asset] = []
    
    var histPrices: [CoincapAPI.HistPrice] = []

}
