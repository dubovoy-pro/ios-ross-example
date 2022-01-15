//
//  AssetDetailsOp.swift
//  bcoin
//
//  Created by Yury Dubovoy on 12.01.2022.
//

import Foundation


protocol AssetDetailsOpInterface: AnyObject {

    var asset: CoincapAPI.Asset? { get }

    var histPrices: [CoincapAPI.HistPrice] { get }

    var isLoading: Bool { get }

    var isWatched: Bool { get }
    
    func changeWatchStatus(completion: Block)

    func updateWatchStatus()

}


protocol AssetDetailsOpDelegate: AnyObject {
    
    var onChangeWatchStatus: Block? { get set }
    
    var onDataUpdate: Block? { get set }

    var onError: Func<String>?  { get set }

}


protocol AssetDetailsOp: Operation, AssetDetailsOpInterface, AssetDetailsOpDelegate {

    func launch(asset: CoincapAPI.Asset, holder: OperationHolder)

}


final class AssetDetailsOpImpl: BaseOperation, AssetDetailsOp {
    
    // MARK: AssetDetailsOp
    
    func launch(asset: CoincapAPI.Asset, holder: OperationHolder) {
        super.launch(holder: holder)
        self.asset = asset
        loadData() // TODO: testme
        router.openAsset(operation: self)
    }

    
    // MARK: AssetDetailsOpInterface

    var asset: CoincapAPI.Asset?

    var histPrices: [CoincapAPI.HistPrice] = []

    var isLoading = false

    var isWatched: Bool {
        guard let asset = asset else {
            return false
        }
        return storage.watchlist.contains(asset)
    }
    
    func changeWatchStatus(completion: Block) {
        guard let asset = asset else {
            completion()
            return
        }
        if isWatched {
            storage.watchlist = storage.watchlist.filter { $0 != asset }
        } else {
            storage.watchlist.append(asset)
        }
        onChangeWatchStatus?()
        completion()
    }

    func updateWatchStatus() {
        onDataUpdate?()
    }

    
    // MARK: AssetDetailsOpDelegate
    
    var onChangeWatchStatus: Block?
    
    var onDataUpdate: Block?

    var onError: Func<String>?

    
    // MARK: AssetDetailsOpImpl
    
    private weak var network: Network!
    private weak var router: Router!
    private weak var storage: Storage!

    init(network: Network, router: Router, storage: Storage) {
        self.network = network
        self.router = router
        self.storage = storage
    }
    
    private func loadData() {

        Logger.shared.log("Get price history in Asset Details")


        guard let asset = asset else { return }
        
        let endDate = Date()
        let startDate = endDate.addingTimeInterval(-60 * 60 * 24) // minus one day

        let startInterval = round(startDate.timeIntervalSince1970 * 1000)
        let endInterval = round(endDate.timeIntervalSince1970 * 1000)

        network.getHistPrices(
            assetId: asset.id,
            start: startInterval,
            end: endInterval,
            interval: "m5") { [weak self] result in
                guard let self = self else { return }
                
                self.isLoading = false

                switch result {
                case let .success(histPrices):
                    self.histPrices = histPrices // TODO: testme
                    self.onDataUpdate?()
                case let .failure(error):
                    Logger.shared.log("\(error)")
                    self.histPrices = []
                    self.onDataUpdate?()
                    self.onError?(error.message)
                }
            }
    }


}
