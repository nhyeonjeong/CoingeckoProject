//
//  ChartView.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import UIKit
import DGCharts

final class ChartView: BaseView {
    
    let thumbImage: UIImageView = {
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
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(DeclarationCollectionViewCell.self, forCellWithReuseIdentifier: DeclarationCollectionViewCell.identifier)
        view.backgroundColor = .clear
        return view
    }()
    let updateDate: UILabel = {
        let view = UILabel()
        view.textColor = Constants.Color.smallLabel
        view.font = Constants.Font.small
        return view
    }()
    let chartView = LineChartView()
    
    override func configureHierarchy() {
        addSubview(thumbImage)
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(todayPercent)
        addSubview(collectionView)
        addSubview(updateDate)
        addSubview(chartView)
    }
    
    override func configureConstraints() {
        thumbImage.snp.makeConstraints { make in
            make.leading.top.equalTo(safeAreaLayoutGuide).inset(Constants.layout.areaLayout)
            make.size.equalTo(40)
            
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(thumbImage.snp.trailing).offset(4)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(Constants.layout.areaLayout)
            make.centerY.equalTo(thumbImage)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbImage.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(Constants.layout.areaLayout)
            
        }
        todayPercent.snp.makeConstraints { make in
            make.leading.equalTo(thumbImage.snp.leading)
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
            
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(todayPercent.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(Constants.layout.areaLayout)
            make.height.equalTo(110) // 없으면 안됨
        }
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(30)
        }
        updateDate.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(Constants.layout.areaLayout)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(15)
        }
    }
    // 다시 하기
    func settingChartView(_ data: [Double]) {
        chartView.backgroundColor = Constants.Color.lightBackground
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.leftAxis.enabled = false
        chartView.xAxis.enabled = false

        var entry: [ChartDataEntry] = []
        for i in 0..<data.count {
            entry.append(ChartDataEntry(x: Double(i), y: data[i]))
        }

        let dataset = LineChartDataSet(entries: entry)
        dataset.mode = .cubicBezier
        dataset.colors = [NSUIColor.systemOrange]
        
        dataset.drawFilledEnabled = true
        dataset.fillColor = .systemOrange
        dataset.fillAlpha = 1
        dataset.fill = LinearGradientFill(gradient: CGGradient(colorsSpace: nil, colors: [NSUIColor.systemOrange.cgColor, NSUIColor.systemOrange.withAlphaComponent(0).cgColor] as CFArray, locations: [1, 0])!, angle: 90)

        dataset.drawFilledEnabled = true
        dataset.drawCirclesEnabled = false
        dataset.lineWidth = 2
        dataset.lineDashPhase = 0
        chartView.data = LineChartData(dataSet: dataset)
    }
}

extension ChartView {
    
    func collectionViewLayout() -> UICollectionViewLayout {
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
