//
//  CoinTrending.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/04.
//

import Foundation

struct CoinNFTTrending: Decodable {
    let coins: [CoinItem]
    let nfts: [NFTItem]
}

struct CoinItem: Decodable {
    let item: [Item]
}

struct Item: Decodable {
    let idString: String
    let name: String
    let symbol: String
    let small: String // 코인 아이콘 리소스
    let data: Price
}

struct Price: Decodable {
    let price: String
    let price_change_percentage_24h: Percent
}

struct Percent: Decodable {
    let krw: Double // 코인 변동 폭
}

// NFT
struct NFTItem: Decodable {
    let name: String
    let symbol: String
    let thumb: String
    let data: NFTData
}

struct NFTData: Decodable {
    let floor_price: String // 최저가
    let floor_price_in_usd_24h_percentage_change: String // 변동폭
}
