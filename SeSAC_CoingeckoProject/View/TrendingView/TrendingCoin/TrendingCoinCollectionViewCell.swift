//
//  TrendingCoinCollectionViewCell.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/04.
//

import UIKit
import SnapKit
import Kingfisher

class TrendingCoinCollectionViewCell: UICollectionViewCell {
    
    let numberLabel: UILabel = {
        let view = UILabel()
        view.textColor = Constants.Color.subLabel
        view.font = Constants.Font.boldMain
        return view
    }()
    
    let coinView = {
        let view = CoinView()
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    let numberBackView = {
        let view = UIView()
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return view
    }()
    
    let priceLabel: UILabel = {
        let view = UILabel()
        view.textColor = Constants.Color.subLabel
        view.font = Constants.Font.subMain
        view.textAlignment = .right
//        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
        
    }()
    let percentLabel: UILabel = {
        let view = UILabel()
        view.font = Constants.Font.small
        view.textAlignment = .right
//        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
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
        numberBackView.addSubview(priceLabel)
        numberBackView.addSubview(percentLabel)
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
        priceLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(numberBackView)
        }
        percentLabel.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(numberBackView)
            make.top.equalTo(priceLabel.snp.bottom)
        }
        numberBackView.snp.makeConstraints { make in
            make.leading.equalTo(coinView.snp.trailing).offset(10)
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(20)
        }
    }
    
    func configureCell(row: Int, data: CoinItem) {
        numberLabel.text = "\(row+1)"
        coinView.coinImage.kf.setImage(with: URL(string: data.item.small))
        coinView.coinTitleLabel.text = data.item.name
        coinView.coinSymbolLabel.text = data.item.symbol
        
        priceLabel.text = "$" + String(format: "%.4f", data.item.data.price)
    }
    
    // 스토리보드로 할 때 실행되는 구문
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //        configureView() // 스토리보드로 한다면 여기도 configureView호출
        print("textfield required init")
    }


}
