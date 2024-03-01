//
//  SearchUIView.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import UIKit
import SnapKit

final class SearchUIView: BaseView {

    let titleLabel: UILabel = {

        let view = UILabel()
        view.textColor = .titleLabel
        view.font = Constants.Font.title
        view.text = "Search"
        return view
        
    }()
    
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
            make.leading.top.equalTo(safeAreaLayoutGuide).inset(8) // equalToSuperView()하면 안됨
            make.height.equalTo(25)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(4)
        
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(4)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

}
