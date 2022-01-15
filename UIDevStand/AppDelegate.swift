//
//  AppDelegate.swift
//  UIDevStand
//
//  Created by Yury Dubovoy on 11.01.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupUI()
        return true
    }

    private func setupUI() {
        window = UIWindow()
        window?.makeKeyAndVisible()

        window?.rootViewController = AssetDetailsVCBuilder.make()
//        window?.rootViewController = AssetsVCBuilder.make()
//        window?.rootViewController = WatchlistVCBuilder.make()
    }

}

