//
//  TrendingView.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/04.
//

import UIKit
import SnapKit

class TrendingView: BaseView {

    let titleLabel = BigTitleLabel()
    let tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = UITableView.automaticDimension
        view.register(TrendingFavTableViewCell.self, forCellReuseIdentifier: TrendingFavTableViewCell.identifier)
        view.register(TrendingCoinTableViewCell.self, forCellReuseIdentifier: TrendingCoinTableViewCell.identifier)
        view.register(TrendingNFTTableViewCell.self, forCellReuseIdentifier: TrendingNFTTableViewCell.identifier)

        return view
    }()
    
    override func configureHierarchy() {
        addSubview(titleLabel)
        addSubview(tableView)
    }
    override func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(safeAreaLayoutGuide).inset(Constants.layout.areaLayout)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        titleLabel.text = "Crypto Coin"
    }
}
