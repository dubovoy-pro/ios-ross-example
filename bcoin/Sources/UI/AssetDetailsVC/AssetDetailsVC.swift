//
//  AssetDetailsVC.swift
//  bcoin
//
//  Created by Yury Dubovoy on 12.01.2022.
//

import UIKit


final class AssetDetailsVC: BaseViewController {

    private let mainTableView = UITableView()
    
    private var tableViewCells: [UITableViewCell] = []

    private let operation: AssetDetailsOp

    init(operation: AssetDetailsOp) {
        self.operation = operation
        super.init(nibName: nil, bundle: nil)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }

    private func setupUI() {
        title = operation.asset?.name
        view.backgroundColor = .baseWhite

        mainTableView.dataSource = self
        mainTableView.separatorColor = .clear
        mainTableView.showsVerticalScrollIndicator = false
        view.addSubview(mainTableView)

        mainTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        tableViewCells = makeCells(tableView: mainTableView)

    }

    private func setupUpdates() {
        operation.onDataUpdate = { [weak self] in
            self?.updateUI()
        }
        operation.onError = { [weak self] message in
            let alertVC = UIAlertController(title: Strings.Error.alertTitle, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: Strings.Error.alertOk, style: .default))
            self?.present(alertVC, animated: true, completion: nil)
        }
    }

    private func updateUI() {
        tableViewCells = makeCells(tableView: mainTableView)
        mainTableView.reloadData()
        updateNavbar()
    }
    
    private func updateNavbar() {
        let img = operation.isWatched ? Images.heartFilled : Images.heartEmpty
        let button = UIBarButtonItem(
            image: img.image,
            style: .plain,
            target: self, action: #selector(onWatchBtnTap))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc
    private func onWatchBtnTap() {
        operation.changeWatchStatus { [weak self] in
            self?.updateNavbar()
        }
    }

    private func makeCells(tableView: UITableView) -> [UITableViewCell] {
        var cells: [UITableViewCell] = []
        cells.append(makePriceCell(tableView: tableView))
        cells.append(makePlotCell(tableView: tableView))
        if operation.asset?.marketCapUsd != nil {
            cells.append(makeMarketCapCell(tableView: tableView))
        }
        if operation.asset?.supply != nil {
            cells.append(makeSupplyCell(tableView: tableView))
        }
        if operation.asset?.volumeUsd24Hr != nil {
            cells.append(makeVolumeCell(tableView: tableView))
        }
        return cells
    }

    private func makeMarketCapCell(tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueAndRegisterCell() as MarketCapCell
        if let asset = operation.asset {
            cell.updateUI(asset: asset)
        }
        return cell
    }

    private func makePlotCell(tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueAndRegisterCell() as PlotCell
        cell.updateUI(histPrices: operation.histPrices)
        return cell
    }

    private func makePriceCell(tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueAndRegisterCell() as PriceCell
        if let asset = operation.asset {
            cell.updateUI(asset: asset)
        }
        return cell
    }

    private func makeSupplyCell(tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueAndRegisterCell() as SupplyCell
        if let asset = operation.asset {
            cell.updateUI(asset: asset)
        }
        return cell
    }

    private func makeVolumeCell(tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueAndRegisterCell() as VolumeCell
        if let asset = operation.asset {
            cell.updateUI(asset: asset)
        }
        return cell
    }

}

extension AssetDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableViewCells[indexPath.row]
    }
    
}
