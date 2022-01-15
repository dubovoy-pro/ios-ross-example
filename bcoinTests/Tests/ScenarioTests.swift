//
//  ScenarioTests.swift
//  bcoinTests
//
//  Created by Yury Dubovoy on 11.01.2022.
//

import XCTest

class ScenarionTests: XCTestCase {

    func testOperationCalls() throws {
        
        let operationHolder = OperationHolderImpl()
        
        let makeServicesOp = MakeServicesOpMock()
        
        let makeRouterOp = MakeRouterOpMock()

        let operationFactory = OperationFactoryMock()
        operationFactory.makeServicesOp = makeServicesOp
        operationFactory.makeRouterOp = makeRouterOp
        
        let scenario = ScenarioImpl(operationFactory: operationFactory, operationHolder: operationHolder)
                
        scenario.launch()
        
        XCTAssertTrue(makeServicesOp.wasLaunched)
        XCTAssertTrue(makeRouterOp.wasLaunched)

    }
    

    func testRouterCalls() throws {
        
        let expectation = self.expectation(description: "Launch Screen Animation Delay")

        let makeServicesOp = MakeServicesOpMock()

        let router = RouterMock()
        router.onShowTab = {
            let testValue: [LastRoute] = [.launch, .tabs]
            XCTAssertEqual(testValue, router.routeSequence)

            expectation.fulfill()
        }
        
        let makeRouterOp = MakeRouterOpMock()
        makeRouterOp.router = router

        let operationHolder = OperationHolderImpl()

        let operationFactory = OperationFactoryMock()
        operationFactory.makeServicesOp = makeServicesOp
        operationFactory.makeRouterOp = makeRouterOp
        
        let scenario = ScenarioImpl(operationFactory: operationFactory, operationHolder: operationHolder)
                
        scenario.launch()

        wait(for: [expectation], timeout: 1)
    }

    

    func testUpdatesDelivery() throws {

        let expectation = self.expectation(description: "Launch Screen Animation Delay")

        let networkProvider = NetworkProviderDev()
        let asset = networkProvider.assets[0]
        
        let watchlistTabOp = WatchlistTabOpMock()
        let assetsTabOp = AssetsTabOpMock()
        let assetDetailsOp = AssetDetailsOpMock()

        let router = RouterMock()
        router.onShowTab = {

            assetsTabOp.onOpenAsset?(asset)
            assetDetailsOp.onChangeWatchStatus?()

            XCTAssertTrue(watchlistTabOp.wasReloaded)

            expectation.fulfill()
        }
        let makeRouterOp = MakeRouterOpMock()
        makeRouterOp.router = router

        let operationHolder = OperationHolderImpl()
        
        
        let operationFactory = OperationFactoryMock()
        operationFactory.watchlistTabOp = watchlistTabOp
        operationFactory.assetsTabOp = assetsTabOp
        operationFactory.assetDetailsOp = assetDetailsOp
        operationFactory.makeRouterOp = makeRouterOp

        let scenario = ScenarioImpl(operationFactory: operationFactory, operationHolder: operationHolder)
        scenario.launch()

        wait(for: [expectation], timeout: 1)
    }

}
