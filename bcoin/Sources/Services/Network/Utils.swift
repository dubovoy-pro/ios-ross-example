//
//  Aliases.swift
//  bcoin
//
//  Created by Yury Dubovoy on 11.01.2022.
//

import Foundation

enum LoadingError: Error {
    case limitsExceeded
    case other
    
    var message: String {
        switch self {
        case .limitsExceeded:
            return Strings.Error.limitsExceeded
        case .other:
            return Strings.Error.unknown
        }
    }
}

typealias NetworkHandler<T> = (Result<T, LoadingError>) -> Void
