//
//  Observable.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import Foundation

class Observable<T> {
    // 내가 모르는 기능이 들어오도록
    private var closure: ((T) -> Void)?
    
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void ) {
        print(#function)
        closure(value)
        self.closure = closure
        
    }
}
