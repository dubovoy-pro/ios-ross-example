//
//  AssetsVC.swift
//  bcoin
//
//  Created by Yury Dubovoy on 10.01.2022.
//

import UIKit


final class AssetsVC: BaseViewController {

    private let mainTableView = UITableView()
    private let loadingIndicator = Spinner()
    private let pullToRefreshControl = UIRefreshControl()
    
    private let noDataLabel = UILabel()

    private let searchController = UISearchController(searchResultsController: nil)

    private let searchResultsView = SearchResultsView()

    private let operation: AssetsTabOp

    private var assets: [CoincapAPI.Asset] = []
    
    var searchTask: DispatchWorkItem?

    init(operation: AssetsTabOp) {
        self.operation = operation
        super.init(nibName: nil, bundle: nil)
        tabBarItem.title = Strings.AssetsTab.title
        tabBarItem.image = Images.tabAssets.image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupUpdates()
        updateUI()
        loadData(showLoadingIndicator: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
    }

    private func setupUI() {
        title = Strings.AssetsTab.title
        view.backgroundColor = .baseWhite
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController

        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.separatorColor = .clear
        view.addSubview(mainTableView)

        noDataLabel.textColor = .textGray2
        noDataLabel.font = Typography.font_400_17
        noDataLabel.numberOfLines = 0
        noDataLabel.textAlignment = .center
        noDataLabel.text = Strings.Content.noDataTitle
        noDataLabel.isHidden = true
        view.addSubview(noDataLabel)

        pullToRefreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        mainTableView.refreshControl = pullToRefreshControl

        view.addSubview(loadingIndicator)
        
        searchResultsView.isHidden = true
        searchResultsView.alpha = 0.0
        searchResultsView.onAssetSelection = { [weak self] asset in
            self?.operation.openAsset(asset)
        }
        view.addSubview(searchResultsView)

        mainTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        noDataLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mainTableView).dividedBy(1.25)
            make.centerX.equalTo(mainTableView)
            make.leading.equalTo(mainTableView).offset(20)
            make.trailing.equalTo(mainTableView).offset(-20)
        }

        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        searchResultsView.snp.makeConstraints { make in
            make.edges.equalTo(mainTableView)
        }

    }

    private func setupUpdates() {
        operation.onDataUpdate = { [weak self] in 
            self?.updateUI()
            self?.pullToRefreshControl.endRefreshing()
        }
        operation.onError = { [weak self] message in
            let alertVC = UIAlertController(title: Strings.Error.alertTitle, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: Strings.Error.alertOk, style: .default))
            self?.present(alertVC, animated: true, completion: nil)
        }
    }

    private func updateUI() {
        if operation.isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        mainTableView.reloadData()

    }
    
    private func loadData(showLoadingIndicator: Bool) {
        if showLoadingIndicator {
            loadingIndicator.startAnimating()
        }
        operation.loadAssets(
            search: nil,
            ids: nil,
            limit: paginationLimit,
            offset: 0
        ) { [weak self] assets in
            guard let self = self else { fatalError() }
            self.assets = assets
            self.loadingIndicator.stopAnimating()
            self.mainTableView.reloadData()
                self.noDataLabel.isHidden = assets.count > 0 
            self.pullToRefreshControl.endRefreshing()
        }
    }

    private var isMoreDataLoading = false
    
    private let paginationLimit: Int = 10
    
    private func loadMoreData() {
        if isMoreDataLoading {
            return
        }
        isMoreDataLoading = true

        operation.loadAssets(
            search: nil,
            ids: nil,
            limit: paginationLimit,
            offset: assets.count
        ) { [weak self] assets in
            guard let self = self else { fatalError() }
            self.isMoreDataLoading = false

            self.assets.append(contentsOf: assets)
            self.noDataLabel.isHidden = self.assets.count > 0
            self.mainTableView.reloadData()
        }
    }

    @objc
    private func refreshData() {
        noDataLabel.isHidden = assets.count > 0 || pullToRefreshControl.isRefreshing
        loadData(showLoadingIndicator: false)
    }
    
    private func showSearchResults() {
        if searchResultsView.isHidden == false {
            return
        }
        searchResultsView.isHidden = false

        UIView.animate(
            withDuration: 0.15) { [weak self] in
            self?.mainTableView.alpha = 0.0
            self?.searchResultsView.alpha = 1.0
        }
    }
    
    private func hideSearchResults() {
        if searchResultsView.isHidden {
            return
        }
        UIView.animate(
            withDuration: 0.15) { [weak self] in
            self?.mainTableView.alpha = 1.0
            self?.searchResultsView.alpha = 0.0
            self?.searchResultsView.isHidden = true
        }
    }

    private func makeSearch(query: String) {
        operation.loadAssets(
            search: query,
            ids: query,
            limit: nil,
            offset: nil
        ) { [weak self] assets in
            guard let self = self else { fatalError() }
            self.searchResultsView.update(assets: assets)
            self.noDataLabel.isHidden = self.assets.count > 0
            self.updateUI()
        }
    }

}

extension AssetsVC : UITableViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadMoreData()
    }

}

extension AssetsVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let asset = assets[indexPath.row]
        let cell = tableView.dequeueAndRegisterCell() as AssetCell
        cell.updateUI(asset: asset)
        cell.selectionStyle = .none
        cell.onTap = { [weak self] asset in
            self?.operation.openAsset(asset)
        }
        return cell
    }
    
}


extension AssetsVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            hideSearchResults()
            return
        }
        if searchText.isEmpty {
            hideSearchResults()
            return
        }
        
        searchResultsView.clear()
        showSearchResults()

        // search with debounce
        self.searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.makeSearch(query: searchText)
            }
        }
        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)

    }

}
