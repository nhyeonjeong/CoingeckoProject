//
//  FavoriteCollectionViewCell.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/02.
//

import UIKit
import SnapKit
import Kingfisher

class FavoriteCollectionViewCell: UICollectionViewCell {
    let viewModel = FavoriteViewModel()
    
    let coinView = CoinView()
    
    let currentPrice: UILabel = {
        let view = UILabel()
        view.font = Constants.Font.favBoldNumber
        view.textColor = Constants.Color.subLabel
        view.textAlignment = .right
        return view
    }()
    
    let percentLabel: UILabel = {
        let view = UILabel()
        view.font = Constants.Font.favBoldSmallNumber
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bindData()
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    // 스토리보드로 할 때 실행되는 구문
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("textfield required init")
    }
    func configureHierarchy() {
        contentView.addSubview(coinView)
        contentView.addSubview(currentPrice)
        contentView.addSubview(percentLabel)
    }
    
    func configureConstraints() {
        coinView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView).inset(Constants.layout.areaLayout)
        }
        
        currentPrice.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(Constants.layout.areaLayout)
            make.height.equalTo(20)

        }
        
        percentLabel.snp.makeConstraints { make in
            make.top.equalTo(currentPrice.snp.bottom).offset(4)
            make.height.equalTo(28)
            make.trailing.bottom.equalTo(contentView).inset(Constants.layout.areaLayout)
        }
    }
    
    func configureView() {
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 5
        contentView.layer.borderColor = CGColor(gray: 0.9, alpha: 0.3)
        
        coinView.coinTitleLabel.textColor = Constants.Color.subLabel

    }
    
    func bindData() {
        viewModel.isUpPercent.bind { value in
            print("isUpPercent.bind")
            self.percentLabel.textColor = value ? Constants.Color.upParcentLabel : Constants.Color.downPercentLabel
            self.percentLabel.backgroundColor = value ? Constants.Color.upPercentBackground : Constants.Color.downPercentBackground
        }
    }
    func configureCell(_ data: CoinFavorite) {
        
        // textColor, backgroundColor
        coinView.coinImage.kf.setImage(with: URL(string: data.thumbImageString))
        coinView.coinTitleLabel.text = data.name
        coinView.coinSymbolLabel.text = data.symbolName

    }
}
