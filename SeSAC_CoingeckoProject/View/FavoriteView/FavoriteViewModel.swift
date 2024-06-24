//
//  FavoriteViewModel.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/03.
//

import Foundation
import RealmSwift

class FavoriteViewModel {
    var inputReadFavTrigger: Observable<Void?> = Observable(nil) // 즐겨찾기 realm에서 가져오기
    var outputFavoriteList: Observable<[CoinFavorite]> = Observable([]) // 즐겨찾기 목록
    var transitionWithId: Observable<String?> = Observable(nil)
    
    var fetchCurrentPriceAndPercentList: Observable<[(currentPrice: Double?, percent: Double?)]> = Observable([])
    
    init() {
        bindData()
    }
    
    private func bindData() {
        inputReadFavTrigger.bind { _ in
            self.outputFavoriteList.value = RealmRepository.shared.fetchItem()
            self.fetchCoinItem { values in
                self.fetchCurrentPriceAndPercentList.value = values
                
            }
        }
    }
    
    func checkPercent(_ percent: Double) -> Bool {
        return percent > 0 ? true : false
    }
    
    func fetchCoinItem(completionHandler: @escaping ([(Double?, Double?)]) -> Void) {
        CoinAPIManager.shared.fetchCoinData(type: [CoinDetail].self, api: .coinMarket(idList: outputFavoriteList.value.map({ favoriteCoin in
            favoriteCoin.idString
        }))) { value, error in
            guard let value else { return }
            completionHandler(value.map({ coin in
                (coin.current_price, coin.price_change_percentage_24h)
            }))
        }
    }
}
