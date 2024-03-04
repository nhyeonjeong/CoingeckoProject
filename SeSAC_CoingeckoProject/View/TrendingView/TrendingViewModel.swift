//
//  TrendingViewModel.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/04.
//

import Foundation

class TrendingViewModel {
    // 트랜딩 화면 3분류
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
    var rowList = RowEnum.allCases
    
    var inputFetchTrigger: Observable<Void?> = Observable(nil) // 트랜딩 화면에 들어갔을 떄 API통신을 일으키는 트리거
    var outputFetchTrigger: Observable<Void?> = Observable(nil) // api통신이 끝났을 떄 트리거
    
    var outputFavoriteList: Observable<[CoinFavorite]> = Observable([]) // 즐겨찾기 리스트
    var outputCoinTrendingList: Observable<[CoinItem]> = Observable([]) // 코인트랜딩 리스트
    var outputNftTrendingList: Observable<[NFTItem]> = Observable([]) // nft트랜딩 리스트
    
    var isUpPercent: Observable<Bool> = Observable(false) // ?
    var transitionWithId: Observable<String?> = Observable(nil)
    
    init() {
        bindData()
    }
    
    func bindData() {
        inputFetchTrigger.bind { _ in
            print("inputFetchTrigger didSet - API통신")
            // 즐겨찾기가져오기
            self.outputFavoriteList.value = RealmRepository.shared.fetchItem()
            // api통신
            self.callRequest()
        }
    }
    
    func callRequest() {
        CoinAPIManager.shared.fetchCoinData(type: CoinNFTTrending.self, api: .trending) { data, error in
            guard let data else { return }
            self.outputCoinTrendingList.value = data.coins
            self.outputNftTrendingList.value = data.nfts
            
            // api통신이 끝났다면
            self.outputFetchTrigger.value = ()
        }
    }

    func numberOfTableRow() -> Int {
        let favListCount = outputFavoriteList.value.count
        if favListCount >= 0 && favListCount < 2 {
            rowList = favListCount >= 0 && favListCount < 2 ? [.coin, .nft] : RowEnum.allCases
        } else {
            rowList = RowEnum.allCases
        }
        return rowList.count
    }
    func numberOfCollectionRow(_ tag: Int) -> Int {
        let row = rowList[tag]
        if row == .favorite {
            return outputFavoriteList.value.count
        } else if row == .coin {
            return outputCoinTrendingList.value.count
        } else {
            return outputNftTrendingList.value.count
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
                completionHandler(nil, nil)
                return
            }
            self.checkPercent(data.price_change_percentage_24h) // 양수음수 확인
            completionHandler(data.current_price, data.price_change_percentage_24h)
        }
    }
}
