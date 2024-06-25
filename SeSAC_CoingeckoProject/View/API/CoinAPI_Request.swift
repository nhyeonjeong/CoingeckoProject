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
    case coinMarket(idList: [String])
    
    var getMethod: HTTPMethod {
        return .get
    }
    
    var baseUrlString: String {
        "https://api.coingecko.com/api/v3/"
    }
    
    var url: String {
        switch self {
        case .trending:
            return baseUrlString + "search/trending"
        case .search(let query):
            return baseUrlString + "search?query=\(query)"
        case .coinMarket(let idList):
            var idsString = ""
            for i in 0..<idList.count {
                if i == 0 { idsString += idList[i]}
                else { idsString += ",\(idList[i])"}
            }
            return baseUrlString + "coins/markets?vs_currency=krw&ids=\(idsString)&sparkline=true"
        }
    }
}
