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
        return viewModel.numberOfRow()
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
            cell.collectionTitleLabel.text = section.sectionTitle
            cell.collectionView.reloadData()
            return cell
        } else if section == .coin {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendingCoinTableViewCell.identifier, for: indexPath) as? TrendingCoinTableViewCell else {
                return UITableViewCell()
            }
            
            cell.collectionView.register(TrendingCoinCollectionViewCell.self, forCellWithReuseIdentifier: TrendingCoinCollectionViewCell.identifier)
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.tag = indexPath.row
            cell.collectionTitleLabel.text = section.sectionTitle
            cell.collectionView.reloadData()
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendingNFTTableViewCell.identifier, for: indexPath) as? TrendingNFTTableViewCell else {
                return UITableViewCell()
            }
            cell.collectionView.register(TrendingNFTCollectionViewCell.self, forCellWithReuseIdentifier: TrendingNFTCollectionViewCell.identifier)
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.tag = indexPath.row
            cell.collectionTitleLabel.text = section.sectionTitle
            cell.collectionView.reloadData()
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
        let row = viewModel.rowList[collectionView.tag]
        if row == .favorite {
            print("collection row count : ", viewModel.favoriteList.value.count)
            return viewModel.favoriteList.value.count
        } else if row == .coin {
            print("collection row count : ", viewModel.coinTrendingList.value.count)
            return viewModel.coinTrendingList.value.count
        } else {
            print("collection nfs count : ", viewModel.nftTrendingList.value.count)
            return viewModel.nftTrendingList.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = viewModel.rowList[collectionView.tag]
        if row == .favorite {
            print("favorite")
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingFavCollectionViewCell.identifier, for: indexPath) as? TrendingFavCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configureCell(viewModel.favoriteList.value[indexPath.row])
            viewModel.fetchCoinItem(row: indexPath.row) { (currentPrice, percent) in
                if let currentPrice, let percent {
                    
                    cell.currentPriceLabel.text = "₩\(NumberFormatManager.shared.calculator(currentPrice))"
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
            print("coin")
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCoinCollectionViewCell.identifier, for: indexPath) as? TrendingCoinCollectionViewCell else {
                return UICollectionViewCell()
            }
            let data = viewModel.coinTrendingList.value[indexPath.row]
            cell.configureCell(row: indexPath.row, data: data)
            viewModel.checkPercent(data.item.data.price_change_percentage_24h.krw)
            
            cell.percentLabel.textColor = self.viewModel.isUpPercent.value ? Constants.Color.upParcentLabel : Constants.Color.downPercentLabel
            let percent = String(format: "%.2f", data.item.data.price_change_percentage_24h.krw)
            cell.percentLabel.text = self.viewModel.isUpPercent.value ? "+\(percent)%" : "\(percent)%"
            return cell
        } else {
            print("nft")
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingNFTCollectionViewCell.identifier, for: indexPath) as? TrendingNFTCollectionViewCell else {
                return UICollectionViewCell()
            }
            let data = viewModel.nftTrendingList.value[indexPath.row]
            cell.configureCell(row: indexPath.row, data: data)
            let number = Double(data.data.floor_price_in_usd_24h_percentage_change)
            guard let number else { return cell }
            viewModel.checkPercent(number)
            
            cell.percentChangeLabel.textColor = self.viewModel.isUpPercent.value ? Constants.Color.upParcentLabel : Constants.Color.downPercentLabel
            let percent = String(format: "%.2f", number)
            cell.percentChangeLabel.text = self.viewModel.isUpPercent.value ? "+\(percent)%" : "\(percent)%"
            return cell
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = viewModel.rowList[collectionView.tag]
        if row == .favorite {
            let vc = ChartViewController()
            vc.coinDataId = viewModel.favoriteList.value[indexPath.row].idString
            navigationController?.pushViewController(vc, animated: true)
        } else if row == .coin {
            let vc = ChartViewController()
            vc.coinDataId = viewModel.coinTrendingList.value[indexPath.row].item.idString
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
