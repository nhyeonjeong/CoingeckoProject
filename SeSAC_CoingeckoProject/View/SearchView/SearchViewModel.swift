//
//  SearchViewMoel.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import Foundation
import RealmSwift

final class SearchViewModel {
    var inputReadFavListTrigger: Observable<Void?> = Observable(nil) // 즐겨찾기 가져오기
    var outputFavoriteList: Observable<[CoinFavorite]> = Observable([]) // 즐겨찾기 목록
    
    var inputSearchText: Observable<String?> = Observable("") // 검색한 문자열
    var outputSearchList: Observable<[Coin]> = Observable([]) // api로 가져온 Coin리스트

    var outputTableReloadRow: Observable<Int> = Observable(0) // 테이블 특정 행 리로드
    var outputStarClicked: Observable<Bool> = Observable(false)
    
    var transitionWithId: Observable<String?> = Observable(nil)
    
    var deleteItemIdx = 0 // 즐겨찾기목록에서 지워질 인덱스
    init() {
        bindData()
    }
    
    private func bindData() {
        // 즐겨찾기목록 다시 가져오기
        inputReadFavListTrigger.bind { _ in
            print("inputReadFavListTrigger didSet - 즐겨찾기 트리거 받고 realm read, outputFavoriteList에 결과 넣기")
            self.outputFavoriteList.value = RealmRepository.shared.fetchItem()
        }
        inputSearchText.bind { searchText in
            // searchText로 api통신 후 oupPutSearchList에 넣기
            print("inputSearchText didSet - 검색단어가 들어오면 네트워크 통신")
            if let text = searchText {
                CoinAPIManager.shared.fetchCoinData(type: Coingecko.self, api: .search(query: text), completionHandler: { value, error in
                    guard let value else { return }
                    self.outputSearchList.value = value.coins
                })
            } else {
                print("검색한 단어가 없습니다")
            }
        }
    }
    
    // 즐겨찾기 유무에 대한 별 바꾸기
    func isFavoriteItem(tag: Int) -> Bool {
        var isFavorite: Bool = false
        // 즐겨찾기에 있는지 확인 후 유무에 따라 별 바꾸기
        for i in 0..<outputFavoriteList.value.count {
            if outputFavoriteList.value[i].idString == outputSearchList.value[tag].idString {
                // 즐겨찾기 목록에 이미 있다면 삭제할 인덱스 저장
                deleteItemIdx = i
                isFavorite = true
            }
        }
        return isFavorite
    }
    
    /// 즐겨찾기 버튼 눌렸을 때
    func toggleFavStar(tag: Int) {
        if isFavoriteItem(tag: tag) { // 즐겨찾기에 있는 코인이면 삭제

            RealmRepository.shared.removeItem(outputFavoriteList.value[deleteItemIdx])
            self.inputReadFavListTrigger.value = () // 즐겨찾기 목록 다시 가져오기(rowreload보다 빠르다)
            self.outputTableReloadRow.value = tag // 한 행만 바꾸면 된다
            self.outputStarClicked.value = false // toast띄우기
            
        } else {
            // 즐겨찾기 목록이 9개 이하일떄만 추가
            if outputFavoriteList.value.count < 10 {
                print("즐겨찾기에 없으니까 추가")
                let rowData = outputSearchList.value[tag]
                let coin = CoinFavorite(idString: rowData.idString, name: rowData.name, symbolName: rowData.symbol, thumbImageString: rowData.thumbImage)
                RealmRepository.shared.createItem(coin)
                self.inputReadFavListTrigger.value = () // 즐겨찾기 목록 다시 가져오기(즐겨찾기에 넣어주는것보다 느려서 ㄱㅊ)
                self.outputTableReloadRow.value = tag
                self.outputStarClicked.value = true
                
            }
        }
//        print("favoriteList : ", outputFavoriteList.value)
    }
}
