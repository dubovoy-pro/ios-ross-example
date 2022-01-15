//
//  OperationHolder.swift
//  bcoin
//
//  Created by Yury Dubovoy on 11.01.2022.
//

import Foundation


protocol OperationHolder: AnyObject {
    func append(operation: BaseOperation)
    func remove(operation: BaseOperation)
}


final class OperationHolderImpl: OperationHolder {
    
    private var currentOperations: [BaseOperation] = []
    
    func append(operation: BaseOperation) {
        currentOperations.append(operation)
    }
    
    func remove(operation: BaseOperation) {
        if let index = currentOperations.firstIndex(where: { $0.id == operation.id }) {
            currentOperations.remove(at: index)
        }
    }

}
