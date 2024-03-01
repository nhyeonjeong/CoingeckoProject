//
//  ChartView.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import UIKit
import DGCharts

final class ChartView: BaseView {
    
    let symbolImage: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 20
        view.contentMode = .scaleAspectFill
        return view
    }()
    let titleLabel = BigTitleLabel()
    
    let priceLabel: UILabel = {
        let view = UILabel()
        view.font = Constants.Font.title
        view.textColor = Constants.Color.titleLabel
        return view
    }()
    
    let todayPercent: UILabel = {
        let view = UILabel()
        view.font = Constants.Font.main
        return view
    }()
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(DeclarationCollectionViewCell.self, forCellWithReuseIdentifier: DeclarationCollectionViewCell.identifier)
        view.backgroundColor = .clear
        return view
    }()
    
    let chartView = LineChartView()
    
    override func configureHierarchy() {
        addSubview(symbolImage)
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(todayPercent)
        addSubview(collectionView)
        addSubview(chartView)
    }
    
    override func configureConstraints() {
        symbolImage.snp.makeConstraints { make in
            make.leading.top.equalTo(safeAreaLayoutGuide).inset(Constants.layout.areaLayout)
            make.size.equalTo(40)
            
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(symbolImage.snp.trailing)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(Constants.layout.areaLayout)
            make.centerY.equalTo(symbolImage)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(symbolImage.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(Constants.layout.areaLayout)
            
        }
        todayPercent.snp.makeConstraints { make in
            make.leading.equalTo(symbolImage.snp.leading)
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
            
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(todayPercent.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(Constants.layout.areaLayout)
            make.height.equalTo(110) // 없으면 안됨
        }
        
        chartView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        titleLabel.text = "Solana"
        priceLabel.text = "7999900"
        todayPercent.text = "+3.22% Today"
    }
}

extension ChartView {
    
    static func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let inset: CGFloat = 0
        let lineSpacing: CGFloat = 10 // 세로간격
        let itemSpacing: CGFloat = 20
        
        layout.itemSize = CGSize(width: (screenWidth-(inset*2)-(Constants.layout.areaLayout*2)-itemSpacing)/2, height: 50) // 없으면 안됨
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        layout.scrollDirection = .vertical // 스크롤 방향도 FlowLayout에 속한다 -> contentMode때문에 Fill로
        return layout
    }
}
