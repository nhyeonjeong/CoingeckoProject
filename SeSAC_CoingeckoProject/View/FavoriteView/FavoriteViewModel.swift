//
//  FavoriteViewModel.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/03.
//

import Foundation
import RealmSwift

class FavoriteViewModel {
    var inputFetchFavTrigger: Observable<Void?> = Observable(nil)
    var favoriteList: Observable<[CoinFavorite]> = Observable([])
    var isUpPercent: Observable<Bool> = Observable(false)
    
    init() {
        bindData()
    }
    
    private func bindData() {
        inputFetchFavTrigger.bind { _ in
            self.favoriteList.value = RealmRepository.shared.fetchItem()
        }
    }
    
    func checkPercent(_ percent: Double) {
        if percent > 0 {
            isUpPercent.value = true
        } else {
            isUpPercent.value = false
        }
    }
}
