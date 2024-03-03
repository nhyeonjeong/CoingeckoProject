//
//  TrendingFavCollectionViewCell.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/04.
//

import UIKit
import SnapKit

class TrendingFavCollectionViewCell: UICollectionViewCell {
    let coinView = CoinView()
    let currentPriceLabel: UILabel = {
        let view = UILabel()
        view.textColor = Constants.Color.subLabel
        view.font = Constants.Font.favBoldNumber
        return view
    }()
    let percentLabel: UILabel = {
        let view = UILabel()
        view.font = Constants.Font.favBoldNumber
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    func configureHierarchy() {
        contentView.addSubview(coinView)
        contentView.addSubview(currentPriceLabel)
        contentView.addSubview(percentLabel)
    }
    
    func configureConstraints() {
        coinView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(contentView).inset(10)
        }
        percentLabel.snp.makeConstraints { make in
            make.leading.equalTo(coinView.snp.leading)
            make.bottom.equalTo(contentView).inset(10)
            make.top.equalTo(currentPriceLabel.snp.bottom).offset(8)
            make.height.equalTo(20)
        }
        currentPriceLabel.snp.makeConstraints { make in
            make.leading.equalTo(coinView.snp.leading)
            make.trailing.equalTo(contentView).inset(10)
            make.height.equalTo(20)
        }
    }
    
    func configureView() {
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = Constants.Color.boxBackground
    }
    func configureCell(_ data: CoinFavorite) {
        
        // textColor, backgroundColor
        coinView.coinImage.kf.setImage(with: URL(string: data.thumbImageString))
        coinView.coinTitleLabel.text = data.name
        coinView.coinSymbolLabel.text = data.symbolName

    }
    // 스토리보드로 할 때 실행되는 구문
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //        configureView() // 스토리보드로 한다면 여기도 configureView호출
        print("textfield required init")
    }
}
