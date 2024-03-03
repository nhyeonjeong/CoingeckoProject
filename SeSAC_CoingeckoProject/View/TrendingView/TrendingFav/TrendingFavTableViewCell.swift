//
//  TrendingFavTableViewCell.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/04.
//

import UIKit

class TrendingFavTableViewCell: UITableViewCell {
    let collectionTitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = Constants.Color.titleLabel
        view.text = "My Favorite"
        view.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionTitleLabel)
        contentView.addSubview(collectionView)
        collectionTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(Constants.layout.areaLayout)
            make.height.equalTo(40)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(collectionTitleLabel.snp.bottom)
            make.horizontalEdges.bottom.equalTo(contentView)
            make.height.equalTo(150)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension TrendingFavTableViewCell {
    func collectionViewLayout() -> UICollectionViewLayout {
        let inset: CGFloat = Constants.layout.areaLayout
        let lineSpacing: CGFloat = 15
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 150) // 없으면 안됨
        layout.minimumLineSpacing = lineSpacing // 가로
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        layout.scrollDirection = .horizontal // 스크롤 방향도 FlowLayout에 속한다 -> contentMode때문에 Fill로
        return layout
    }
}



