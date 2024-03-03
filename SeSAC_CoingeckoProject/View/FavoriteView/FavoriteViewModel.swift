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
    func fetchCoinItem(row: Int, completionHandler: @escaping (Int?, Double?) -> Void) {
        var data: CoinDetail? = nil
        CoinAPIManager.shared.fetchCoinData(type: [CoinDetail].self, api: .coinMarket(ids: favoriteList.value[row].idString)) { value in
            data = value[0]
            guard let data else {
                completionHandler(nil, nil)
                return
            }
            self.checkPercent(data.price_change_percentage_24h) // 양수음수 확인
            completionHandler(data.current_price, data.price_change_percentage_24h)
        }
    }
}
