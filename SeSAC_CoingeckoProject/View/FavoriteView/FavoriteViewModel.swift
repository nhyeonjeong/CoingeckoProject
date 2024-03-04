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
    
    init() {
        bindData()
    }
    
    private func bindData() {
        inputReadFavTrigger.bind { _ in
            self.outputFavoriteList.value = RealmRepository.shared.fetchItem()
        }
    }
    
    func checkPercent(_ percent: Double) {
        isUpPercent.value = percent > 0 ? true : false
    }
    
    func fetchCoinItem(row: Int, completionHandler: @escaping (Int?, Double?) -> Void) {
        var data: CoinDetail? = nil
        CoinAPIManager.shared.fetchCoinData(type: [CoinDetail].self, api: .coinMarket(ids: outputFavoriteList.value[row].idString)) { value, error in
            guard let value else { return }
            
            data = value[0]
            guard let data else {
                print(#function, "nil, nil")
                completionHandler(nil, nil)
                return
            }
            self.checkPercent(data.price_change_percentage_24h) // 양수음수 확인
            completionHandler(data.current_price, data.price_change_percentage_24h)
        }
    }
}
