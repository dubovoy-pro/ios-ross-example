//
//  Operation.swift
//  bcoin
//
//  Created by Yury Dubovoy on 10.01.2022.
//

import Foundation

protocol Operation {
    func launch(holder: OperationHolder)
}

class BaseOperation: Operation {
    
    let id: Int

    private static var counter: Int = 0
    
    private static func generateId() -> Int {
        BaseOperation.counter = BaseOperation.counter + 1
        return BaseOperation.counter;
    }

    init() {
        id = BaseOperation.generateId()
    }

    private weak var holder: OperationHolder?
    
    func launch(holder: OperationHolder) {
        self.holder = holder
        holder.append(operation: self)
    }

    func finish() {
        holder?.remove(operation: self)
    }
    
}
