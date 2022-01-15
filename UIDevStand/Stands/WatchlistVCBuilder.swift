//
//  WatchlistVCBuilder.swift
//  UIDevStand
//
//  Created by Yury Dubovoy on 12.01.2022.
//

import UIKit


class WatchlistVCBuilder {

    static let operationHolder = OperationHolderImpl()

    static func make() -> UIViewController {
        
        let networkProvider = NetworkProviderDev()

        let storage = StorageMock()
        storage.watchlist = Array(networkProvider.assets[0...3])

        let operation = WatchlistTabOpImpl(storage: storage)
        
        let vc = WatchlistVC(operation: operation)
        
        let navBackHandler = NavBackHandlerMock()
        
        let navVC = BaseNavigationController(
            rootViewController: vc,
            navBackHandler: navBackHandler)

        let tabSwitchHandler = TabSwitchHandlerMock()

        let tabsVC = BaseTabBarController(tabSwitchHandler: tabSwitchHandler)
        tabsVC.viewControllers = [navVC]
        tabsVC.selectedIndex = 0
        
        operation.launch(holder: operationHolder)

        return tabsVC
    }

}
