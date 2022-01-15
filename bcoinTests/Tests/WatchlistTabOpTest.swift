//
//  WatchlistTabOpTest.swift
//  bcoinTests
//
//  Created by Yury Dubovoy on 12.01.2022.
//

import XCTest

class WatchlistTabOpTest: XCTestCase {

    func testStartLoading() throws {

        let netvorkProvider = NetworkProviderDev()
        let testValue = netvorkProvider.assets
        
        let storage = StorageMock()
        storage.watchlist = testValue
        
        var testFlag = false
        
        let operation = WatchlistTabOpImpl(storage: storage)
        operation.onDataUpdate = {
            testFlag = true
        }

        let holder = OperationHolderImpl()
        operation.launch(holder: holder)
        
        XCTAssertEqual(testValue, operation.assets)
        XCTAssertTrue(testFlag)

    }

    func testReload() throws {

        let bundle = Bundle(for: type(of: self.self))
        let testValue = CoincapAPI.Asset.fromFile(fileName: "assets_100", bundle: bundle)
        
        let storage = StorageMock()
        storage.watchlist = testValue

        let operation = WatchlistTabOpImpl(storage: storage)
        operation.reload()

        XCTAssertEqual(testValue, operation.assets)

    }

    func testRemoveAsset() throws {

        let netvorkProvider = NetworkProviderDev()
        let testAssets = netvorkProvider.assets
        let testAsset = testAssets[0]

        let storage = StorageMock()
        storage.watchlist = testAssets
        
        let operation = WatchlistTabOpImpl(storage: storage)

        let holder = OperationHolderImpl()
        operation.launch(holder: holder)
        
        operation.removeAsset(testAsset)
        
        XCTAssertEqual(operation.assets, Array(testAssets[1...]))
        XCTAssertEqual(storage.watchlist, Array(testAssets[1...]))

    }



}
