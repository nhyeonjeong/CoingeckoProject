//
//  UIView+Extension.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import UIKit

// extension은 저장프로퍼티를 만들지 못한다.
extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
}
