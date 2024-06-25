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
        print(realm.configuration.fileURL!)
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
