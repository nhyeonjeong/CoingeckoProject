//
//  SearchViewMoel.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import Foundation
import RealmSwift

final class SearchViewModel {
    var inputFetchFavoriteTrigger: Observable<Void?> = Observable(nil) // 즐겨찾기 가져오기
    var favoriteList: Observable<[CoinFavorite]> = Observable([])
    // 검색한 문자열
    var inputSearchText: Observable<String?> = Observable("")
    // api로 가져온 Coin리스트
    var oupPutSearchCoinData: Observable<[Coin]> = Observable([])
    // 테이블 특정 행 리로드
    var outPutTableReloadRow: Observable<Int> = Observable(0)
    var outputStarClicked: Observable<Bool> = Observable(false)
    var deleteItemIdx = 0 // 즐겨찾기목록에서 지워질 인덱스
    init() {
        bindData()
    }
    
    private func bindData() {
        inputSearchText.bind { searchText in
            // searchText로 api통신 후 oupPutSearchCoinData에 넣기
            print("inputSearchText bind")
            if let text = searchText {
                CoinAPIManager.shared.fetchCoinData(type: Coingecko.self, api: .search(query: text), completionHandler: { value, error in
                    guard let value else { return }
                    self.oupPutSearchCoinData.value = value.coins
                    print("oupPutSearchCoinData value", value)
                })
            }
        }
        // 즐겨찾기목록 다시 가져오기
        inputFetchFavoriteTrigger.bind { _ in
            print("inputFetchFavoriteTrigger.bind")
            self.favoriteList.value = RealmRepository.shared.fetchItem()
            
        }
    }
    
    // 즐겨찾기 유무에 대한 별 바꾸기
    func isFavoriteItem(tag: Int) -> Bool {
        var isFavorite: Bool = false
        // 즐겨찾기에 있는지 확인 후 유무에 따라 별 바꾸기
        for i in 0..<favoriteList.value.count {
            if favoriteList.value[i].idString == oupPutSearchCoinData.value[tag].idString {
                // 즐겨찾기 목록에 이미 있다면 즐겨찾기 해재
//                favStar.setImage(Constants.Image.favInactiveStar, for: .normal)
                deleteItemIdx = i
                isFavorite = true
                
            }
        }
        return isFavorite
    }
    
    /// 즐겨찾기 버튼 눌렸을 때
    func toggleFavStar(tag: Int) {
        // 해결법)
        inputFetchFavoriteTrigger.value = ()
        
        if isFavoriteItem(tag: tag) { // 즐겨찾기에 있는 코인이면 삭제
            RealmRepository.shared.removeItem(favoriteList.value[deleteItemIdx]) {
                self.inputFetchFavoriteTrigger.value = () // 즐겨찾기 목록 다시 가져오기(즐겨찾기에 넣어주는것보다 빠름,,)
                self.outPutTableReloadRow.value = tag
                self.outputStarClicked.value = false
            }
        } else {
            // 즐겨찾기 목록이 9개 이하일떄만 추가
            
            if favoriteList.value.count < 10 {
                print("즐겨찾기에 없으니까 추가")
                RealmRepository.shared.createItem(itemId: oupPutSearchCoinData.value[tag].idString) {
                    self.inputFetchFavoriteTrigger.value = () // 즐겨찾기 목록 다시 가져오기(즐겨찾기에 넣어주는것보다 빠름,,)
                    self.outPutTableReloadRow.value = tag
                    self.outputStarClicked.value = true
                }
            }
        }
        print("favoriteList : ", favoriteList.value)

    }
}
