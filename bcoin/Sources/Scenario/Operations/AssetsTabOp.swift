//
//  AssetsTabOp.swift
//  bcoin
//
//  Created by Yury Dubovoy on 11.01.2022.
//

import Foundation


protocol AssetsTabOpInterface: AnyObject {

    var isLoading: Bool { get }
    
    func loadAssets(
        search: String?,
        ids: String?,
        limit: Int?,
        offset: Int?,
        completion: @escaping Func<[CoincapAPI.Asset]>)
    
    func openAsset(_ asset: CoincapAPI.Asset)

}


protocol AssetsTabOpDelegate: AnyObject {
    
    var onDataUpdate: Block? { get set }

    var onError: Func<String>?  { get set }

    var onOpenAsset: Func<CoincapAPI.Asset>?  { get set }

}


protocol AssetsTabOp: Operation, AssetsTabOpInterface, AssetsTabOpDelegate {
}


final class AssetsTabOpImpl: BaseOperation, AssetsTabOp {
    
    // MARK: AssetsTabOp

    
    // MARK: AssetsTabOpInterface

    var isLoading: Bool = false
    
    func loadAssets(
        search: String?,
        ids: String?,
        limit: Int?,
        offset: Int?,
        completion: @escaping Func<[CoincapAPI.Asset]>
    ) {

        Logger.shared.log("Get assets in Assets Tab")

        network.getAssets(
            search: search,
            limit: limit,
            offset: offset
        ) { [weak self] result in
            guard let self = self else { fatalError() }
            
            self.isLoading = false

            switch result {
            case let .success(assets):
                completion(assets)
            case let .failure(error):
                Logger.shared.log("\(error)")
                completion([])
                self.onError?(error.message)
            }
        }
    }
    
    func openAsset(_ asset: CoincapAPI.Asset) {
        onOpenAsset?(asset)
    }

    
    // MARK: AssetsTabOpDelegate
    
    var onDataUpdate: Block?

    var onError: Func<String>?

    var onOpenAsset: Func<CoincapAPI.Asset>?

    
    // MARK: AssetsTabOpImpl

    private weak var network: Network!

    init(network: Network) {
        self.network = network
    }


}
