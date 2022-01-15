//
//  OperationFactoryMock.swift
//  bcoinTests
//
//  Created by Yury Dubovoy on 11.01.2022.
//

import Foundation

final class OperationFactoryMock: OperationFactory {

    var assetDetailsOp: AssetDetailsOp?
    var assetsTabOp: AssetsTabOp?
    var makeRouterOp: MakeRouterOp?
    var makeServicesOp: MakeServicesOp?
    var settingsTabOp: SettingsTabOp?
    var watchlistTabOp: WatchlistTabOp?

    func assetDetails(network: Network, router: Router, storage: Storage) -> AssetDetailsOp {
        return assetDetailsOp ?? AssetDetailsOpMock()
    }
    
    func assetsTab(network: Network) -> AssetsTabOp {
        return assetsTabOp ?? AssetsTabOpMock()
    }

    func makeRouter() -> MakeRouterOp {
        return makeRouterOp ?? MakeRouterOpMock()
    }
    
    func makeServices() -> MakeServicesOp {
        return makeServicesOp ?? MakeServicesOpMock()
    }

    func settingsTab(router: Router, storage: Storage) -> SettingsTabOp {
        return settingsTabOp ?? SettingsTabOpMock()
    }
    
    func watchlistTab(storage: Storage) -> WatchlistTabOp {
        return watchlistTabOp ?? WatchlistTabOpMock()
    }
    
    
}
