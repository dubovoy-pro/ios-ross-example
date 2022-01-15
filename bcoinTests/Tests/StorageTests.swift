//
//  StorageTests.swift
//  bcoinTests
//
//  Created by Yury Dubovoy on 11.01.2022.
//

import XCTest

class StorageTests: XCTestCase {

    func testWatchlist() throws {
        
        let storage = StorageImpl()

        let testValue =  [
            CoincapAPI.Asset(
                changePercent24Hr: "some_change",
                id: "some_id",
                marketCapUsd: "some_cap",
                name: "some_name",
                priceUsd: "some_price",
                rank: "some_rank",
                supply: "some_supply",
                symbol: "some_symbol",
                volumeUsd24Hr: "some_volume"
            )
        ]
        storage.watchlist = testValue
        
        XCTAssertEqual(testValue, storage.watchlist)
        
    }

    func testIconKey() throws {
        
        let storage = StorageImpl()
        
        let testValue = AppIcon(name: "any_icon", title: "Any Icon")
        storage.currentIcon = testValue
        
        XCTAssertEqual(testValue, storage.currentIcon)
        
    }

}
