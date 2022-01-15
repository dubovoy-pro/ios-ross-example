//
//  RouterState.swift
//  bcoin
//
//  Created by Yury Dubovoy on 10.01.2022.
//


import UIKit

class RouterState {
    var topViewController: BaseViewController?
    var navigationController: BaseNavigationController?
    var tabbarController: BaseTabBarController?
}


protocol RouterStateStore {
    func getState() -> RouterState
    func updateState(
        vc: BaseViewController?,
        navVC: BaseNavigationController?,
        tabsVC: BaseTabBarController?)
    func updateState(
        vc: BaseViewController?,
        navVC: BaseNavigationController?)
    func updateState(vc: BaseViewController?)
    func updateState(tabsVC: BaseTabBarController?)
}


final class RouterStateStoreImpl: RouterStateStore {
    
    private var currentState: RouterState = RouterState()
    
    func getState() -> RouterState {
        return currentState
    }

    func updateState(
        vc: BaseViewController?,
        navVC: BaseNavigationController?,
        tabsVC: BaseTabBarController?) {
        currentState.topViewController = vc
        currentState.navigationController = navVC
        currentState.tabbarController = tabsVC
    }

    func updateState(
        vc: BaseViewController?,
        navVC: BaseNavigationController?) {
        currentState.topViewController = vc
        currentState.navigationController = navVC
    }

    func updateState(vc: BaseViewController?) {
        currentState.topViewController = vc
    }

    func updateState(tabsVC: BaseTabBarController?) {
        currentState.tabbarController = tabsVC
    }
    
}
