//
//  AppDelegate.swift
//  bcoin
//
//  Created by Yury Dubovoy on 10.01.2022.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    
    lazy var scenario: Scenario = {
        let operationFactory = OperationFactoryImpl()
        let operationHolder = OperationHolderImpl()
        return ScenarioImpl(
            operationFactory: operationFactory,
            operationHolder: operationHolder
        )
    }()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        scenario.launch()
        return true
    }

}

