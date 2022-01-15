//
//  NetworkProviderDevTests.swift
//  bcoinTests
//
//  Created by Yury Dubovoy on 12.01.2022.
//

import XCTest

class NetworkProviderDevTests: XCTestCase {

    lazy var bundle = {
        return Bundle(for: type(of: self.self))
    }()
    
    lazy var assets = {
        return CoincapAPI.Asset.fromFile(fileName: "assets_100", bundle: bundle)
    }()
    
    func assets(withRanks ranks: [String]) -> [CoincapAPI.Asset] {
        return ranks.reduce([]) { partialResult, rank in
            return partialResult + assets.filter { $0.rank == rank }
        }
    }
    
    func testSearchById() throws {
        
        let expectation = self.expectation(description: "Network Loading")

        let testValue = assets(withRanks: ["1", "18", "34"])
        
        let networkProviderDev = NetworkProviderDev()
        
        networkProviderDev.getAssets(search: "BTC", limit: nil, offset: nil) { result in
            XCTAssertEqual(result, .success(testValue))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testSearchBySymbol() throws {
        
        let expectation = self.expectation(description: "Network Loading")

        let testValue = assets(withRanks: ["1", "18", "26", "34", "60"])
        
        let networkProviderDev = NetworkProviderDev()
        
        networkProviderDev.getAssets(search: "bitcoin", limit: nil, offset: nil) { result in
            XCTAssertEqual(result, .success(testValue))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testLimit() throws {
        
        let expectation = self.expectation(description: "Network Loading")

        let testValue = assets(withRanks: ["1", "2", "3"])
        
        let networkProviderDev = NetworkProviderDev()
        
        networkProviderDev.getAssets(search: nil, limit: 3, offset: nil) { result in
            XCTAssertEqual(result, .success(testValue))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testOffset() throws {
        
        let expectation = self.expectation(description: "Network Loading")

        let testValue = assets(withRanks: ["100"])
        
        let networkProviderDev = NetworkProviderDev()
        
        networkProviderDev.getAssets(search: nil, limit: nil, offset: 99) { result in
            XCTAssertEqual(result, .success(testValue))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }


}
