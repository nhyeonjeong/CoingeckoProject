//
//  BaseViewController.swift
//  SeSAC_CoingeckoProject
//
//  Created by 남현정 on 2024/03/01.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self, #function) // self는 컨트롤러 인스턴스
        
        // 모든 화면은 흰 색(uiview가 없는 뷰도 있을 수 있어서 VC에 작성,,)
        view.backgroundColor = Constants.Color.lightBackground
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    func configureHierarchy() {
        
    }
    
    func configureConstraints() {
        
    }
    
    func configureView() {
        
    }
}
