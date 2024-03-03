//
//  Model.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import Foundation

struct Coingecko: Decodable {
    let coins: [Coin]
}

// 즐겨찾기가 저장되는 형태일 것.
struct Coin: Decodable {
    let idString: String
    let thumbImage: String
    let name: String
    let symbol: String
    
    enum CodingKeys: String, CodingKey {
        case idString = "id"
        case thumbImage = "thumb"
        case name
        case symbol
    }
}
