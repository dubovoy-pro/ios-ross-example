//
//  OperationFactory.swift
//  bcoin
//
//  Created by Yury Dubovoy on 10.01.2022.
//


import Foundation


protocol OperationFactory {

    func assetDetails(
        network: Network,
        router: Router,
        storage: Storage) -> AssetDetailsOp

    func assetsTab(network: Network) -> AssetsTabOp

    func makeRouter() -> MakeRouterOp

    func makeServices() -> MakeServicesOp

    func settingsTab(
        router: Router,
        storage: Storage) -> SettingsTabOp

    func watchlistTab(storage: Storage) -> WatchlistTabOp

}


class OperationFactoryImpl: OperationFactory {
    
    func assetDetails(
        network: Network,
        router: Router,
        storage: Storage
    ) -> AssetDetailsOp {
        return AssetDetailsOpImpl(network: network, router: router, storage: storage)
    }

    func assetsTab(network: Network) -> AssetsTabOp {
        return AssetsTabOpImpl(network: network)
    }

    func makeRouter() -> MakeRouterOp {
        return MakeRouterOpImpl()
    }

    func makeServices() -> MakeServicesOp {
        return MakeServicesOpImpl()
    }

    func settingsTab(router: Router, storage: Storage) -> SettingsTabOp {
        return SettingsTabOpImpl(router: router, storage: storage)
    }

    func watchlistTab(storage: Storage) -> WatchlistTabOp {
        return WatchlistTabOpImpl(storage: storage)
    }

}
