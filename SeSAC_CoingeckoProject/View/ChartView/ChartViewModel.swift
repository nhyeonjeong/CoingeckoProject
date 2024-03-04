//
//  ChartViewModel.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/02.
//

import Foundation

class ChartViewModel {
    enum DeclarationEnum: Int, CaseIterable {
        case highPrice = 0
        case lowPrice
        case ath // 이떄까지의 가격 중 가장 높은 가격 - 신고점
        case atl // 이떄까지의 가격 중 가장 낮은 가격 - 신저점
        
        var title: String {
            switch self {
            case .highPrice:
                return "고가"
            case .lowPrice:
                return "저가"
            case .ath:
                return "신고점"
            case .atl:
                return "신저점"
            }
        }
    }
    let declaration = DeclarationEnum.allCases
    
    var inputFetchFavoriteTrigger: Observable<Void?> = Observable(nil) // 즐겨찾기 가져오기
    var outPutFetchFav: Observable<Bool> = Observable(false)
    var favoriteList: Observable<[CoinFavorite]> = Observable([])
    
    var inputCoinId: Observable<String> = Observable("") // 받아온 코인 id
    var coinData: Observable<CoinDetail> = Observable(CoinDetail(idString: "", symbol: "", name: "", image: "", current_price: 0, price_change_percentage_24h: 0, high_24h: 0, low_24h: 0, ath: 0, atl: 0, last_updated: "", sparkline_in_7d: []))
    var outPutCurrentPricePositive: Observable<Bool> = Observable(false)
    var outputFetchError: Observable<Bool> = Observable(false)
    var outputStarClicked: Observable<Bool> = Observable(false)
    var deleteItemIdx = 0 // 즐겨찾기에서 살젝해야ㅎㄹ 인덱스
    
    init() {
        bindData()
    }
    
    private func bindData() {
        
        // 즐겨찾기목록 가져오기
        inputFetchFavoriteTrigger.bind { _ in
            print("inputFetchFavoriteTrigger.bind")
            self.favoriteList.value = RealmRepository.shared.fetchItem()
            self.isFavoriteItem() // 즐겨찾기에 해당 coinData가 들어잇는지
        }
    }
    // 처음부터 api통신하지 말고 VC에서 coinDataId를 받아왔을 떄 api통신
    func bindDataLater() {
        inputCoinId.bind { id in
            print("inputcoinId bind")
            CoinAPIManager.shared.fetchCoinData(type: [CoinDetail].self, api: .coinMarket(ids: id)) { coinData, error in
                guard let coinData else {
                    self.outputFetchError.value = true // api통신 오류 발생
                    return
                }
                let data = coinData[0]
                print(data)
                self.coinData.value = data
                self.checkUpdown(data)
                self.isFavoriteItem()
                self.outputFetchError.value = false
            }
        }
    }
    
    private func checkUpdown(_ data: CoinDetail) {
        print("checkUpdown")
        if data.price_change_percentage_24h > 0 {
            // 0보다 크면 파란색, 아니면 빨간색
            self.outPutCurrentPricePositive.value = true
        } else {
            self.outPutCurrentPricePositive.value = false
        }
    }
    /// collectionview의 셀마다 어떤 값이 나와야 하는지
    func getCellData(row: Int) -> (title: String, price: Int) {
        var price = 0
        var color = Constants.Color.pointColor
        switch declaration[row] {
        case .highPrice:
            price = coinData.value.high_24h
        case .lowPrice:
            price = coinData.value.high_24h
        case .ath:
            price = coinData.value.high_24h
        case .atl:
            price = coinData.value.high_24h
        }
        return (declaration[row].title, price)
    }
    
    func numberOfItems() -> Int {
        return declaration.count
    }
    
    // 즐겨찾기 유무에 대한 별 바꾸기
    func isFavoriteItem() {
        print("isFavoriteItem")
        var isFavorite: Bool = false
        // 즐겨찾기에 있는지 확인 후 유무에 따라 별 바꾸기
        for i in 0..<favoriteList.value.count {
            print("\(favoriteList.value[i].idString) == \(coinData.value.idString)")
            if favoriteList.value[i].idString == coinData.value.idString {
                print("즐겨찾기에 있대!!")
                deleteItemIdx = i
                isFavorite = true //
            }
        }
        outPutFetchFav.value = isFavorite
    }
    
    func toggleFavStar() {
        // 해결법)
        inputFetchFavoriteTrigger.value = ()
        /*
        if outPutFetchFav.value { // 즐겨찾기에 있는 코인이면 삭제
            RealmRepository.shared.removeItem(favoriteList.value[deleteItemIdx]) {
                self.inputFetchFavoriteTrigger.value = () // 즐겨찾기 목록 다시 가져오기(즐겨찾기에 넣어주는것보다 빠름,,)
                self.outPutFetchFav.value = false // 즐겨찾기 이미지 다시 그리기
                self.outputStarClicked.value = false
            }
        } else {
            // 즐겨찾기 목록이 9개 이하일떄만 추가
            if favoriteList.value.count < 10 {
                print("즐겨찾기에 없으니까 추가")
                RealmRepository.shared.createItem(itemId: coinData.value.idString) {
                    self.inputFetchFavoriteTrigger.value = () // 즐겨찾기 목록 다시 가져오기(즐겨찾기에 넣어주는것보다 빠름,,)
                    self.outPutFetchFav.value = true
                    self.outputStarClicked.value = true
                }
            }
        }
         */
        print("favoriteList : ", favoriteList.value)
    }
}
