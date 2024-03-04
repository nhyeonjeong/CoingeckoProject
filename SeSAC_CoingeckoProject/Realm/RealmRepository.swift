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
    
    func createItem(_ data: CoinFavorite) {
        print(self.realm.configuration.fileURL)
        // api통신으로 정보 가져오기 -> api통신 왜했지1?!!바보냐
        do {
            try realm.write {
                realm.add(data)
                print("realm creat")
            }
        } catch {
            print(error)
        }
    }
    
    func fetchItem() -> [CoinFavorite] {
        let result = realm.objects(CoinFavorite.self)
        return Array(result) // 정확한 타입을 써주자
    }
    func removeItem(_ item: CoinFavorite) {
        do {
            try realm.write {
                realm.delete(item)
                print("realm delete")
            }
        } catch {
            print(error)
        }
    }
}
