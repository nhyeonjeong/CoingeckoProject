//
//  CoinDetailModel.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/02.
//

import Foundation

struct CoinDetail: Decodable {
    let id: String
    let symbol: String // 코인 통화 단위
    let name: String
    let image: String
    let current_price: Double
    let price_change_percentage_24h: Double
    let high_24h: Double
    let low_24h: Double
    let ath: Double
    let atl: Double
    let last_updated: String
    let sparkline_in_7d: SparkLine


}
struct SparkLine: Decodable {
    let price: [Double]
}
