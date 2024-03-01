//
//  ChartViewController.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import UIKit

final class ChartViewController: BaseViewController {

    let mainView = ChartView()
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
    }

}

extension ChartViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func configureCollectionView() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DeclarationEnum.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeclarationCollectionViewCell.identifier, for: indexPath) as? DeclarationCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(title: "titil", price: "price")
        return cell
    }
}
