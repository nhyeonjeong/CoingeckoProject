//
//  CointView.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import UIKit
import SnapKit

class CoinView: BaseView {
    let coinImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.image = Constants.Image.cointDefaultImage
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let coinTitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = Constants.Color.titleLabel
        view.font = Constants.Font.boldMain
        view.text = "testTitle"
//        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return view
    }()
    
    let coinSymbolLabel: UILabel = {
        let view = UILabel()
        view.textColor = Constants.Color.smallLabel
        view.font = Constants.Font.main
        view.text = "testSubTitle"
//        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return view
    }()

    override func configureHierarchy() {
        addSubview(coinImage)
        addSubview(coinTitleLabel)
        addSubview(coinSymbolLabel)
    }
    
    override func configureConstraints() {
        coinImage.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        coinTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(coinImage.snp.trailing).offset(10)
            make.top.equalToSuperview()
            make.height.equalTo(22)
            
        }
        coinSymbolLabel.snp.makeConstraints { make in
            make.top.equalTo(coinTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(coinTitleLabel.snp.leading)
            make.height.equalTo(22)
            make.bottom.equalToSuperview()
        }
    }
}
