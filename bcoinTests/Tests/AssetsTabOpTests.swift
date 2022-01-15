//
//  AssetsTabOpTests.swift
//  bcoinTests
//
//  Created by Yury Dubovoy on 11.01.2022.
//

import XCTest

class AssetsTabOpTests: XCTestCase {

    func testLoadAsset() throws {
        
        let expectation = self.expectation(description: "Assets Loading")

        let networkProvider = NetworkProviderDev()
        let testValue = networkProvider.assets
        
        let network = NetworkMock()
        network.assets = testValue
        
        let operation = AssetsTabOpImpl(network: network)
        operation.loadAssets(search: nil, ids: nil, limit: 10, offset: 0) { assets in
            XCTAssertEqual(testValue, assets)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)

    }

    func testOpenAsset() throws {

        let networkProvider = NetworkProviderDev()
        let asset = networkProvider.assets[0]
        
        let network = NetworkMock()
        let operation = AssetsTabOpImpl(network: network)
        
        var testFlag = false
        operation.onOpenAsset = { _ in
            testFlag = true
        }
        operation.openAsset(asset)
        
        XCTAssertTrue(testFlag)

    }

}
