//
//  DeclarationEnum.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/02.
//

import Foundation

enum DeclarationEnum: CaseIterable {
    case highPrice
    case lowPrice
    case ath // 이떄까지의 가격 중 가장 높은 가격 - 신고점
    case atl // 이떄까지의 가격 중 가장 낮은 가격 - 신저점

}
