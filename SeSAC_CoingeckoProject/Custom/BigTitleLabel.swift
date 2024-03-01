//
//  BigTitleLabel.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import UIKit

class BigTitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 자주쓰이는 label
        textColor = Constants.Color.titleLabel
        font = Constants.Font.title
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("textfield required init")
    }
}
