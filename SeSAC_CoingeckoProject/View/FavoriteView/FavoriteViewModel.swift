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
    var isUpPercent: Observable<Bool> = Observable(false)
    var transitionWithId: Observable<String?> = Observable(nil)
    
    var fetchCurrentPriceAndPercentList: [(currentPrice: String, percent: String)] = []
    
    init() {
        bindData()
    }
    
    private func bindData() {
        inputReadFavTrigger.bind { _ in
            self.outputFavoriteList.value = RealmRepository.shared.fetchItem()
            self.fetchCoinItem { values in
                  print("🚨 \(values)")
            }
            
        }
    }
    
    func checkPercent(_ percent: Double) {
        isUpPercent.value = percent > 0 ? true : false
    }
    
    func fetchCoinItem(completionHandler: @escaping ([(Double?, Double?)]) -> Void) {
        CoinAPIManager.shared.fetchCoinData(type: [CoinDetail].self, api: .coinMarket(idList: outputFavoriteList.value.map({ favoriteCoin in
            favoriteCoin.idString
        }))) { value, error in
            guard let value else { return }
            
//            guard let data else {
//                print(#function, "nil, nil")
//                completionHandler((nil, nil))
//                return
//            }
//            self.checkPercent(data.price_change_percentage_24h) // 양수음수 확인
//            completionHandler(data.current_price, data.price_change_percentage_24h)
            completionHandler(value.map({ coin in
                (coin.current_price, coin.price_change_percentage_24h)
            }))
        }
    }
}
