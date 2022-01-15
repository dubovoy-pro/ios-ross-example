//
//  List.swift
//  bcoin
//
//  Created by Yury Dubovoy on 11.01.2022.
//

import Foundation

extension CoincapAPI {

    struct List<T: Decodable>: Decodable {
        let data: Array<T>
    }

}
