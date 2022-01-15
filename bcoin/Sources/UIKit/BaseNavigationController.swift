//
//  BaseNavigationController.swift
//  bcoin
//
//  Created by Yury Dubovoy on 10.01.2022.
//


import UIKit


class BaseNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    private weak var navBackHandler: NavigationBackHandler?

    init(rootViewController: UIViewController, navBackHandler: NavigationBackHandler) {
        self.navBackHandler = navBackHandler
        super.init(rootViewController: rootViewController)
        tabBarItem = rootViewController.tabBarItem
        setupNavBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupNavBar() {
        
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.backgroundColor = .baseGray
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        } else {
            navigationBar.isTranslucent = false
            view.backgroundColor = .baseGray
            navigationBar.backgroundColor = .baseGray
        }
        
    }
    
    public func popViewController(
        animated: Bool,
        completion: (() -> Void)?) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let baseVC = viewController as? BaseViewController {
            baseVC.router = navBackHandler
        }
        super.pushViewController(viewController, animated: true)
    }
    
    public func pushViewController(
        viewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)?) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }


}
