//
//  ChartViewController.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import UIKit
import Toast
import Kingfisher

final class ChartViewController: BaseViewController {
    var coinDataId: String = "" // 받아온 코인 id
    
    let viewModel = ChartViewModel()
    let mainView = ChartView()
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputCoinId.value = coinDataId
        bindData()
        configureCollectionView()
    }
    // 왜 안뜨지,,?
//    deinit {
//        print("ChartVC deinit")
//    }
    
    func bindData() {
        viewModel.coinData.bind { data in
            // UI그리기
            self.reloadView(data)
        }
        
        viewModel.outPutCurrentPricePositive.bind { value in
            print("oupPutcurrnetPricePositive bind")
            // 코인변동폭 양/음에 따른 색, text
            self.mainView.todayPercent.textColor = value ? Constants.Color.upParcentLabel : Constants.Color.downPercentLabel
            let number = self.viewModel.coinData.value.price_change_percentage_24h
            self.mainView.todayPercent.text = number > 0 ? "+\(number)% Today" : "\(number)% Today"
        }
    }
    
    func reloadView(_ data: CoinDetail) {
        mainView.collectionView.reloadData()
        mainView.titleLabel.text = data.name
        mainView.thumbImage.kf.setImage(with: URL(string: data.image))
        mainView.priceLabel.text = "\(data.current_price)"
        mainView.updateDate.text = "\(data.last_updated) 업데이트"
        // 차트도 그리기
        mainView.settingChartView()
    }
    
    func noDataToast() {
        view.makeToast("정보를 찾을 수 없습니다.", duration: 1.0, position: .top)
        dismiss(animated: true)
    }
}

extension ChartViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func configureCollectionView() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeclarationCollectionViewCell.identifier, for: indexPath) as? DeclarationCollectionViewCell else {
            return UICollectionViewCell()
        }

        let cellData = viewModel.getCellData(row: indexPath.row)
        // 고/저에 따른 title색상
        switch viewModel.declaration[indexPath.row] {
        case .highPrice, .ath:
            cell.titleLabel.textColor = Constants.Color.upParcentLabel
        case .lowPrice, .atl:
            cell.titleLabel.textColor = Constants.Color.downPercentLabel
        }
        cell.configureCell(cellData)
        return cell
    }
}
