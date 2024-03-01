//
//  SearchTableViewCell.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import UIKit
import SnapKit
import Kingfisher

class SearchTableViewCell: UITableViewCell {

    let coinView = CoinView()
    let favStar: UIButton = {
        let view = UIButton()
        view.setImage(Constants.Image.favInactiveStar, for: .normal)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureHierarchy() {
        contentView.addSubview(coinView)
        contentView.addSubview(favStar)
    }
    func configureConstraints() {
        coinView.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.verticalEdges.equalTo(contentView).inset(8)
        }
        
        favStar.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(coinView.snp.trailing)
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(10)
        }
    }
    
    func configureCell(_ coinData: Coin) {
        coinView.coinTitleLabel.text = coinData.name
        coinView.coinSymbolLabel.text = coinData.symbol
        coinView.coinImage.kf.setImage(with: URL(string: coinData.thumbImage))
    }

}
