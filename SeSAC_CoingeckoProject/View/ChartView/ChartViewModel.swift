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
    
    var inputCoinId: Observable<String> = Observable("") // 받아온 코인 id
    var coinData: Observable<CoinDetail> = Observable(CoinDetail(idString: "", symbol: "", name: "", image: "", current_price: 0, price_change_percentage_24h: 0, high_24h: 0, low_24h: 0, ath: 0, atl: 0, last_updated: ""))
    var outPutCurrentPricePositive: Observable<Bool> = Observable(false)
    init() {
        bindData()
    }
    
    private func bindData() {
        inputCoinId.bind { id in
            print("inputcoinId bind")
            CoinAPIManager.shared.fetchCoinData(type: [CoinDetail].self, api: .coinMarket(ids: id)) { coinData in
                let data = coinData[0]
                print(data)
                self.coinData.value = data
                self.checkUpdown(data)
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
    
}
