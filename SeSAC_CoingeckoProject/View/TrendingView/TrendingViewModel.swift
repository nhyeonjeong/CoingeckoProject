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
    
    var favoriteList: Observable<[CoinFavorite]> = Observable([]) // 즐겨찾기 리스트
    var outputDrawFavoriteList: Observable<Bool> = Observable(false)
    var outputCoinTrendingList: Observable<[CoinItem]> = Observable([]) // 코인트랜딩 리스트
    var outputNftTrendingList: Observable<[NFTItem]> = Observable([]) // nft트랜딩 리스트
    
    var isUpPercent: Observable<Bool> = Observable(false) // ?
    var transitionWithId: Observable<String?> = Observable(nil)
    
    var coinPrices: (currentPrice: Int, percent: Double) = (0,0)
    var outputCellApiCoin: Observable<Int?> = Observable(nil)
    
    var fetchCurrentPriceAndPercentList: Observable<[(currentPrice: Double?, percent: Double?)]> = Observable([])
    
    var tableRowCountbeforeFetchFavorite = 0
    var tableRowCountAfterFetchFavorite = 0
    
    init() {
        bindData()
    }
    
    func bindData() {
        inputFetchTrigger.bind { _ in
            // 즐겨찾기가져오기
            self.tableRowCountbeforeFetchFavorite = self.rowList.count
            self.favoriteList.value = RealmRepository.shared.fetchItem()
            self.numberOfTableRow()
            // api통신
            self.callFavRequest{ values in
                self.fetchCurrentPriceAndPercentList.value = values
                self.outputDrawFavoriteList.value = true
            }
            self.callRequest()
        }
    }
    func callFavRequest(completionHandler: @escaping ([(Double?, Double?)]) -> Void) {

        // 즐겨찾기갯수가 2 이상일때만 api통신하면 됨.
        if rowList.count > 2 {
            print("⭐️callFavRequest: \(rowList.count)")
            CoinAPIManager.shared.fetchCoinData(type: [CoinDetail].self, api: .coinMarket(idList: favoriteList.value.map({ coin in
                coin.idString
            }))) { value, error in
                guard let value else { return }
                completionHandler(value.map({ coin in
                    (coin.current_price, coin.price_change_percentage_24h)
                }))
            }
        }
    }
    func callRequest() {
        // Top, NFT
        CoinAPIManager.shared.fetchCoinData(type: CoinNFTTrending.self, api: .trending) { data, error in
            guard let data else { return }
            self.outputCoinTrendingList.value = data.coins
            self.outputNftTrendingList.value = data.nfts
            
            // api통신이 끝났다면
            self.outputFetchTrigger.value = ()
        }
    }

    func numberOfTableRow() {
        let favListCount = favoriteList.value.count
        if favListCount >= 0 && favListCount < 2 {
            rowList = [.coin, .nft]
        } else {
            rowList = RowEnum.allCases
        }
        tableRowCountAfterFetchFavorite = rowList.count
//        return rowList.count
    }
    func numberOfCollectionRow(_ tag: Int) -> Int {
        let row = rowList[tag]
        if row == .favorite {
            return favoriteList.value.count
        } else if row == .coin {
            return outputCoinTrendingList.value.count
        } else {
            return outputNftTrendingList.value.count
        }
    }
    
    func checkPercent(_ percent: Double) {
        isUpPercent.value = percent > 0 ? true : false
    }
}
