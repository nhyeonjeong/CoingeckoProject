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
        print(#function)
        viewModel.inputFetchFavTrigger.value = ()
    }

    func bindData() {
        viewModel.favoriteList.bind { _ in
            self.mainView.collectionView.reloadData()
        }
    }
}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func configureCollectionView() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favoriteList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath) as? FavoriteCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(viewModel.favoriteList.value[indexPath.row])
        // 셀마다 api통신해서 실시간 가격, 퍼센트 가져오기
        viewModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ChartViewController()
        vc.coinDataId = viewModel.favoriteList.value[indexPath.row].idString
        navigationController?.pushViewController(vc, animated: true)
    }
}
