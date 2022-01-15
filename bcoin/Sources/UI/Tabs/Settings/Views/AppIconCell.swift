//
//  AppIconCell.swift
//  bcoin
//
//  Created by Yury Dubovoy on 13.01.2022.
//

import UIKit
import SnapKit


final class AppIconCell: UITableViewCell, ReusableCell {
    
    private let hintLabel = UILabel()
    
    private let valueLabel = UILabel()

    private let separatorView = UIView()

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
        
        selectionStyle = .none

        hintLabel.textColor = .baseBlack
        hintLabel.font = Typography.font_400_17
        contentView.addSubview(hintLabel)

        valueLabel.textAlignment = .right
        valueLabel.font = Typography.font_400_17
        contentView.addSubview(valueLabel)

        separatorView.backgroundColor = .separator
        contentView.addSubview(separatorView)

        hintLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-10).priority(.high)
        }

        valueLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(hintLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-10).priority(.high)
        }

        separatorView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
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
        onTap?()
    }

    public func updateUI(appIcon: AppIcon?) {
        hintLabel.text = Strings.SettingsTab.icon
        valueLabel.text = appIcon?.title
    }

    public var onTap: Block?

}
