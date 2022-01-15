//
//  PlotCell.swift
//  bcoin
//
//  Created by Yury Dubovoy on 13.01.2022.
//

import UIKit
import SnapKit


final class PlotCell: UITableViewCell, ReusableCell {
    
    private let plotView = PlotView()

    private let loadingIndicator = Spinner()

    private let separatorView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        backgroundColor = .baseGray

        contentView.addSubview(plotView)

        contentView.addSubview(loadingIndicator)

        separatorView.backgroundColor = .separator
        contentView.addSubview(separatorView)

        let screenWidth = UIScreen.main.bounds.width
        plotView.snp.makeConstraints { make in
            make.height.equalTo(screenWidth * 0.5).priority(.high)
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }

        separatorView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalTo(plotView)
        }

        
    }

    public func updateUI(histPrices: [CoincapAPI.HistPrice]) {
        plotView.updateUI(histPrices: histPrices)
        
        if histPrices.count > 0 {
            loadingIndicator.stopAnimating()
        } else {
            loadingIndicator.startAnimating()
        }

    }

}
