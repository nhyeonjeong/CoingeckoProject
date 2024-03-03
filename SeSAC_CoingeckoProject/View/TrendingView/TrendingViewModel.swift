//
//  TrendingViewModel.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/04.
//

import Foundation

class TrendingViewModel {
    enum RowEnum: Int, CaseIterable {
        case favorite = 0
        case coin
        case nft
        
        var sectionTitle: String {
            switch self {
            case .favorite:
                return "My Favoite"
            case .coin:
                return "Top 15 Coin"
            case .nft:
                return "Top7 NFT"
            }
        }
    }
    let rowList = RowEnum.allCases
    
    var inputFetchTrigger: Observable<Void?> = Observable(nil)
    var outputFetchTrigger: Observable<Void?> = Observable(nil)
    var favoriteList: Observable<[CoinFavorite]> = Observable([])
    var coinTrendingList: Observable<[CoinItem]> = Observable([])
    var nftTrendingList: Observable<[NFTItem]> = Observable([])
    var isUpPercent: Observable<Bool> = Observable(false)
    
    init() {
        bindData()
    }
    
    func bindData() {
        inputFetchTrigger.bind { _ in
            print("즐겨찾기 패치 트리거")
            // 즐겨찾기
            self.favoriteList.value = RealmRepository.shared.fetchItem()
            CoinAPIManager.shared.fetchCoinData(type: CoinNFTTrending.self, api: .trending) { data, error in
                guard let data else { return }
                self.coinTrendingList.value = data.coins
                self.nftTrendingList.value = data.nfts
                self.outputFetchTrigger.value = ()
            }
        }
    }

    func numberOfRow() -> Int {
        return rowList.count
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
        CoinAPIManager.shared.fetchCoinData(type: [CoinDetail].self, api: .coinMarket(ids: favoriteList.value[row].idString)) { value, error in
            guard let value else { return }
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
