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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.transitionWithId.value = viewModel.outputFavoriteList.value[indexPath.row].idString
    }
}
