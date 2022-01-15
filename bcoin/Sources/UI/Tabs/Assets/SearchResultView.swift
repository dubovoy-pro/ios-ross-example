//
//  SearchResultView.swift
//  bcoin
//
//  Created by Yury Dubovoy on 12.01.2022.
//

import UIKit
import SnapKit

private enum Constants {
    static let sideOffset: CGFloat = 20.0
}

final class SearchResultsView: UIView {

    private let tableView = UITableView()
    private let loadingIndicator = Spinner()
    private let noDataView = UIView()
    
    private var assets: [CoincapAPI.Asset] = []

    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        addSubview(tableView)
        
        addSubview(loadingIndicator)
        
        noDataView.backgroundColor = .baseWhite
        addSubview(noDataView)
        
        let noDataIcon = UIImageView()
        noDataIcon.image = Images.noData.image
        noDataView.addSubview(noDataIcon)
        
        let noDataTitle = UILabel()
        noDataTitle.text = Strings.Content.noDataTitle
        noDataTitle.textColor = .textGray2
        noDataTitle.numberOfLines = 0
        noDataTitle.textAlignment = .center
        noDataView.addSubview(noDataTitle)
        
        let noDataSubtitle = UILabel()
        noDataSubtitle.text = Strings.Content.noDataSubtitle
        noDataSubtitle.textColor = .textGray2
        noDataSubtitle.numberOfLines = 0
        noDataSubtitle.textAlignment = .center
        noDataView.addSubview(noDataSubtitle)

        noDataIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
        }

        noDataTitle.snp.makeConstraints { make in
            make.top.equalTo(noDataIcon.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(Constants.sideOffset)
            make.trailing.equalToSuperview().offset(-Constants.sideOffset)
        }

        noDataSubtitle.snp.makeConstraints { make in
            make.top.equalTo(noDataTitle.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(Constants.sideOffset)
            make.trailing.equalToSuperview().offset(-Constants.sideOffset)
            make.bottom.equalToSuperview()
        }

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        noDataView.snp.makeConstraints { make in
            make.top.equalTo(tableView).offset(80)
            make.centerX.equalToSuperview()
        }
    }

    func clear() {
        assets = []
        tableView.reloadData()
        loadingIndicator.startAnimating()
        noDataView.isHidden = true
    }
    
    func update(assets: [CoincapAPI.Asset]) {
        self.assets = assets
        tableView.reloadData()
        loadingIndicator.stopAnimating()
        noDataView.isHidden = assets.count > 0
    }
    
    public var onAssetSelection: Func<CoincapAPI.Asset>?

}

extension SearchResultsView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let asset = assets[indexPath.row]
        let cell = tableView.dequeueAndRegisterCell() as AssetCell
        cell.updateUI(asset: asset)
        cell.onTap = { [weak self] asset in
            self?.onAssetSelection?(asset)
        }
        return cell
    }
    
    
}
