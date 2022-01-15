//
//  Logger.swift
//  bcoinTests
//
//  Created by Yury Dubovoy on 11.01.2022.
//

import Foundation
import UIKit

public final class Logger {

    public static let shared = Logger()

    public func log(_ text: String) {
        // do nothing in unit tests
    }
}

final class LogSharingWindow : UIWindow {}
