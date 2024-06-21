# Coingecko 리드미

## 🪙스크린샷


## 🪙프로젝트 소개
> 현재 코인의 트렌딩정보와 상세정보를 볼 수 있고 검색 및 즐겨찾기 할 수 있는 앱
- iOS 1인 개발
- 개발 기간
    - 기간 : 24.2.29 ~ 24.3.4
- 개발 환경
    - 최소버전 15.0
    - 세로모드, 라이트모드만 지원
 
## 🪙핵심기능
- 코인 검색 및 즐겨찾기 등록
- Top 15 코인과 Top7 NFT 확인
- 코인 상세 정보와 코인 그래프 확인

## 🪙사용한 기술스택
- UIKit, CodeBaseUI, MVVM
- Alamofire, Realm, Snapkit, Toast, Kingfisher, DGCharts
- Decoder, Singleton, Access Control, Router Pattern

## 🪙기술설명
- MVVM InputOutput패턴
    - 비즈니스로직 분리를 위해 ViewController과 ViewModel분리 및 Observable 클래스를 사용해 MVVM InputOutput패턴으로 작성
    - 비동기코드를 핸들링 하기 위해 Observable 클래스 내부 값 변경시 클로저 실행하여 반응형 코드 작성 
- Snapkit을 import하는 mainView 분리하여 loadView로 뷰 구현
- Alamofire을 사용한 NetworkManager Singleton패턴으로 구성
    - Generic을 사용해 Decodable한 타입들로 디코딩
    - 통신 결과에 따른 completionHandler실행
    - Router Pattern으로 baseURL, method, endpoint 관리
- RealmRepository 싱글톤으로 작성, repository에서 CRD 관리
- 항상 호출되는 함수를 포함하는 BaseViewController, BaseView 상속받아 class 구현

## 🪙트러블슈팅
### `1. completionHandler`

1-1) 문제

Trending을 보여주는 뷰에서 @escaping코드를 써주지 않으면 통신을 마치기도 전에 코드가 진행되어서 제대로된 숫를 가져올 수 없는 문제

1-2) 해결



<details>
<summary>변경 후 코드</summary>
<div markdown="1">


</div>
</details>


### `2. Decoding`

2-1) 문제



2-2) 해결



<details>
<summary>변경 후 코드</summary>
<div markdown="1">


</div>
</details>

## 🪙기술회고
