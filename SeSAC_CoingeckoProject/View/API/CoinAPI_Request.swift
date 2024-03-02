//
//  Coin_Request.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import Foundation
import Alamofire
// enum으로 해준 이유? -
enum CoinAPi_Request {
    case trending
    case search(query: String)
    case coinMarket(ids: String)
    
    var getMethod: HTTPMethod {
        return .get
    }
    
    var baseUrlString: String {
        "https://api.coingecko.com/api/v3/"
    }
    
    var url:String {
        switch self {
        case .trending:
            return baseUrlString + "search/trending"
        case .search(let query):
            return baseUrlString + "search?query=\(query)"
        case .coinMarket(let ids):
            return baseUrlString + "coins/markets?vs_currency=krw&ids=\(ids)"
        }
    }
}
