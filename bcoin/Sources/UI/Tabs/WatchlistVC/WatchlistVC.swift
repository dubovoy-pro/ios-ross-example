//
//  WatchlistVC.swift
//  bcoin
//
//  Created by Yury Dubovoy on 10.01.2022.
//

import UIKit


final class WatchlistVC: BaseViewController {

    
    private let mainTableView = UITableView()

    private let noDataView = UIView()

    private let operation: WatchlistTabOp

    init(operation: WatchlistTabOp) {
        self.operation = operation
        super.init(nibName: nil, bundle: nil)
        tabBarItem.title = Strings.WatchlistTab.title
        tabBarItem.image = Images.tabWatchlist.image
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupUpdates()
        updateUI()
    }

    private func setupUI() {
        title = Strings.WatchlistTab.title
        view.backgroundColor = .baseGray
        
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.backgroundColor = .baseGray
        mainTableView.separatorColor = .clear
        view.addSubview(mainTableView)
        
        view.addSubview(noDataView)
        
        let noDateTitleLabel = UILabel()
        noDateTitleLabel.textColor = .baseBlack
        noDateTitleLabel.font = Typography.font_600_17
        noDateTitleLabel.textAlignment = .center
        noDateTitleLabel.text = Strings.WatchlistTab.noDataTitle
        noDataView.addSubview(noDateTitleLabel)
        
        let noDateHeaderLabel = UILabel()
        noDateHeaderLabel.textColor = .textGray1
        noDateHeaderLabel.font = Typography.font_400_13
        noDateHeaderLabel.textAlignment = .center
        noDateHeaderLabel.text = Strings.WatchlistTab.noDataHeader
        noDataView.addSubview(noDateHeaderLabel)

        mainTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        noDataView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        noDateTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        noDateHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(noDateTitleLabel.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupUpdates() {
        operation.onDataUpdate = { [weak self] in
            self?.updateUI()
        }
    }

    private func updateUI() {
        noDataView.isHidden = operation.assets.count > 0
        mainTableView.reloadData()
    }

}

extension WatchlistVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operation.assets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let asset = operation.assets[indexPath.row]
        let cell = tableView.dequeueAndRegisterCell() as AssetCell
        cell.updateUI(asset: asset)
        cell.selectionStyle = .none
        cell.onTap = { [weak self] asset in
            self?.operation.openAsset(asset)
        }
        return cell
    }
    
}

extension WatchlistVC : UITableViewDelegate {

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let deleteAction = UITableViewRowAction(
            style: .default,
            title: Strings.WatchlistTab.delete,
            handler: { [weak self] (action, indexPath) in
            guard let self = self else { fatalError() }
            self.operation.removeAsset(self.operation.assets[indexPath.row])
        })
        deleteAction.backgroundColor = .textRed
        return [deleteAction]
    }

}
