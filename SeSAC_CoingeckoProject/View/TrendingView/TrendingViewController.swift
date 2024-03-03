//
//  TrendingViewController.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import UIKit

final class TrendingViewController: BaseViewController {
    let viewModel = TrendingViewModel()
    let mainView = TrendingView()
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        configureTableView()
    }
    
    func bindData() {
        viewModel.outputFetchTrigger.bind { _ in
            print("즐겨찾기 완료 패치 트리거")
            self.mainView.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputFetchTrigger.value = () // api통신
    }
}

extension TrendingViewController: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.rowList[indexPath.row]
        if section == .favorite {
            print("favorite")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendingFavTableViewCell.identifier, for: indexPath) as? TrendingFavTableViewCell else {
                return UITableViewCell()
            }
            cell.collectionView.register(TrendingFavCollectionViewCell.self, forCellWithReuseIdentifier: TrendingFavCollectionViewCell.identifier)
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.tag = indexPath.row
            cell.collectionView.reloadData()
            return cell
        } else if section == .coin {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendingCoinTableViewCell.identifier, for: indexPath) as? TrendingCoinTableViewCell else {
                return UITableViewCell()
            }
            
            cell.collectionView.register(TrendingCoinCollectionViewCell.self, forCellWithReuseIdentifier: TrendingCoinCollectionViewCell.identifier)
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.tag = indexPath.section
//            cell.collectionView.reloadData()
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendingNFTTableViewCell.identifier, for: indexPath) as? TrendingNFTTableViewCell else {
                return UITableViewCell()
            }
            cell.collectionView.register(TrendingNFTCollectionViewCell.self, forCellWithReuseIdentifier: TrendingNFTCollectionViewCell.identifier)
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.tag = indexPath.section
//            cell.collectionView.reloadData()
            return cell
        }
    }
    
    func configureTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
}

extension TrendingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let row = viewModel.rowList[section]
        if row == .favorite {
            print("collection row count : ", viewModel.favoriteList.value.count)
            return viewModel.favoriteList.value.count
//        } else if row == .coin {
//            return viewModel.coinTrendingList.value.count
        } else {
            return viewModel.nftTrendingList.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = viewModel.rowList[collectionView.tag]
        print("-----------------------row : ", row)
        if row == .favorite {
            print("favorite")
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingFavCollectionViewCell.identifier, for: indexPath) as? TrendingFavCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configureCell(viewModel.favoriteList.value[indexPath.row])
            viewModel.fetchCoinItem(row: indexPath.row) { (currentPrice, percent) in
                if let currentPrice, let percent {
                    
                    cell.currentPriceLabel.text = "\(currentPrice)"
                    cell.percentLabel.text = self.viewModel.isUpPercent.value ? "+\(percent)%" : "\(percent)%"
                    cell.percentLabel.textColor = self.viewModel.isUpPercent.value ? Constants.Color.upParcentLabel : Constants.Color.downPercentLabel
                } else {
                    cell.currentPriceLabel.text = "통신 실패"
                    cell.percentLabel.text = "통신 실패"
                    cell.percentLabel.textColor = Constants.Color.titleLabel
                }
            }
            return cell
        } else if row == .coin {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCoinCollectionViewCell.identifier, for: indexPath) as? TrendingCoinCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingNFTCollectionViewCell.identifier, for: indexPath) as? TrendingNFTCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell

        }
    }
}
