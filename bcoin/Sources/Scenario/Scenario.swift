//
//  Scenario.swift
//  bcoin
//
//  Created by Yury Dubovoy on 10.01.2022.
//

import Foundation


protocol Scenario {
    func launch()
}


final class ScenarioImpl: NSObject, Scenario {

    
    // MARK: - Scenario

    func launch() {
        let operation = operationFactory.makeServices()
        operation.onFinish = { [weak self] services in
            self?.infoPlistProvider = services.infoPlistProvider
            self?.network = services.network
            self?.storage = services.storage
            self?.onServicesReady()
        }
        operation.launch(holder: operationHolder)
    }

    
    // MARK: - ScenarioImpl

    private let operationFactory: OperationFactory
    private let operationHolder: OperationHolder

    private var router: Router!
    private var infoPlistProvider: InfoPlistProvider!
    private var network: Network!
    private var storage: Storage!

    weak var assetsTabOp: AssetsTabOpInterface?
    weak var watchlistTabOp: WatchlistTabOpInterface?
    weak var settingsTabOp: SettingsTabOpInterface?
    
    private let assetDetailsOps: NSHashTable<AnyObject> = .weakObjects()

    init(operationFactory: OperationFactory, operationHolder: OperationHolder) {
        self.operationFactory = operationFactory
        self.operationHolder = operationHolder
    }

    
    private func onServicesReady() {

        Logger.shared.log("onServicesReady")

        let operation = operationFactory.makeRouter()
        operation.onFinish = { [weak self] router in
            self?.router = router
            self?.onRouterReady()
        }
        operation.launch(holder: operationHolder)

    }

    private func onRouterReady() {
                
        Logger.shared.log("onRouterReady")

        router.openLaunchScreen { [weak self] in
            self?.openTabs()
        }
        
    }
    
    private func openTabs() {

        let assetsTabOp = operationFactory.assetsTab(network: network)
        assetsTabOp.onOpenAsset = { [weak self] asset in
            self?.openAsset(asset)
        }
        self.assetsTabOp = assetsTabOp
        assetsTabOp.launch(holder: operationHolder)

        
        let watchlistTabOp = operationFactory.watchlistTab(storage: storage)
        watchlistTabOp.onOpenAsset = { [weak self] asset in
            self?.openAsset(asset)
        }
        watchlistTabOp.onWatchlistChange = { [weak self]  in
            guard let self = self else { fatalError() }
            // TODO: testme
            let ops = self.assetDetailsOps.allObjects.compactMap{ $0 as? AssetDetailsOp }
            ops.forEach { $0.updateWatchStatus() }
        }
        self.watchlistTabOp = watchlistTabOp
        watchlistTabOp.launch(holder: operationHolder)

        
        let settingsTabOp = operationFactory.settingsTab(router: router, storage: storage)
        self.settingsTabOp = settingsTabOp
        settingsTabOp.launch(holder: operationHolder)
        
        
        router.openTabs(
            assetsTabOp: assetsTabOp,
            watchlistTabOp: watchlistTabOp,
            settingsTabOp: settingsTabOp,
            activeTabIndex: 0)

        Logger.shared.log("onTabsReady")

    }
    
    private func openAsset(_ asset: CoincapAPI.Asset) {

        Logger.shared.log("openAsset")
        
        let assetDetailsOp = operationFactory.assetDetails(
            network: network, router: router, storage: storage)
        assetDetailsOp.onChangeWatchStatus = { [weak self] in
            self?.watchlistTabOp?.reload()
            // TODO: testme
            guard let self = self else { fatalError() }
            let ops = self.assetDetailsOps.allObjects.compactMap{ $0 as? AssetDetailsOp }
            ops.forEach { $0.updateWatchStatus() }
        }
        assetDetailsOps.add(assetDetailsOp)
        assetDetailsOp.launch(asset: asset, holder: operationHolder)

    }

}
