//
//  ReusableCell.swift
//  bcoin
//
//  Created by Yury Dubovoy on 11.01.2022.
//

import UIKit

public protocol ReusableCell: AnyObject {
    static var reuseIdentifier: String { get }
}

public extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    func dequeueAndRegisterCell<Cell>() -> Cell
        where Cell: UITableViewCell & ReusableCell {
        if let cell = dequeueReusableCell(withIdentifier: Cell.reuseIdentifier) as? Cell {
            return cell
        } else {
            register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
            return dequeueReusableCell(withIdentifier: Cell.reuseIdentifier) as! Cell
        }
    }

}
