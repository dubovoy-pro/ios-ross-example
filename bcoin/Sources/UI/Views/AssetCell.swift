//
//  AssetCell.swift
//  bcoin
//
//  Created by Yury Dubovoy on 11.01.2022.
//

import UIKit
import SnapKit


final class AssetCell: UITableViewCell, ReusableCell {
    
    private let iconView = UIImageView()
 
    private let symbolLabel = UILabel()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let changePercentLabel = UILabel()

    private let separatorView = UIView()

    private var asset: CoincapAPI.Asset?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        backgroundColor = .baseWhite
        
        accessoryType = .disclosureIndicator

        addSubview(iconView)
        
        symbolLabel.textColor = .baseBlack
        symbolLabel.font = Typography.font_400_22
        contentView.addSubview(symbolLabel)
        
        nameLabel.textColor = .textGray2
        nameLabel.font = Typography.font_400_13
        contentView.addSubview(nameLabel)

        priceLabel.textColor = .textGray1
        priceLabel.font = Typography.font_400_22
        priceLabel.textAlignment = .right
        contentView.addSubview(priceLabel)
        
        changePercentLabel.textAlignment = .right
        changePercentLabel.font = Typography.font_400_17
        contentView.addSubview(changePercentLabel)
        
        separatorView.backgroundColor = .separator
        contentView.addSubview(separatorView)

        iconView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }

        symbolLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(15)
            make.top.equalToSuperview().offset(14)
            make.height.equalTo(28)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(15)
            make.height.equalTo(18).priority(.high)
            make.top.equalTo(symbolLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-18).priority(.high)
        }

        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(symbolLabel.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-14)
            make.top.equalToSuperview().offset(18)
            make.height.equalTo(22)
        }

        changePercentLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-14)
            make.top.equalTo(priceLabel.snp.bottom).offset(7)
            make.height.equalTo(20)
        }
        
        separatorView.snp.makeConstraints { make in
            make.leading.equalTo(symbolLabel.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }

        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(onTapRecognizer))
        addGestureRecognizer(tapRecognizer)

    }
    
    @objc
    private func onTapRecognizer() {
        if let asset = asset {
            onTap?(asset)
        }
    }

    public func updateUI(asset: CoincapAPI.Asset) {
        self.asset = asset
        symbolLabel.text = asset.symbol
        nameLabel.text = asset.name
        priceLabel.text = asset.formattedPrice
        changePercentLabel.text = asset.formattedChangePercent24Hr
        iconView.image = UIImage(named: asset.symbol.lowercased()) ?? UIImage(named: "unknown_icon")

        switch asset.formattedChangePercent24HrDouble {
        case .none:
            changePercentLabel.textColor = .textGray2
        case .some(let value):
            changePercentLabel.textColor = value >= 0 ? .textGreen : .textRed
        }

    }

    public var onTap: Func<CoincapAPI.Asset>?


}
