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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputFetchTrigger.value = () // api통신
    }
    func bindData() {
        viewModel.outputFetchTrigger.bind { _ in
            print("outputFetchTrigger didSet - API통신 완료후 테이블 다시 그리기")
            self.mainView.tableView.reloadData()
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

extension TrendingViewController: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 즐겨찾기의 갯수가 0이나 1개라면 숨기기
//        viewModel.checkFavListCount()
        return viewModel.numberOfTableRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.rowList[indexPath.row]
        if section == .favorite {
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
//        let row = viewModel.rowList[collectionView.tag]
//        if row == .favorite {
//            return viewModel.favoriteList.value.count
//        } else if row == .coin {
//            return viewModel.coinTrendingList.value.count
//        } else {
//            return viewModel.nftTrendingList.value.count
//        }
        viewModel.numberOfCollectionRow(collectionView.tag)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = viewModel.rowList[collectionView.tag]
        if row == .favorite {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingFavCollectionViewCell.identifier, for: indexPath) as? TrendingFavCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let cellData = viewModel.outputFavoriteList.value[indexPath.row]
            cell.configureCell(cellData)
            
            // fetchCoinItem을 @escaping을 써주지 않으면 통신을 마치기도 전에 코드가 진행되어서 제대로된 currentPrice와 percent를 가져올 수 없었다.
            viewModel.fetchCoinItem(row: indexPath.row) { (currentPrice, percent) in
                
                // 이 로직은 VC에 하는게 맞나?
                if let currentPrice, let percent {
                    cell.currentPriceLabel.text = "₩\(NumberFormatManager.shared.calculator(currentPrice))"
                    cell.percentLabel.text = self.viewModel.isUpPercent.value ? "+\(percent)%" : "\(percent)%"
                    // isUpPercent를 이렇게 쓸거면 굳이 Observable로 할 필요가 있나?
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
            let data = viewModel.outputCoinTrendingList.value[indexPath.row]
            cell.configureCell(row: indexPath.row, data: data)
            viewModel.checkPercent(data.item.data.price_change_percentage_24h.krw)
            
            cell.percentLabel.textColor = self.viewModel.isUpPercent.value ? Constants.Color.upParcentLabel : Constants.Color.downPercentLabel
            let percent = String(format: "%.2f", data.item.data.price_change_percentage_24h.krw)
            cell.percentLabel.text = self.viewModel.isUpPercent.value ? "+\(percent)%" : "\(percent)%"
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingNFTCollectionViewCell.identifier, for: indexPath) as? TrendingNFTCollectionViewCell else {
                return UICollectionViewCell()
            }
            let data = viewModel.outputNftTrendingList.value[indexPath.row]
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
    // favorite과 coin만 넘어갈 수 있다.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = viewModel.rowList[collectionView.tag]

        if row == .favorite {
            viewModel.transitionWithId.value = viewModel.outputFavoriteList.value[indexPath.row].idString
        } else if row == .coin {
            viewModel.transitionWithId.value = viewModel.outputCoinTrendingList.value[indexPath.row].item.idString
        }
    }
}
