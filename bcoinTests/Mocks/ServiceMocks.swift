//
//  ServiceMocks.swift
//  bcoinTests
//
//  Created by Yury Dubovoy on 11.01.2022.
//

import Foundation


final class InfoPlistProviderMock: InfoPlistProvider {
    
    var apiBaseURL: URL = URL(fileURLWithPath: "")
    var bundleId: String = ""

}


final class StorageMock: Storage {
    
    var currentIcon: AppIcon?
    
    var watchlist: Array<CoincapAPI.Asset> = []

    var icon: Int = 0

}
