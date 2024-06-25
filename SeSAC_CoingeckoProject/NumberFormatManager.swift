//
//  NumberFormatterManager.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/04.
//

import Foundation

class NumberFormatManager {
    
    static let shared = NumberFormatManager() // 하나의 메모리공간만 이유) NumberFormatter나 DateFormmater는 다른것보다 연산하는데 시간이 든다고 한다
    // 그래서 하나 만들어놓고 재사용하는게 좋겠다는 판단에 싱글톤으로
    
    private init() {
        
    }
    
    // 이렇게 작성하면 한 번 클래스를 만든 이상 내려가지 않을 것이다. 계속쓸 예정일 때 적합
    private let numberFormatter = NumberFormatter()
    
    func calculator(_ number: Double) -> String {
        numberFormatter.numberStyle = .decimal// 3자리마다 쉼표 찍어주는 기능
        let result = numberFormatter.string(from: number as NSNumber)
        // result는 String?타입
        return result ?? "0"
    }
    
}
