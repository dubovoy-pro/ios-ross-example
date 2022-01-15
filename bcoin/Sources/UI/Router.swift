//
//  Router.swift
//  bcoin
//
//  Created by Yury Dubovoy on 10.01.2022.
//


import UIKit


protocol NavigationBackHandler: AnyObject {

    func onGoBack()

    func onDismiss()

}


protocol NavigationTabSwitchHandler: AnyObject {

    func onTabSwitch(index: Int)

}


protocol Router: AnyObject {

    func openAsset(operation: AssetDetailsOp)

    func openLaunchScreen(completion: @escaping () -> Void)
 
    func openIconList(operation: SettingsTabOp)

    func openTabs(
        assetsTabOp: AssetsTabOp,
        watchlistTabOp: WatchlistTabOp,
        settingsTabOp: SettingsTabOp,
        activeTabIndex: Int)
}


final class RouterImpl:
    Router,
    NavigationBackHandler,
    NavigationTabSwitchHandler
{

    
    // MARK: NavigationBackHandler
    
    func onGoBack() {
        handleGoBackOrDismission()
    }

    func onDismiss() {
        handleGoBackOrDismission()
    }

    
    // MARK: NavigationTabSwitchHandler
    
    func onTabSwitch(index: Int) {
        let tabBarController = stateStore.getState().tabbarController
        let selectedNavVC = tabBarController?.viewControllers?[index] as? BaseNavigationController
        stateStore.updateState(
            vc: selectedNavVC?.topViewController as? BaseViewController,
            navVC: selectedNavVC)
    }

    
    // MARK: Router

    func openAsset(operation: AssetDetailsOp) {
        if let navVC = stateStore.getState().navigationController {
            let vc = AssetDetailsVC(operation: operation)
            navVC.pushViewController(vc, animated: true)
            stateStore.updateState(vc: vc)
        }
    }
    
    func openIconList(operation: SettingsTabOp) {
        if let navVC = stateStore.getState().navigationController {
            let vc = IconListVC(operation: operation)
            navVC.pushViewController(vc, animated: true)
            stateStore.updateState(vc: vc)
        }
    }

    func openLaunchScreen(completion: @escaping () -> Void) {
        let launchVC = LaunchVC()
        window.rootViewController = launchVC
        UIView.transition(
            with: window, duration: 0.1,
            options: .transitionCrossDissolve,
            animations: nil) { [weak self] _ in
            self?.stateStore.updateState(vc: launchVC)
            completion()
        }
    }

    func openTabs(
        assetsTabOp: AssetsTabOp,
        watchlistTabOp: WatchlistTabOp,
        settingsTabOp: SettingsTabOp,
        activeTabIndex: Int) {
            
        let tabBarController = BaseTabBarController(tabSwitchHandler: self)
        tabBarController.viewControllers = [
            makeAssetsTab(operation: assetsTabOp),
            makeWatchlistTab(operation: watchlistTabOp),
            makeSettingsTab(operation: settingsTabOp),
        ]
        tabBarController.selectedIndex = activeTabIndex
        window.rootViewController = tabBarController
        
        stateStore.updateState(
            vc: (tabBarController.viewControllers?[activeTabIndex] as? BaseNavigationController)?.topViewController as? BaseViewController,
            navVC: tabBarController.viewControllers?[activeTabIndex] as? BaseNavigationController,
            tabsVC: tabBarController)
        }

    
    // MARK: RouterImpl

    private lazy var window: UIWindow = {
        let window = LogSharingWindow()
        window.makeKeyAndVisible()
        return window
    }()
    
    private let stateStore: RouterStateStore
    
    init(stateStore: RouterStateStore) {
        self.stateStore = stateStore
    }

    private func goBack() {
        if let currentNavVC = stateStore.getState().navigationController {
            currentNavVC.popViewController(animated: true) { [weak self] in
                self?.handleGoBackOrDismission()
            }
        }
    }

    private func dismissVC(_ vc: UIViewController, animated: Bool = true) {
        vc.dismiss(animated: animated) { [weak self] in
            self?.handleGoBackOrDismission()
        }
    }
    
    private func handleGoBackOrDismission() {
        let navVC = stateStore.getState().navigationController
        if let topVC = navVC?.topViewController as? BaseViewController {
            stateStore.getState().topViewController = topVC
        }
    }
    
    private func makeAssetsTab(operation: AssetsTabOp) -> UIViewController {
        let vc = AssetsVC(operation: operation)
        let navigationVC = BaseNavigationController(rootViewController: vc, navBackHandler: self)
        return navigationVC
    }
    
    private func makeWatchlistTab(operation: WatchlistTabOp) -> UIViewController {
        let vc = WatchlistVC(operation: operation)
        let navigationVC = BaseNavigationController(rootViewController: vc, navBackHandler: self)
        return navigationVC
    }
    
    private func makeSettingsTab(operation: SettingsTabOp) -> UIViewController {
        let vc = SettingsVC(operation: operation)
        let navigationVC = BaseNavigationController(rootViewController: vc, navBackHandler: self)
        return navigationVC
    }

}
