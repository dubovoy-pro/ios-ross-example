//
//  MakeRouterOp.swift
//  bcoin
//
//  Created by Yury Dubovoy on 10.01.2022.
//

import Foundation

protocol MakeRouterOpInterface: AnyObject {
}

protocol MakeRouterOpDelegate: AnyObject {
}

protocol MakeRouterOp: Operation, MakeRouterOpInterface, MakeRouterOpDelegate {
    var onFinish: Func<Router>? { get set }
}

final class MakeRouterOpImpl: BaseOperation, MakeRouterOp {

    // MARK: MakeRouterOp
    
    override func launch(holder: OperationHolder) {
        super.launch(holder: holder)
        
        let routerState = RouterStateStoreImpl()
        let router = RouterImpl(stateStore: routerState)
        
        finish(router: router)
    }

    var onFinish: Func<Router>?
    
    
    // MARK: MakeRouterInterface
    
    
    // MARK: MakeRouterDelegate
    
    
    // MARK: MakeRouterOpImpl

    private func finish(router: Router) {
        super.finish()
        onFinish?(router)
    }
    


}
