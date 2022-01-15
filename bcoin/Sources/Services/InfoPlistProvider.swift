//
//  InfoPlistProvider.swift
//  bcoin
//
//  Created by Yury Dubovoy on 10.01.2022.
//


import Foundation


protocol InfoPlistProvider {
    var apiBaseURL: URL { get }
    var bundleId: String { get }
}


final class InfoPlistProviderImpl: InfoPlistProvider {

    static let shared: InfoPlistProvider = InfoPlistProviderImpl()

    private enum InfoKey: String {
        case bundleId                 = "CFBundleIdentifier"
        case apiVersion               = "API_VERSION"
        case apiURL                   = "API_URL"
    }

    private let dict = Bundle.main.infoDictionary

    var bundleId: String { value(forKey: .bundleId) }
    var apiVersion: String { value(forKey: .apiVersion) }
    var apiBaseURL: URL { URL(string: value(forKey: .apiURL) + value(forKey: .apiVersion))! }

    private func value<T>(forKey key: InfoKey) -> T {
        guard let info = dict, let val = info[key.rawValue] as? T else {
            fatalError("Info.plist: Not found value for key '\(key)'")
        }
        return val
    }
}
