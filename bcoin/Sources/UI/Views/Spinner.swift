//
//  Spinner.swift
//  bcoin
//
//  Created by Yury Dubovoy on 10.01.2022.
//

import UIKit

final class Spinner: UIActivityIndicatorView {
    
    init() {
        super.init(frame: .zero)
        if #available(iOS 13.0, *) {
            style = .large
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
