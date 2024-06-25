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
    
    var popClosure: (() -> Void)? // api통신 실패하면 뒤로가서 toast띄우기
    
    var coinDataId: String = "" // 받아온 코인 id
    
    let viewModel = ChartViewModel()
    let mainView = ChartView()
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputCoinId.value = coinDataId
        viewModel.bindDataLater()
        settingBarButton()
        bindData()
        configureCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        viewModel.inputCoinId.value = coinDataId // 다시 데이터 가져오기
        viewModel.inputFetchFavoriteTrigger.value = () // 즐겨찾기 다시 가져오기
        //만약 다시 들어왔는데 즐겨찾기에서 해제되어있다면 화면 나가기
//        if !viewModel.outPutFetchFav.value { // 왜 작동안됨!?!
//            navigationController?.popViewController(animated: true)
//        }
    }
    
    func bindData() {
        viewModel.coinData.bind { data in
            // UI그리기
//            guard let data else {
//                return
//            }
            print("🌎RELOADVIEW")
            self.reloadView(data)
        }
        viewModel.outPutFetchFav.bind { value in
            print("outputfetchfav.bind", value)
            let starImage = value ? Constants.Image.favStar : Constants.Image.favInactiveStar
            self.navigationItem.rightBarButtonItem?.image = starImage

        }
        viewModel.outPutCurrentPricePositive.bind { value in
            print("oupPutcurrnetPricePositive bind")
            // 코인변동폭 양/음에 따른 색, text
            self.mainView.todayPercent.textColor = value ? Constants.Color.upParcentLabel : Constants.Color.downPercentLabel
            let number = self.viewModel.coinData.value.price_change_percentage_24h
            let numberString = String(format: "%.2f", number)
            self.mainView.todayPercent.text = number > 0 ? "+\(numberString)% Today" : "\(numberString)% Today"
        }
        viewModel.outputFetchError.bind { value in
            print("outputFetchError", value)
            if value {
                print("pop")
                self.navigationController?.popViewController(animated: true)
                self.popClosure?() // 뒤로가서 toast띄우기
            }
        }
        viewModel.outputStarClicked.bind { value in
            if value {
                self.mainView.makeToast("즐겨찾기에 추가되었습니다", duration: 1.0, position: .top)
            } else {
                self.mainView.makeToast("즐겨찾기에서 해제되었습니다", duration: 1.0, position: .top)
            }
        }
    }
    
    func reloadView(_ data: CoinDetail) {
        mainView.collectionView.reloadData()
        mainView.titleLabel.text = data.name
        mainView.thumbImage.kf.setImage(with: URL(string: data.image))
        mainView.priceLabel.text = "₩\(NumberFormatManager.shared.calculator(data.current_price))"
        mainView.updateDate.text = "\(data.last_updated) 업데이트"
        // 차트도 그리기
        mainView.settingChartView(data.sparkline_in_7d.price)
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

extension ChartViewController {
    func settingBarButton() {
        print(#function)
        let button = UIBarButtonItem(image: Constants.Image.favInactiveStar, style: .plain, target: self, action: #selector(rightBarButtonItemClicked))
        viewModel.isFavoriteItem() // 즐겨찾기에 들어있는지 확인
        button.tintColor = Constants.Color.pointColor
        navigationItem.rightBarButtonItem = button
        
    }
    
    @objc
    func rightBarButtonItemClicked() {
        print(#function)
        viewModel.toggleFavStar()
    }
}
