//
//  AppIconOptionCell.swift
//  bcoin
//
//  Created by Yury Dubovoy on 13.01.2022.
//

import UIKit
import SnapKit


final class AppIconOptionCell: UITableViewCell, ReusableCell {
    
    private let iconNameLabel = UILabel()

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
        
        selectionStyle = .none

        iconNameLabel.textColor = .baseBlack
        iconNameLabel.font = Typography.font_400_17
        contentView.addSubview(iconNameLabel)

        separatorView.backgroundColor = .separator.withAlphaComponent(0.5)
        contentView.addSubview(separatorView)

        iconNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-10).priority(.high)
        }

        separatorView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(16)
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

    public func updateUI(appIcon: AppIcon?, isMarked: Bool) {
        iconNameLabel.text = appIcon?.title
        accessoryType = isMarked ? .checkmark : .none
    }

    public var onTap: Block?

}
