//
//  SearchViewController.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import UIKit
import Toast

final class SearchViewController: BaseViewController {

    let mainView = SearchUIView()
    let viewModel = SearchViewModel()
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        configureTableView()
        configureSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("즐겨찾기 목록 가지고 오기")
        viewModel.inputReadFavListTrigger.value = () // 즐겨찾기목록 패치
    }
    
    func bindData() {
        viewModel.outputFavoriteList.bind { _ in
            print("outputFavoriteList didSet - 즐겨찾기목록 바뀌면 테이블 reload")
            self.mainView.tableView.reloadData()
        }
        viewModel.outputSearchList.bind { _ in
            print("oupPutSearchList bind - 검색결과목록이 바뀌면 테이블 Reload")
            self.mainView.tableView.reloadData()
        }
        
        
        viewModel.outputTableReloadRow.bind { value in
            print("oupPutTableReloadRow bind - 즐겨찾기realm에 추가/삭제 한 후에 한 행 reload")
            self.mainView.tableView.reloadRows(at: [IndexPath(row: value, section: 0)], with: .fade)

        }
        viewModel.outputStarClicked.bind { value in
            print("outputStarClicked bind - toast띄우기")
            if value {
                self.mainView.makeToast("즐겨찾기에 추가되었습니다", duration: 1.0, position: .top)
            } else {
                self.mainView.makeToast("즐겨찾기에서 해제되었습니다", duration: 1.0, position: .top)
            }
        }
        viewModel.transitionWithId.bind { idString in
            let vc = ChartViewController()
            guard let id = idString else {
                self.view.makeToast("정보를 불러오지 못했습니다.", duration: 1.0, position: .top)
                return // 화면전환하지 말기
            }
            vc.coinDataId = id
            vc.popClosure = {
                self.view.makeToast("통신상태가 좋지 않습니다.", duration: 2.0, position: .top)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // 즐겨찾기 버튼 눌렀을 때
    @objc
    func favStarClicked(_ sender: UIButton) {
        print(#function)
        viewModel.toggleFavStar(tag: sender.tag)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func configureTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputSearchList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        let data = viewModel.outputSearchList.value[indexPath.row]
        cell.configureCell(coinData: data, row: indexPath.row)

        // 검색한 단어는 보라색으로
        let attribtuedString = NSMutableAttributedString(string: data.name)
        let range = (data.name as NSString).range(of: mainView.searchBar.text!)
        attribtuedString.addAttribute(.foregroundColor, value: Constants.Color.pointColor, range: range)
        cell.coinView.coinTitleLabel.attributedText = attribtuedString
        
        // 즐겨찾기 유무 확인해서 Image넣기
        let favStarImage = viewModel.isFavoriteItem(tag: indexPath.row) ? Constants.Image.favStar : Constants.Image.favInactiveStar
        cell.favStar.setImage(favStarImage, for: .normal)
        
        // 즐겨찾기 버튼 눌렀을 대
        cell.favStar.tag = indexPath.row // 가지고 온 검색결과에서 몇 번째인지 지정 -> 버튼 눌렀을 떄 어떤 검색결과를 눌렀는지 알 수 있다.
        cell.favStar.addTarget(self, action: #selector(favStarClicked), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.transitionWithId.value = viewModel.outputSearchList.value[indexPath.row].idString
    }
}

extension SearchViewController: UISearchBarDelegate {
    func configureSearchBar() {
        mainView.searchBar.delegate = self
    }
    
    // return을 누르면
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputSearchText.value = searchBar.text
        view.endEditing(true) // 키보드 내리기
    }
}
