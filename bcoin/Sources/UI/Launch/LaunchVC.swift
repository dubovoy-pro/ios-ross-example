//
//  LaunchVC.swift
//  bcoin
//
//  Created by Yury Dubovoy on 10.01.2022.
//

import UIKit
import SnapKit

final class LaunchVC: BaseViewController {
   
    private let logoImageView = UIImageView()
    private let loadingIndicator = Spinner()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .baseWhite
        
        logoImageView.image = Images.logo.image
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        
        loadingIndicator.startAnimating()
        view.addSubview(loadingIndicator)
        
        logoImageView.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualToSuperview()
            make.centerX.centerY.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(40)
        }
    }
}
