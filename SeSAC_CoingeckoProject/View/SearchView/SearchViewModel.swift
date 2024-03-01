//
//  SearchViewMoel.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import Foundation

class SearchViewModel {
    // 검색한 문자열
    var inputSearchText: Observable<String?> = Observable("")
    // api로 가져온 Coin리스트
    var cointDataList: Observable<[Coin]> = Observable([])
    
    init() {
        bindData()
    }
    
    private func bindData() {
        inputSearchText.bind { searchText in
            // searchText로 api통신 후 coinDataList에 넣기
            print("inputSearchText bind")
            if let text = searchText {
                CoinAPIManager.shared.fetchCoinData(type: Coingecko.self, api: .search(query: text), completionHandler: { value in
                    self.cointDataList.value = value.coins
                })
            }
        }
    }
}
