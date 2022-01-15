//
//  AssetDetailsVCBuilder.swift
//  UIDevStand
//
//  Created by Yury Dubovoy on 12.01.2022.
//

import UIKit


class AssetDetailsVCBuilder {

    static var holder: [Any] =  []

    static let operationHolder = OperationHolderImpl()

    static func make() -> UIViewController {
        
        let router = RouterMock()
        let storage = StorageMock()
        let networkProvider = NetworkProviderDev()
        let network = NetworkImpl(storage: storage, provider: networkProvider)
        let operation = AssetDetailsOpImpl(network: network, router: router, storage: storage)
        
        let vc = AssetDetailsVC(operation: operation)
        
        let navBackHandler = NavBackHandlerMock()
        
        let navVC = BaseNavigationController(
            rootViewController: vc,
            navBackHandler: navBackHandler)

        let tabSwitchHandler = TabSwitchHandlerMock()

        let tabsVC = BaseTabBarController(tabSwitchHandler: tabSwitchHandler)
        tabsVC.viewControllers = [navVC]
        tabsVC.selectedIndex = 0
        
        let asset = networkProvider.assets[0]
        
        operation.launch(asset: asset, holder: operationHolder)
        
        AssetDetailsVCBuilder.holder.append(network) // prevents premature deallocation

        return tabsVC
    }

}
