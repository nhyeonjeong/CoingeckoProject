//
//  Constants.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import UIKit

enum Constants {
    enum Font {
        static let title = UIFont.boldSystemFont(ofSize: 30)
        static let subTitle = UIFont.boldSystemFont(ofSize: 19)
        
        static let boldMain = UIFont.boldSystemFont(ofSize: 17)
        static let main = UIFont.systemFont(ofSize: 17)
        static let subMain = UIFont.systemFont(ofSize: 14)
        
        static let favNumber = UIFont.boldSystemFont(ofSize: 17)
        static let favMediumNumber = UIFont.systemFont(ofSize: 15)
        static let favSmallNumber = UIFont.boldSystemFont(ofSize: 13)
    }
    
    enum Color {
        static let pointColor = UIColor(named: "pointColor")
        static let boxBackground = UIColor(named: "boxBackground")
        static let lightBackground = UIColor(named: "lightBackground")
        
        static let titleLabel = UIColor(named: "titleColor")
        static let subLabel = UIColor(named: "subLabel") // 진남색.?
        static let smallLabel = UIColor(named: "smallLabel") // 진회색

        static let upParcentLabel = UIColor(named: "upLabel")
        static let upPercentBackground = UIColor(named: "upPercentBackground")
        
        static let downPercentLabel = UIColor(named: "downLabel")
        static let downPercentBackground = UIColor(named: "downBackground")
        
    }
    
    enum Image {
        static let tabTrendingImage = UIImage(named: "tab_trend")
        static let tabSearchImage = UIImage(named: "tab_search")
        static let tabFavoriteImage = UIImage(named: "tab_portfolio")
        static let tabUserImage = UIImage(named: "tab_user")
        
        static let tabTrendingInactiveImage = UIImage(named: "tab_trend_inactive")
        static let tabSearchInactiveImage = UIImage(named: "tab_search_inactive")
        static let tabFavoriteInactiveImage = UIImage(named: "tab_portfolio_inactive")
        static let tabUserInactiveImage = UIImage(named: "tab_user_inactive")
        
        static let favStar = UIImage(named: "btn_star")
        static let favInactiveStar = UIImage(named: "btn_star_fill")
        
        static let cointDefaultImage = UIImage(systemName: "circles.hexagonpath.fill")
        
    }
}
