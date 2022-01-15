//
//  NetworkProviderDelegate.swift
//  bcoin
//
//  Created by Yury Dubovoy on 11.01.2022.
//

import Foundation


protocol NetworkProviderDelegate: AnyObject {

    func getBaseApiUrl() -> URL

}


final class NetworkProviderDelegateImpl: NetworkProviderDelegate {


    // MARK: - NetworkProviderDelegate
    
    func getBaseApiUrl() -> URL {
        return plistInfoProvider.apiBaseURL
    }

    
    // MARK: - NetworkProviderDelegateImpl

    private let plistInfoProvider: InfoPlistProvider
    
    init(plistInfoProvider: InfoPlistProvider) {
        self.plistInfoProvider = plistInfoProvider
    }

}
