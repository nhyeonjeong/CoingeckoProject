//
//  TrendingCoinCollectionViewCell.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/04.
//

import UIKit
import SnapKit

class TrendingCoinCollectionViewCell: UICollectionViewCell {
    
    let numberLabel: UILabel = {
        let view = UILabel()
        view.textColor = Constants.Color.subLabel
        view.font = Constants.Font.boldMain
        return view
    }()
    
    let coinView = CoinView()
    
    let priceLabel: UILabel = {
        let view = UILabel()
        view.textColor = Constants.Color.subLabel
        view.font = Constants.Font.subMain
        return view
    }()
    let percentLabel: UILabel = {
        let view = UILabel()
        view.font = Constants.Font.small
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureConstraints()
        configureView()
        
        print("textfield override init")
    }
    
    func configureHierarchy() {
        contentView.addSubview(numberLabel)
        contentView.addSubview(coinView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(percentLabel)
    }
    
    func configureConstraints() {
        numberLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).inset(20)
            
        }
        coinView.snp.makeConstraints { make in
            make.leading.equalTo(numberLabel.snp.)
        }
    }
    
    func configureView() {
        
    }
    
    // 스토리보드로 할 때 실행되는 구문
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //        configureView() // 스토리보드로 한다면 여기도 configureView호출
        print("textfield required init")
    }


}
