//
//  RouterMock.swift
//  bcoinTests
//
//  Created by Yury Dubovoy on 11.01.2022.
//

import Foundation

enum LastRoute {
    case assetDetails
    case iconList
    case launch
    case tabs
}


final class RouterMock: Router {
    
    
    var routerState = RouterState()
    var routeSequence = [LastRoute]()

    var state: RouterState {
        return routerState
    }
    
    var lastRoute: LastRoute?
    
    var activeTabIndex = -1
    
    func setRoute(route: LastRoute) {
        lastRoute = route
        routeSequence.append(route)
    }
    
    var onShowTab: Block?
    
    // MARK: Router
    
    func openAsset(operation: AssetDetailsOp) {
        setRoute(route: .assetDetails)
    }
    
    
    func openIconList(operation: SettingsTabOp) {
        setRoute(route: .iconList)
    }

    func openLaunchScreen(completion: @escaping () -> Void) {
        setRoute(route: .launch)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            completion()
        }
    }
    
    func openTabs(
        assetsTabOp: AssetsTabOp,
        watchlistTabOp: WatchlistTabOp,
        settingsTabOp: SettingsTabOp,
        activeTabIndex: Int)
    {
        setRoute(route: .tabs)
        onShowTab?()
    }

}
