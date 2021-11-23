# SoccerInfo DevLog Day3

## SideMenu 만들기
- 예상시간: 2시간
- 제작시간: 5시간
- 뷰를 만드는 것외에도 리그 변경 기능을 만드는것을 계산하지 않아 3시간 초과됐다.

### 문제 및 해결
- 일정, 순위, 뉴스 탭 모두 사이드메뉴를 호출하는 BarButtonItem이 있다.
- extension으로 SideMenuNavigationControllerDelegate 설정이 되지 않았다.
- 이 델리게이트는 sideMenuWillDisappear 때문에 필요했다.
- 사이드 메뉴로 리그를 변경하면 데이터를 다시 로드해야하기 때문이다.
- 따라서 BasicTabViewController라는 SuperClass를 만들고 각 뷰를 SubClass로 했다.
- 이 과정에서 각 뷰마다 data의 타입이 달라야했다.
- SuperClass를 Generic으로 만들었다. 이렇게 처음 만들어봤는데 신기했다.

```swift
    // SuperClass
    class BasicTabViewController<T: EmbeddedObject>: UIViewController {
        
        var league: League = .premierLeague
        var season: Int = 2021
        var data: [T] = []
        // ...

    // SubClass
    class StandingsViewController: BasicTabViewController<StandingsRealmData> {
        // ...
    }
```

- Geniric class는 extension으로 @objc 함수를 만들 수 없다고 오류가 나왔다.
- extension으로 만들 필요도 없었기 때문에 SuperClass의 함수로 넣었다.

### 리그 변경 기능 만들기
- enum League를 만들었다. SideMenu의 TableView와 변경된 리그값 전달에 사용된다.
```swift
    enum League: String, CaseIterable {
        case premierLeague = "Premier League"
        case laLiga = "LaLiga"
        case serieA = "Serie A"
        case bundesliga = "Bundesliga"
        case ligue1 = "Ligue 1"
        
        var leagueID: Int {
            switch self {
            case .premierLeague:
                return 39
            case .laLiga:
                return 140
            case .serieA:
                return 135
            case .bundesliga:
                return 78
            case .ligue1:
                return 61
            @unknown default:
                print("league unknown default")
                break
            }
        }
    }   
```
- SideMenu안의 TableView를 enum SideSection과 League를 이용해 구성했다.
- 추후 컵리그나 다른 대회등 확장성을 위해 enum으로 만들었다.

```swift
    enum SideSection: CaseIterable {
        case league

        var title: String {
            switch self {
            case .league:
                return "Leagues"
            @unknown default:
                print("SideSection title unknown default")
            }
        }
        
        var contents: [String] {
            switch self {
            case .league:
                return League.allCases.map { $0.rawValue }
            @unknown default:
                print("SideSection contents unknown default")
            }
        }
    }
    
    let sectionTitles = SideSection.allCases.map { $0.title }
    let contents = SideSection.allCases.map { $0.contents }
    var selectedLeague: League = .premierLeague

    // ...

    extension SideViewController: UITableViewDelegate, UITableViewDataSource {    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SideSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()        
        label.text = "  \(sectionTitles[section])"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .label        
        return label
    }

    // ...

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideTableViewCell.identifier,
                                                 for: indexPath) as! SideTableViewCell
        cell.leagueNameLabel.text = contents[indexPath.section][indexPath.row]
        return cell
    }

```

- 리그 변경 시: SideVC의 리그값 변경 -> sideMenuWillDisappear를 이용해 값전달
```swift

    // SideMenu의 TableView 셀 클릭시 리그값 변경
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // navigationController of this view is SideMenuNavigationController
        let leagueName = contents[indexPath.section][indexPath.row]
        selectedLeague = League(rawValue: leagueName) ?? .premierLeague
        navigationController?.dismiss(animated: true, completion: nil)
    }

    // 순위 뷰에서 SideMenuNavigationControllerDelegate 채택 후 sideMenuWillDisappear 이용
    // SideMenu가 UINavigtionContoller를 상속하는 것을 이용해 topViewController로 sideVC 값에 접근
    extension StandingsViewController: SideMenuNavigationControllerDelegate {
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {        
        guard let sideVC = menu.topViewController as? SideViewController else { return }
        if league != sideVC.selectedLeague {
            league = sideVC.selectedLeague
        }
        print("side menu did disppear")
    }
}

```

## API 호출 및 Realm 업데이트
- API 호출은 Codable을 이용해 Generic 메서드로 만들었다.
```swift
    extension UIViewController {
        func fetchAPIData<T: Codable>(of footBallData: FootballData, url: URL?, completion: @escaping (Result<T, Error>) -> Void) {
            guard let url = url else { return }
            AF.request(url, method: .get, headers: footBallData.headers).validate().responseJSON { response in
                switch response.result {
                case .success(_):
                    guard let data = response.data,
                        let decoded = try? JSONDecoder().decode(T.self, from: data) else { return }
                    completion(.success(decoded))
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
```
- 호출 후에 데이터를 RealmTable로 변경해서 업데이트한다.
```swift
    func updateRealmData<T: RealmTable>(table: T, leagueID: Int, season: Int = 2021) {
        let app = App(id: APIComponents.realmAppID)
        guard let user = app.currentUser else { return }
        let configuration = user.configuration(partitionValue: "\(leagueID)")
        
        Realm.asyncOpen(configuration: configuration) { result in
            switch result {
            case .success(let realm):
                print(realm.configuration.fileURL)
                do {
                    // check league, season
                    let object = realm.objects(T.self).where {
                        $0._partition == "\(leagueID)" && $0.season == season
                    }
                    try realm.write({
                        if object.isEmpty {
                            realm.add(table)
                        }
                        else {
                            print("change data")
                            let prevObject = object.first!
                            prevObject.content = table.content
                            prevObject.updateDate = table.updateDate
                        }
                    })
                }
                catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
```

### 문제 및 해결
- Realm을 업데이트 해야하는데 completion에서 생성한 데이터는 현재 데이터와 다른 PrimaryKey를 가지고 있다.
- 따라서 그냥 추가하면 새로운 데이터가 추가된다.
- 값이 업데이트만 되는 것을 원했기 때문에 updateRealmData를 Generic으로 만들고 RealmTable 프로토콜을 수정했다.
- 그래서 RealmTable을 채택한 Object의 content와 season에 접근할 수 있었다.
```swift
    protocol RealmTable: Object {
        associatedtype T
        var _partition: String { get set }
        var season: Int { get }
        var updateDate: Date { get set}
        var content: T { get set }
    }
    
    // RealmTable 프로토콜을 이용해 content와 updateDate에 접근
    func updateRealmData<T: RealmTable>(table: T, leagueID: Int, season: Int = 2021) {
        Realm.asyncOpen(configuration: configuration) { result in
            switch result {
            case .success(let realm):                
                do {                    
                    try realm.write({                                                
                        let prevObject = object.first!
                        // 이전값을 새로운 값으로 변경
                        prevObject.content = table.content
                        prevObject.updateDate = table.updateDate
                    }
                })                
                catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
```

- multiple sync agents attempted to join the same session  
  realm studio를 켜고 sync를 이용하면 이 오류가 발생한다.  
  데이터 흐름이 모두 끝나고 나서 studio를 사용해서 저장데이터를 확인해야한다.