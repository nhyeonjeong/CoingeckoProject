//
//  SearchUIView.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import UIKit
import SnapKit

final class SearchUIView: BaseView {

    let titleLabel = BigTitleLabel()
    
    let searchBar = UISearchBar()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        return view
    }()
    
    override func configureHierarchy() {
        addSubview(titleLabel)
        addSubview(searchBar)
        addSubview(tableView)
    }
    
    override func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(safeAreaLayoutGuide).inset(Constants.layout.areaLayout) // equalToSuperView()하면 안됨
//            make.height.equalTo(22)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(Constants.layout.areaLayout - 6)
        
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(Constants.layout.areaLayout)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        titleLabel.text = "Search"
    }

}
