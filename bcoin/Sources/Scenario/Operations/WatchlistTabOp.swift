//
//  WatchlistTabOp.swift
//  bcoin
//
//  Created by Yury Dubovoy on 11.01.2022.
//

import Foundation


protocol WatchlistTabOpInterface: AnyObject {
    
    var assets: [CoincapAPI.Asset] { get }
    
    func openAsset(_ asset: CoincapAPI.Asset)
    
    func reload()
    
    func removeAsset(_ asset: CoincapAPI.Asset)

}


protocol WatchlistTabOpDelegate: AnyObject {
    
    var onDataUpdate: Block? { get set }
    
    var onOpenAsset: Func<CoincapAPI.Asset>?  { get set }
    
    var onWatchlistChange: Block? { get set }

}


protocol WatchlistTabOp: Operation, WatchlistTabOpInterface, WatchlistTabOpDelegate {
}


final class WatchlistTabOpImpl: BaseOperation, WatchlistTabOp {
    
    // MARK: WatchlistTabOp
    
    override func launch(holder: OperationHolder) {
        super.launch(holder: holder)
        loadData()
    }

    
    // MARK: WatchlistTabOpInterface

    var assets: [CoincapAPI.Asset] = []

    func openAsset(_ asset: CoincapAPI.Asset) {
        onOpenAsset?(asset)
    }
    
    func reload() {
        loadData()
    }

    func removeAsset(_ asset: CoincapAPI.Asset) {
        storage.watchlist = storage.watchlist.filter { $0 != asset }
        onWatchlistChange?() // TODO: testme
        loadData()
    }

    
    // MARK: WatchlistTabOpDelegate
    
    var onDataUpdate: Block?

    var onOpenAsset: Func<CoincapAPI.Asset>?
    
    var onWatchlistChange: Block?

    
    // MARK: WatchlistTabOpImpl
    
    private weak var storage: Storage!

    init(storage: Storage) {
        self.storage = storage
    }
    
    private func loadData() {
        assets = storage.watchlist
        onDataUpdate?()
    }
    


}
