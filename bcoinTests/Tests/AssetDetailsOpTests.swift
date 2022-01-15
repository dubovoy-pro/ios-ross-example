//
//  AssetDetailsOpTests.swift
//  bcoinTests
//
//  Created by Yury Dubovoy on 12.01.2022.
//

import XCTest

class AssetDetailsOpTests: XCTestCase {

    static var holder: [Any] =  []

    func testLaunch() throws {

        let expectation = self.expectation(description: "Price History Loading")

        let networkProvider = NetworkProviderDev()
        let testAsset = networkProvider.assets[0]

        let network = NetworkMock()
        AssetDetailsOpTests.holder.append(network) // prevents premature deallocation

        let router = RouterMock()
        let storage = StorageMock()
        
        let holder = OperationHolderImpl()
        

        let operation = AssetDetailsOpImpl(network: network, router: router, storage: storage)

        network.onHistPricesLoadingFinish = {
            XCTAssertEqual(testAsset, operation.asset)
            XCTAssertEqual(.assetDetails, router.lastRoute)
            expectation.fulfill()
        }

        operation.launch(asset: testAsset, holder: holder)

        
        wait(for: [expectation], timeout: 1)

    }

    func testWatchStatusTrue() throws {

        let networkProvider = NetworkProviderDev()
        let testAssets = Array(networkProvider.assets[0...5])
        let testAsset = testAssets[0]

        let network = NetworkMock()
        AssetDetailsOpTests.holder.append(network) // prevents premature deallocation

        let router = RouterMock()
        
        let storage = StorageMock()
        storage.watchlist = testAssets
        
        let holder = OperationHolderImpl()
        
        let operation = AssetDetailsOpImpl(network: network, router: router, storage: storage)
        
        operation.launch(asset: testAsset, holder: holder)
        
        XCTAssertTrue(operation.isWatched)

    }

    func testWatchStatusFalse() throws {

        let networkProvider = NetworkProviderDev()
        let testAssets = Array(networkProvider.assets[0...5])
        let testAsset = networkProvider.assets[6]

        let network = NetworkMock()
        AssetDetailsOpTests.holder.append(network) // prevents premature deallocation

        let router = RouterMock()
        
        let storage = StorageMock()
        storage.watchlist = testAssets
        
        let holder = OperationHolderImpl()
        
        let operation = AssetDetailsOpImpl(network: network, router: router, storage: storage)
        
        operation.launch(asset: testAsset, holder: holder)
        
        XCTAssertFalse(operation.isWatched)

    }

    func testWatchStatusChange() throws {

        let networkProvider = NetworkProviderDev()
        let testAssets = Array(networkProvider.assets[0...5])
        let testAsset = testAssets[0]

        let network = NetworkMock()
        AssetDetailsOpTests.holder.append(network) // prevents premature deallocation

        let router = RouterMock()
        
        let storage = StorageMock()
        storage.watchlist = testAssets
        
        let holder = OperationHolderImpl()
        
        var testFlag = false

        let operation = AssetDetailsOpImpl(network: network, router: router, storage: storage)
        operation.onChangeWatchStatus = {
            testFlag = true
        }
        
        operation.launch(asset: testAsset, holder: holder)
        
        operation.changeWatchStatus {}

        XCTAssertTrue(testFlag)
        XCTAssertFalse(operation.isWatched)

    }

}
