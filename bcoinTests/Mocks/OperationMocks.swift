//
//  OperationsMock.swift
//  bcoinTests
//
//  Created by Yury Dubovoy on 11.01.2022.
//


final class AssetDetailsOpMock: BaseOperation, AssetDetailsOp {
    
    var onError: Func<String>?
    
    

    // MARK: - AssetDetailsOp
    
    func launch(asset: CoincapAPI.Asset, holder: OperationHolder) {

    }
    
    func updateWatchStatus() {

    }

    
    // MARK: - AssetDetailsOpInterface

    var asset: CoincapAPI.Asset?

    var histPrices: [CoincapAPI.HistPrice] = []
    
    var isLoading: Bool = false

    var isWatched: Bool = false

    func changeWatchStatus(completion: () -> Void) {

    }

    
    // MARK: - AssetDetailsOpDelegate

    var onChangeWatchStatus: Block?
    
    var onDataUpdate: Block?


}



final class AssetsTabOpMock: BaseOperation, AssetsTabOp {

    
    // MARK: - AssetsTabOpInterface

    var isLoading: Bool = false

    func loadAssets(search: String?, ids: String?, limit: Int?, offset: Int?, completion: @escaping Func<[CoincapAPI.Asset]>) {
        
    }
    

    func openAsset(_ asset: CoincapAPI.Asset) {

    }

    
    // MARK: - AssetsTabOpDelegate
    
    var onDataUpdate: Block?

    var onError: Func<String>?

    var onOpenAsset: Func<CoincapAPI.Asset>?
    

}


final class MakeRouterOpMock: BaseOperation, MakeRouterOp {

    
    // MARK: MakeRouterOp
    
    var onFinish: Func<Router>?

    
    // MARK: MakeRouterOpMock

    var router = RouterMock()
    
    var wasLaunched = false

    override func launch(holder: OperationHolder) {
        super.launch(holder: holder)
        
        wasLaunched = true
        
        onFinish?(router)
    }
}


final class MakeServicesOpMock: BaseOperation, MakeServicesOp {

    
    // MARK: MakeServicesOp

    var onFinish: Func<ServiceContainer>?

    
    // MARK: - MakeServicesOpMock

    var infoPlistProviderMock = InfoPlistProviderMock()

    var networkMock = NetworkMock()
    
    var storageMock = StorageMock()
    
    var wasLaunched = false

    override func launch(holder: OperationHolder) {
        super.launch(holder: holder)
        
        wasLaunched = true
        
        let services = ServiceContainer(
            infoPlistProvider: infoPlistProviderMock,
            network: networkMock,
            storage: storageMock)
        
        onFinish?(services)
    }
}


final class SettingsTabOpMock: BaseOperation, SettingsTabOp {

    
    // MARK: - SettingsTabOpInterface

    var availableIcons: [AppIcon] = []
    
    var currentIcon: AppIcon?
    
    func openIconList() {

    }
    
    func setIcon(icon: AppIcon) {
    }

    
    // MARK: - SettingsTabOpDelegate

    var onDataUpdateHandlers: [Block] = []
    
}


final class WatchlistTabOpMock: BaseOperation, WatchlistTabOp {

    
    // MARK: - AssetsTabOpInterface
    
    var assets: [CoincapAPI.Asset] = []
    
    func openAsset(_ asset: CoincapAPI.Asset) {

    }
    
    func reload() {
        wasReloaded = true
    }

    func removeAsset(_ asset: CoincapAPI.Asset) {

    }

    
    // MARK: - AssetsTabOpDelegate
    
    var onDataUpdate: Block?
    
    var onOpenAsset: Func<CoincapAPI.Asset>?

    var onWatchlistChange: Block?

    
    // MARK: - WatchlistTabOpMock

    var wasReloaded = false


}




