//
//  SearchViewController.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import UIKit

final class SearchViewController: BaseViewController {

    let mainView = SearchUIView()
    
    let viewModel = SearchViewModel()
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        configureTableView()
        configureSearchBar()
    }
    
    func bindData() {
        viewModel.cointDataList.bind { _ in
            print("coindatalist bind")
            self.mainView.tableView.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func configureTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cointDataList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(viewModel.cointDataList.value[indexPath.row])
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func configureSearchBar() {
        mainView.searchBar.delegate = self
    }
    
    // return을 누르면
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        viewModel.inputSearchText.value = searchBar.text

    }
}
