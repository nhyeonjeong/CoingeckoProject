//
//  DeclarationCollectionViewCell.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import UIKit
import SnapKit

final class DeclarationCollectionViewCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    let declarationLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureConstraints()
        configureView()
        
    }
    
    func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(declarationLabel)
    }
    
    func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(22)
            
        }
        declarationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel.snp.leading)
            make.height.equalTo(22)
            make.bottom.equalToSuperview()
            
        }
    }
    
    func configureView() {
        titleLabel.font = Constants.Font.boldMain
        titleLabel.textColor = Constants.Color.titleLabel
        
        declarationLabel.font = Constants.Font.main
        declarationLabel.textColor = Constants.Color.subLabel
    }
    
    func configureCell(_ data: (title: String, price: Double)) {
        print("🏂\(data.title), \(data.price)")
        titleLabel.text = data.title
        declarationLabel.text = "₩\(NumberFormatManager.shared.calculator(Int(data.price)))"
    }
    
    // 스토리보드로 할 때 실행되는 구문
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("textfield required init")
    }
}
