//
//  SettingsVC.swift
//  bcoin
//
//  Created by Yury Dubovoy on 10.01.2022.
//

import UIKit


final class SettingsVC: BaseViewController {
    
    private let mainTableView = UITableView()
    
    private var tableViewCells: [UITableViewCell] = []

    private let operation: SettingsTabOp

    init(operation: SettingsTabOp) {
        self.operation = operation
        super.init(nibName: nil, bundle: nil)
        tabBarItem.title = Strings.SettingsTab.title
        tabBarItem.image = Images.tabSettings.image
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
        navigationItem.largeTitleDisplayMode = .always
    }

    private func setupUI() {
        title = Strings.SettingsTab.title
        view.backgroundColor = .baseGray
        
        navigationController?.navigationBar.prefersLargeTitles = true

        mainTableView.dataSource = self
        mainTableView.separatorColor = .clear
        mainTableView.backgroundColor = .baseGray
        view.addSubview(mainTableView)

        mainTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        mainTableView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)

    }

    private func setupUpdates() {
        operation.onDataUpdateHandlers.append({ [weak self] in
            self?.updateUI()
        })
    }
    
    private func updateUI() {
        tableViewCells = makeCells(tableView: mainTableView)
        mainTableView.reloadData()
    }

    private func makeCells(tableView: UITableView) -> [UITableViewCell] {
        var cells: [UITableViewCell] = []
        cells.append(makeAppIconCell(tableView: tableView))
        return cells
    }

    private func makeAppIconCell(tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueAndRegisterCell() as AppIconCell
        cell.onTap = { [weak self] in
            self?.operation.openIconList()
        }
        cell.updateUI(appIcon: operation.currentIcon)
        return cell
    }

}

extension SettingsVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableViewCells[indexPath.row]
    }
    
}
