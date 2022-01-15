//
//  Utils.swift
//  UIDevStand
//
//  Created by Yury Dubovoy on 12.01.2022.
//

import Foundation


final class NavBackHandlerMock: NavigationBackHandler {
    func onGoBack() {}
    func onDismiss() {}
}


final class TabSwitchHandlerMock: NavigationTabSwitchHandler {
    func onTabSwitch(index: Int) {}
}
