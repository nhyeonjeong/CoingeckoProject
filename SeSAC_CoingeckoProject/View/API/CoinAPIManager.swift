//
//  CoinAPIManager.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import Foundation
import Alamofire

enum APIError: Int, Error {
    case overLimit = 429
}

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
                   encoding: URLEncoding(destination: .queryString), interceptor: APIRequestInterceptor()).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success, nil)
                
            case .failure(let failure):
                if let afError = failure.asAFError, case .requestRetryFailed(let retryError, _) = afError {
                    if let error = retryError as? APIError, error == .overLimit {
                        completionHandler(nil, error)
                    } else {
                        completionHandler(nil, failure)
                    }
                }
                completionHandler(nil, failure)
            }
        }
    }
}

class APIRequestInterceptor: RequestInterceptor {
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let status = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        if status == 429 {
            completion(.doNotRetryWithError(APIError.overLimit))
        } else {
            completion(.retry)
        }
    }
}

