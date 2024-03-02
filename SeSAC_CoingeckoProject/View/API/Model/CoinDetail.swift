//
//  CoinDetailModel.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/02.
//

import Foundation
//struct No: Decodable {
//    let no: [CoinDetail]
//}
//struct CoinDetail: Decodable {
//    let coinData:
//}
struct CoinDetail: Decodable {
    let id: String
    let symbol: String // 코인 통화 단위
    let name: String
    let image: String
    let current_price: Int
    let price_change_percentage_24h: Double
    let high_24h: Int
    let low_24h: Int
    let ath: Int
    let atl: Int
    let last_updated: String
//    let sparkline_in_7d: String
}
