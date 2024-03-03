//
//  FavoriteView.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/02.
//

import UIKit
import SnapKit

class FavoriteView: BaseView {
    let titleLabel = BigTitleLabel()
    
    // 최대 10 셀까지 가능
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
        return view
    }()
    
    override func configureHierarchy() {
        addSubview(titleLabel)
        addSubview(collectionView)
    }
    
    override func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(Constants.layout.areaLayout)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(Constants.layout.areaLayout)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        titleLabel.text = "Favorite Coin"
    }
}

extension FavoriteView {
    func collectionViewLayout() -> UICollectionViewLayout {
        let screenWidth = UIScreen.main.bounds.width
        let inset: CGFloat = 0
        let lineSpacing: CGFloat = 15 // 세로간격
        let itemSpacing: CGFloat = 15
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (screenWidth-(Constants.layout.areaLayout*2)-itemSpacing)/2, height: 150) // 없으면 안됨
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        layout.scrollDirection = .vertical
        return layout
    }
}
