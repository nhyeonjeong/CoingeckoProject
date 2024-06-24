//
//  FavoriteViewController.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import UIKit

final class FavoriteViewController: BaseViewController {

    let mainView = FavoriteView()
    let viewModel = FavoriteViewModel()
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData() // 즐겨찾기는 알아서 가져옴
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        viewModel.inputReadFavTrigger.value = () // 즐겨찾기목록 가져오도록
    }
    
    func bindData() {
//        viewModel.outputFavoriteList.bind { [weak self] _ in
//            guard let self else {return}
//            mainView.collectionView.reloadData()
//        }
        viewModel.fetchCurrentPriceAndPercentList.bind { value in
            self.mainView.collectionView.reloadData()
        }
        viewModel.transitionWithId.bind { idString in
            let vc = ChartViewController()
            guard let id = idString else {
                self.view.makeToast("정보를 불러오지 못했습니다.", duration: 1.0, position: .top)
                return // 화면전환하지 말기
            }
            vc.coinDataId = id
            vc.popClosure = {
                self.view.makeToast("통신상태가 좋지 않습니다.", duration: 2.0, position: .top)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func configureCollectionView() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputFavoriteList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath) as? FavoriteCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(viewModel.outputFavoriteList.value[indexPath.row], priceAndPercent: viewModel.fetchCurrentPriceAndPercentList.value[indexPath.row])
        // 셀마다 api통신해서 실시간 가격, 퍼센트 가져오기
        /*
        viewModel.fetchCoinItem(row: indexPath.row) { (currentPrice, percent) in
            if let currentPrice, let percent {
                print("currentPrice, percent잘 받아옴")
                cell.currentPrice.text = "₩\(NumberFormatManager.shared.calculator(Int(currentPrice)))"
                cell.percentLabel.text = self.viewModel.isUpPercent.value ? "  +\(percent)%  " : "  \(percent)%  "
                cell.percentLabel.textColor = self.viewModel.isUpPercent.value ? Constants.Color.upParcentLabel : Constants.Color.downPercentLabel
                cell.percentLabel.backgroundColor = self.viewModel.isUpPercent.value ? Constants.Color.upPercentBackground : Constants.Color.downPercentBackground
            } else {
                print("nil, nil")
                cell.currentPrice.text = "통신 실패"
                cell.percentLabel.text = "통신 실패"
                cell.percentLabel.textColor = Constants.Color.titleLabel
                cell.percentLabel.backgroundColor = Constants.Color.lightBackground
            }
        }
         */
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.transitionWithId.value = viewModel.outputFavoriteList.value[indexPath.row].idString
    }
}
