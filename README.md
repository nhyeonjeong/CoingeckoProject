# Coingecko 리드미

## 🪙스크린샷
![Coin리드미스크린샷 001](https://github.com/nhyeonjeong/CoingeckoProject/assets/102401977/40ab9ff3-7382-4131-b096-ec7d41e8477c)


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
- Alamofire 기반 Networkmanager 구조 구현
    - Generic을 사용해 Decodable한 타입들로 디코딩
    - 통신 결과에 따른 completionHandler실행
    - Router Pattern으로 baseURL, method, endpoint 관리
- Repository Pattern 을 통해 Realm CRUD Interface 구성
- 항상 호출되는 함수를 포함하는 BaseViewController, BaseView 상속받아 class 구현

## 🪙트러블슈팅
### `1. TableView 행 갯수 변경 후 reloadRows 오류`

1-1) 문제

즐겨찾기한 코인이 2개 이상일 때만 Trending화면에 보여주려고 했고, 0번 행은 api통신을 통해 가져온 즐겨찾기 정보, 1, 2번 행은 또 다른 api 통신으로 가져온 정보들로 tableview구성.
리소스를 줄이기 위해 api통신 후 reloadData를 여러번 하는 것 보다 reloadRow를 사용해 필요한 행만 업데이트 하는게 좋을 것이라고 판단.
하지만 즐겨찾기에 코인을 추가해 tableView의 행이 2개에서 3개로 늘어났을 시 tableview의 1, 2번째 행을 reloadRow하는 과정에서 런타임 오류 발생.
reload하기 전에는 아직 2개의 행만 있는 상태인데 2번 행을 업데이트 하는 것이 원인.

1-2) 해결

행이 2개에서 3개로 늘어날 때 tableview의 beginUpdates()와 endUpdates()메서드를 통해 0번째 행을 추가.
만약 다른 api통신 결과를 업데이트하면서 0번 행이 이미 추가됐다면 필요한 행에만 reloadRow실행.
또한 행의 갯수가 바뀌는 것에 대해 분기문으로 추가 대응. 

<details>
<summary>변경 후 코드</summary>
<div markdown="1">
    
![스크린샷 2024-06-27 오전 12 21 15](https://github.com/nhyeonjeong/CoingeckoProject/assets/102401977/8cdeb149-8c40-41ba-9e4b-f92d1ccf3b4e)
![스크린샷 2024-06-27 오전 12 20 54](https://github.com/nhyeonjeong/CoingeckoProject/assets/102401977/69531266-5f2f-4655-9f0a-a4bb93753af7)

</div>
</details>


### `2. API통신횟수 limit 초과시 대응`

2-1) 문제

api통신이 실패할 때마다 "Expected to decode Array<Any> but found a dictionary instead." 오류 발생.
통신횟수 초과됐을 때 받는 메세지가 Decoding하려는 타입과 맞지 않아 발생한 상태코드 429오류인 것으로 확인.

2-2) 해결

Alamofire의 Interceptor을 사용하여 통신에 실패하면 429에러인지 확인.
429에러라면 retry하지 않고 이외의 에러라면 retry하도록 하여 재통신한 결과로 예외처리

<details>
<summary>변경 후 코드</summary>
<div markdown="1">
    
<img width="633" alt="스크린샷 2024-06-30 오후 11 57 57" src="https://github.com/nhyeonjeong/CoingeckoProject/assets/102401977/87ae5244-91f8-4237-9b3d-9c2e2561d804">
<img width="666" alt="스크린샷 2024-06-30 오후 11 58 22" src="https://github.com/nhyeonjeong/CoingeckoProject/assets/102401977/3749f41c-9ec7-4bb6-b799-209039e1c673">

</div>
</details>

## 🪙기술회고
Observable클래스를 직접 만들어 MVVM으로 비동기 코드를 작성함으로서 데이터의 흐름을 더 정확하게 파악할 수 있었고, 코드실행 순서를 파악하는 데에 도움이 되었습니다. 
또한 API통신 후의 결과를 올바른 타입으로 디코딩 해볼 수 있었고, 통신 오류를 겪으며 결과에 대한 상태코드나 오류메세지등에 대해서 생각해볼 수 있었습니다.
