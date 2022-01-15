//
//  Storage.swift
//  bcoin
//
//  Created by Yury Dubovoy on 10.01.2022.
//

import Foundation


protocol Storage: AnyObject {

    var watchlist: Array<CoincapAPI.Asset> { get set }
    
    var currentIcon: AppIcon? { get set }

}


final class StorageImpl: Storage {
    
    let storage = UserDefaults.standard

    let jsonDecoder = JSONDecoder()

    let jsonEncoder = JSONEncoder()

    let watchlistKey = "WATCHLIST_KEY"
    var watchlist: Array<CoincapAPI.Asset> {
        get {
            if let jsonData = storage.value(forKey: watchlistKey) as? Data {
                if let value = try? jsonDecoder.decode(Array<CoincapAPI.Asset>.self, from: jsonData) {
                    return value
                }
            }
            return []
        }
        set {
            guard let jsonData = try? jsonEncoder.encode(newValue) else { fatalError() }
            storage.set(jsonData, forKey: watchlistKey)
        }
    }

    let currentIconKey = "CURRENT_APP_ICON"
    var currentIcon: AppIcon? {
        get {
            if let jsonData = storage.value(forKey: currentIconKey) as? Data {
                if let value = try? jsonDecoder.decode(AppIcon.self, from: jsonData) {
                    return value
                }
            }
            return nil
        }
        set {
            guard let jsonData = try? jsonEncoder.encode(newValue) else { fatalError() }
            storage.set(jsonData, forKey: currentIconKey)
        }
    }

}
