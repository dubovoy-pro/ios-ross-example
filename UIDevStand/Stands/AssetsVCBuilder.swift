//
//  AssetsVCBuilder.swift
//  UIDevStand
//
//  Created by Yury Dubovoy on 11.01.2022.
//

import UIKit


class AssetsVCBuilder {

    static var holder: [Any] =  []

    static let operationHolder = OperationHolderImpl()

    static func make() -> UIViewController {
        
        let storage = StorageMock()
        let networkProvider = NetworkProviderDev()
        let network = NetworkImpl(storage: storage, provider: networkProvider)
        let operation = AssetsTabOpImpl(network: network)
        
        let vc = AssetsVC(operation: operation)
        
        let navBackHandler = NavBackHandlerMock()
        
        let navVC = BaseNavigationController(
            rootViewController: vc,
            navBackHandler: navBackHandler)

        let tabSwitchHandler = TabSwitchHandlerMock()

        let tabsVC = BaseTabBarController(tabSwitchHandler: tabSwitchHandler)
        tabsVC.viewControllers = [navVC]
        tabsVC.selectedIndex = 0
        
        operation.launch(holder: operationHolder)
        
        AssetsVCBuilder.holder.append(network) // prevents premature deallocation

        return tabsVC
    }

}
