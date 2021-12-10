# SoccerInfo - 해외축구 정보 앱

## Overview
<div align = "center">
    <a href = "https://youtu.be/SrqsYSq0zEI"><img src = "https://img.youtube.com/vi/SrqsYSq0zEI/0.jpg">
    </a>
</div>

- 일정, 순위, 뉴스 확인
- 경기결과 확인
- 경기세부정보 확인 - 경기기록, 포메이션, 선발/후보 명단
- 5개 국가 리그 - 영국, 스페인, 독일, 프랑스, 이탈리아
- 제작기간: 기획 1주, 개발 2주

## Framework, Library
- UIKit
- Alamofire(https://github.com/Alamofire/Alamofire)
- Kingfisher(https://github.com/onevcat/Kingfisher)
- Realm-cocoa(https://github.com/realm/realm-cocoa)
- SideMenu(https://github.com/jonkykong/SideMenu)
- Google Analytics, Crashlytics

## Project Plan
- [기획](./Plan&Log/Plan/README.md)

## Log
- [개발기록](./Plan&Log/DevLog)
- 1주차 영상(https://youtu.be/Pgfj12BiwP4)
- 2주차 1차 업데이트 제출 영상(https://youtu.be/SApj6SQNYGQ)
- 발표영상(https://youtu.be/SrqsYSq0zEI) 

## Feature

### API Request를 위한 Codable과 Generic Method
- 축구정보를 받아오기 위해 API 호출
- Codable 프로토콜을 채택한 구조체 사용
- 하나의 Generic Method를 모든 API 호출에 사용

```swift
func fetchAPIData<T: Codable>(of footBallData: FootballData, url: URL?, completion: @escaping (Result<T, APIErrorType>) -> Void) {
    guard let url = url else {
        print("url fail")
        return            
    }
    AF.request(url, method: .get, headers: footBallData.headers)
        .validate(statusCode: 200 ... 500)
        .responseJSON { [weak self] response in
            switch response.result {
            case .success(_):
                let statusCode = response.response?.statusCode ?? 500
                switch statusCode {
                case 429:
                    completion(.failure(.requestLimit))
                    self?.alertAPIError(statusCode: statusCode)
                case 499:
                    completion(.failure(.timeout))
                    self?.alertAPIError(statusCode: statusCode)
                case 500:
                    completion(.failure(.serverError))
                    self?.alertAPIError(statusCode: statusCode)
                default:
                    guard let data = response.data,
                          let decoded = try? JSONDecoder().decode(T.self, from: data) else {
                              print("decode fail")
                              return }
                    completion(.success(decoded))
                    print("API CALL")
                }
            case .failure(let error):
                self?.alertWithCheckButton(title: "데이터를 가져오는데 실패했습니다",
                                           message: "네트워크 연결 상태를 확인해주세요.",
                                           completion: nil)
                print(error)
            }
        }
}
```

### 정보 저장을 위한 Realm과 Realm Sync
- 축구 정보에서 뷰에 필요한 부분을 Realm에 저장.
- MongoDB와 Realm Sync를 이용해 Cloud DB에 저장. 모든 유저가 축구 정보 공유
- RealmTable Protocol을 만들어 Generic Method 제작.

```swift
    // T is determined when ViewController declare typealias
    func fetchRealmData<T: RealmTable>(league: League, season: Int, completion: @escaping (Result<T, RealmErrorType>) -> Void ) {
        let app = App(id: APIComponents.realmAppID)
        guard let user = app.currentUser else {
            alertWithCheckButton(title: "서버 접속에 실패했습니다",
                                 message: "네트워크 연결 상태를 확인하고 다시 시도해주세요.",
                                 completion: nil)
            return            
        }
        let configuration = user.configuration(partitionValue: "\(league.leagueID)")
        do {
            // Local Realm Load
            print("Local Realm Load")
            let localRealm = try Realm(configuration: configuration)
            
            // check league, season, updateDate
            let objects = localRealm.objects(T.self).where {
                $0._partition == "\(league.leagueID)" &&
                $0.season == season &&
                $0.updateDate > Date()
            }
            if objects.isEmpty {
                // Cloud Realm Load
                print("Cloud Realm Load")
                Realm.asyncOpen(configuration: configuration) { [weak self] result in
                    switch result {
                    case .success(let realm):
                        let syncedObjects = realm.objects(T.self).where {
                            $0._partition == "\(league.leagueID)" &&
                            $0.season == season &&
                            $0.updateDate > Date()
                        }
                        if syncedObjects.isEmpty {
                            completion(.failure(.emptyData))
                        }                        
                        else {
                            completion(.success(syncedObjects.first!))
                        }
                        print("Cloud Realm Loaded")
                    case .failure(let error):
                        print("sync realm error", error)
                        completion(.failure(.asyncOpenFail))
                        self?.alertWithCheckButton(title: "Error Code : 1", message: "", completion: nil)
                    }
                }
            }
            else {
                completion(.success(objects.first!))
                print("Local Realm loaded")
            }
        }
        catch {
            print("realm fail", error)
            completion(.failure(.realmFail))
            alertWithCheckButton(title: "Error Code : 2", message: "", completion: nil)
        }
    }
```

### 기본 뷰 컨트롤러 Superclass 제작 및 상속
- 프로젝트 일관성을 위해 탭의 뷰 컨트롤러 추상클래스 제작
- 뷰 컨트롤러마다 사용되는 data가 달라 Generic Class로 제작

```swift
class BasicTabViewController<T: BasicTabViewData>: UIViewController, UINavigationControllerDelegate, SideMenuNavigationControllerDelegate {
    
    var data: [T] = []
    var season: Int = 2021
    var activityView = UIActivityIndicatorView()
    
    var league: League = .premierLeague {
        didSet {
            fetchData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
        sideButtonConfig()
        league = PublicPropertyManager.shared.league
    }
    
    func viewConfig() {
        view.backgroundColor = .systemBackground
        activityView = activityIndicator()
    }
    
    func sideButtonConfig() {
        // ...
    }
    
    @objc func sideButtonClicked() {
        // ...
    }
    
    // for sharing league value whole tab
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // ...
    }
    
    // for sharing league value whole tab
    override func viewWillAppear(_ animated: Bool) {
        // ...
    }
    
    // change league
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        // ...
    }
    
    // abstract method for fetching data
    internal func fetchData() { }
}
```
### DispatchGroup을 이용한 클라우드 접속처리
- 첫번째 viewDidLoad전에 클라우드에 접속할 필요가 있음
- AppDelegate에서 접속처리

```swift
// Synchronous Configure
    let group = DispatchGroup()
    let queue = DispatchQueue.global(qos: .userInitiated)
        
    group.enter()
    print("login start")
    queue.async {
        let app = App(id: APIComponents.realmAppID)
        if let currentUser = app.currentUser, currentUser.isLoggedIn {
            print("current user exist",currentUser.id)
            sleep(1)
            group.leave()
            return
        }
        else {
            app.login(credentials: .anonymous) { result in
                switch result {
                case .success(let user):
                    print("new anonymous", user.id)
                    group.leave()
                case .failure(let error):
                    print(error)
                    group.leave()
                }
            }
        }
    }
        
    // ...    
        
    // Wait until All Configure
    group.wait()
    print("AppDelegate end")
    return true
```

### 공통 속성을 관리하는 싱글턴
- 싱글턴 패턴을 사용해 모든 탭에서 같아야하는 속성 관리
- 하나의 탭에서 리그가 변경되면 다른 탭으로 이동시 변경된 리그에 대한 정보 표시

```swift
final class PublicPropertyManager {
    private init() {}
    static let shared = PublicPropertyManager()
    
    var league: League = .premierLeague
    var season: Int = 2021
}
```
