//
//  CoinAPIManager.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

//import Foundation
//
//class CoinAPIManager {
//    
//    static let shared = CoinAPIManager() // 더 많은 공간이 생기지 않게금 방지
//    
//    
//    func fetchMovie<T>(api: TMDBAPI, completionhandler: @escaping (([Movie]?, AFError?) -> Void)) {
//        
//        print("1")
//        
//        print("2")
//        AF.request(api.endpoint,
//                   method: api.method,
//                   parameters: api.parameter,
//                   encoding: URLEncoding(destination: .queryString),
//                   headers: api.header).responseDecodable(of: TrendingModel.self) { response in
//            switch response.result {
//            case .success(let success):
//                print("success", success)
//                completionhandler(success.results, nil)
//                
//            case .failure(let failure): // AFError타입이므로 completionHandler로 전달시 AFError타입으로
//                print("failure", failure)
//                
//                completionhandler(nil, failure)
//            }
//        }
//        
//        
//    }
//    
//    
//    
//}
