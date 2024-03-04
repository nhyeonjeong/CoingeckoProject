//
//  SearchTableViewCell.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import UIKit
import SnapKit
import Kingfisher

final class SearchTableViewCell: UITableViewCell {

    let coinView = CoinView()
    let favStar: UIButton = {
        let view = UIButton()
        view.setImage(Constants.Image.favInactiveStar, for: .normal) // 기본
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureHierarchy() {
        contentView.addSubview(coinView)
        contentView.addSubview(favStar)
    }
    func configureConstraints() {
        coinView.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.verticalEdges.equalTo(contentView).inset(8)
        }
        
        favStar.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(coinView.snp.trailing)
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(10)
        }
    }

    func configureCell(coinData: Coin, row: Int) {

        coinView.coinSymbolLabel.text = coinData.symbol
        coinView.coinImage.kf.setImage(with: URL(string: coinData.thumbImage))

    }

//    func toggleFavStar(tag: Int) {
//        // 즐겨찾기에 있는지 확인 후 유무에 따라 별 바꾸기 -> 즐겨찾기 목록 리로드
//        viewModel.favoriteList.value.forEach { data in
//            
//            if data.idString == viewModel.oupPutSearchCoinData.value[tag].idString {
//                // 즐겨찾기 목록에 이미 있다면 즐겨찾기 해재
//                favStar.setImage(Constants.Image.favInactiveStar, for: .normal)
//                // realm
//                RealmRepository.shared.removeItem(viewModel.favoriteList.value[tag])
//            } else {
//                // 즐겨찾기에 없으면 즐겨찾기에 추가
//                favStar.setImage(Constants.Image.favStar, for: .normal)
//                RealmRepository.shared.createItem(itemId: viewModel.oupPutSearchCoinData.value[tag].idString)
//            }
//        }
//    }
}
