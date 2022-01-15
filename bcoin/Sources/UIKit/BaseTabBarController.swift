//
//  BaseTabBarController.swift
//  bcoin
//
//  Created by Yury Dubovoy on 10.01.2022.
//

import UIKit


class BaseTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private weak var tabSwitchHandler: NavigationTabSwitchHandler?
    
    init(tabSwitchHandler: NavigationTabSwitchHandler) {
        self.tabSwitchHandler = tabSwitchHandler
        super.init(nibName: nil, bundle: nil)
        self.delegate = self
        setupTabBar()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTabBar() {
        
        if #available(iOS 15.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.backgroundColor = .baseGray
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        } else {
            tabBar.backgroundColor = .baseGray
        }
    }
    
    
    // MARK: UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        tabSwitchHandler?.onTabSwitch(index: selectedIndex)
    }

}
