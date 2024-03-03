//
//  RealmRepository.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/03.
//

import Foundation
import RealmSwift

class RealmRepository {
    static let shared = RealmRepository()
    
    let realm = try! Realm()
    
    func createItem(itemId: String, completionHandler: @escaping () -> Void) {
        print(self.realm.configuration.fileURL)
        // api통신으로 정보 가져오기
        CoinAPIManager.shared.fetchCoinData(type: [CoinDetail].self, api: .coinMarket(ids: itemId)) { coinData in
            print(#function)
            let data = coinData[0]
            let coinData = CoinFavorite(idString: data.idString, name: data.name, symbolName: data.symbol, thumbImageString: data.image)
            do {
                try self.realm.write {
                    self.realm.add(coinData)
                    print("Realm Create")
                    completionHandler()
                }
            } catch {
                print(error)
            }
        }
    }
    
    func fetchItem() -> [CoinFavorite] {
        let result = realm.objects(CoinFavorite.self)
        return Array(result) // 정확한 타입을 써주자
    }
    func removeItem(_ item: CoinFavorite, completionHandler: @escaping () -> Void) {
        do {
            try realm.write {
                realm.delete(item)
                completionHandler()
            }
        } catch {
            print(error)
        }
    }
}
