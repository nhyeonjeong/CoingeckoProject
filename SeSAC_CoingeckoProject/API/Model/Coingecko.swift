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

struct Coin: Decodable {
    let id: String
    let thumbImage: String
    let name: String
    let symbol: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case thumbImage = "thumb"
        case name
        case symbol
    }
}
