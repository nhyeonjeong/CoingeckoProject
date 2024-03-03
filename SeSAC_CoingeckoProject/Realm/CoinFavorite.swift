//
//  CoinFavorite.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/03.
//

import Foundation
import RealmSwift

class CoinFavorite: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var idString: String
    @Persisted var name: String
    @Persisted var symbolName: String
    @Persisted var thumbImageString: String

    
    convenience init(idString: String, name: String, symbolName: String, thumbImageString: String) {
        self.init()
        self.idString = idString
        self.name = name
        self.symbolName = symbolName
        self.thumbImageString = thumbImageString

    }
}
