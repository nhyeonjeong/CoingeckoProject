//
//  TrendingNFTCollectionViewCell.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/04.
//

import UIKit

class TrendingNFTCollectionViewCell: UICollectionViewCell {
    let numberLabel: UILabel = {
        let view = UILabel()
        view.textColor = Constants.Color.subLabel
        view.font = Constants.Font.boldMain
        return view
    }()
    
    let coinView = CoinView()
    
    let numberBackView = UIView()
    
    let floorPriceLabel: UILabel = {
        let view = UILabel()
        view.textColor = Constants.Color.subLabel
        view.font = Constants.Font.subMain
        view.textAlignment = .right
        return view
    }()
    let percentChangeLabel: UILabel = {
        let view = UILabel()
        view.font = Constants.Font.small
        view.textAlignment = .right
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureConstraints()
    }
    
    func configureHierarchy() {
        contentView.addSubview(numberLabel)
        contentView.addSubview(coinView)
        contentView.addSubview(numberBackView)
        numberBackView.addSubview(floorPriceLabel)
        numberBackView.addSubview(percentChangeLabel)
    }
    
    func configureConstraints() {
        numberLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).inset(20)
            
        }
        coinView.snp.makeConstraints { make in
            make.leading.equalTo(numberLabel.snp.trailing).offset(15)
            make.centerY.equalTo(contentView)
            
        }
        floorPriceLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(numberBackView)
        }
        percentChangeLabel.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(numberBackView)
            make.top.equalTo(floorPriceLabel.snp.bottom)
        }
        numberBackView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(20)
        }
    }
    
    func configureCell(row: Int, data: NFTItem) {
        numberLabel.text = "\(row+1)"
        coinView.coinImage.kf.setImage(with: URL(string: data.thumb))
        coinView.coinTitleLabel.text = data.name
        coinView.coinSymbolLabel.text = data.symbol
        
        floorPriceLabel.text = data.data.floor_price
    }
    
    // 스토리보드로 할 때 실행되는 구문
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("textfield required init")
    }

}
