//
//  BaseViewController.swift
//  bcoin
//
//  Created by Yury Dubovoy on 10.01.2022.
//

import UIKit
import SnapKit


class BaseViewController: UIViewController {

    weak var router: NavigationBackHandler?
    
    func onGoBack() {
        router?.onGoBack()
    }
    
    func onDismiss() {
        router?.onDismiss()
    }

    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        //self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }

    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }

    /// Provides go back event to the router
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            onGoBack()
        }
    }
    
    /// Provides dismiss event to the router
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            onDismiss()
        }
    }
    
    /// Propagates dismiss/goBack event handler to the presented VC
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if let baseVC = viewControllerToPresent as? BaseViewController {
            baseVC.router = router
        }
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

}
