//
//  CoinAPIManager.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import Foundation
import Alamofire

class CoinAPIManager {
    
    static let shared = CoinAPIManager()
    
    func fetchCoinData<T: Decodable>(type: T.Type, api: CoinAPi_Request, completionHandler: @escaping (T?, Error?) -> Void) {

//        AF.request(api.url,
//                   method: api.getMethod,
//                   encoding: URLEncoding(destination: .queryString)).responseString { value in
//            print("😱responseString: \(value)")
//        }
        AF.request(api.url,
                   method: api.getMethod,
                   encoding: URLEncoding(destination: .queryString)).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let success):
                dump("🍕api result \(success)")
                completionHandler(success, nil)
            case .failure(let failure):
                print("😱alamofie failure", failure)
                completionHandler(nil, failure)
                
            }
        }

    }
    
}
