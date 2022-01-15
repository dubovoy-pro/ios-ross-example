//
//  SettingsTabOp.swift
//  bcoin
//
//  Created by Yury Dubovoy on 11.01.2022.
//

import Foundation
import UIKit


struct AppIcon: Decodable, Encodable, Equatable {
    let name: String
    let title: String
}


protocol SettingsTabOpInterface: AnyObject {

    var availableIcons: [AppIcon] { get }
    
    var currentIcon: AppIcon? { get }
    
    func openIconList()

    func setIcon(icon: AppIcon)

}


protocol SettingsTabOpDelegate: AnyObject {
    
    var onDataUpdateHandlers: [Block] { get set }

}


protocol SettingsTabOp: Operation, SettingsTabOpInterface, SettingsTabOpDelegate {
}


final class SettingsTabOpImpl: BaseOperation, SettingsTabOp {
    
    
    // MARK: SettingsTabOp

    
    // MARK: SettingsTabOpInterface
    
    let availableIcons = [
        AppIcon(name: "WhiteIcon", title: "White"),
        AppIcon(name: "BlackIcon", title: "Black"),
        AppIcon(name: "YellowIcon", title: "Yellow")
    ]
    
    var currentIcon: AppIcon? {
        return storage.currentIcon
    }
    
    func openIconList() {
        router.openIconList(operation: self)
    }

    func setIcon(icon: AppIcon) {
        storage.currentIcon = icon
        changeIcon(name: icon.name)
        for handler in onDataUpdateHandlers {
            handler()
        }
    }

    // MARK: SettingsTabOpDelegate
    
    var onDataUpdateHandlers: [Block] = []

    
    // MARK: SettingsTabOpImpl

    private weak var router: Router!
    private weak var storage: Storage!

    init(router: Router, storage: Storage) {
        self.router = router
        self.storage = storage
    }
    
    private func changeIcon(name: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIApplication.shared.setAlternateIconName(name)
        }
    }

}
