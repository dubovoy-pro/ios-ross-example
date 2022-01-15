//
//  PriceCell.swift
//  bcoin
//
//  Created by Yury Dubovoy on 13.01.2022.
//

import UIKit
import SnapKit


final class PriceCell: UITableViewCell, ReusableCell {
    
    private let priceLabel = UILabel()
    private let changePercentLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        backgroundColor = .baseGray

        priceLabel.textAlignment = .center
        priceLabel.font = Typography.font_200_64
        contentView.addSubview(priceLabel)

        changePercentLabel.textAlignment = .center
        changePercentLabel.font = Typography.font_400_22
        contentView.addSubview(changePercentLabel)

        priceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(76)
            make.leading.trailing.equalToSuperview()
        }

        changePercentLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(5)
            make.height.equalTo(26)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalToSuperview().priority(.high)
        }
        
    }

    public func updateUI(asset: CoincapAPI.Asset) {
        priceLabel.text = asset.formattedPrice
        changePercentLabel.text = asset.formattedChangePercent24Hr

        switch asset.formattedChangePercent24HrDouble {
        case .none:
            changePercentLabel.textColor = .textGray2
        case .some(let value):
            changePercentLabel.textColor = value >= 0 ? .textGreen : .textRed
        }
    }

}
