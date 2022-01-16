# DevLog Day 22 - 1.2.1 업데이트

- 맨날쓰는게 아니라 Day로 나누는게 의미가 없어졌지만.. 그냥씀.

## 업데이트 1. 경기일정 페이지 제한
- 첫번째 이전, 마지막 경기 이후로 갈때 얼럿이 나오면서 막아준다.
- 오늘 날짜 자체가 마지막 경기 이후일때 대응도 필요하다. 이건 다음 업데이트때..

---

## 업데이트 2. 리그 변경시 경기일정 오늘 날짜 기준으로 표시
- 다른 리그 일정들을 확인하다가 3월까지 갔는데 다른리그로 넘어가면 그대로 3월이라서 불편했었다.
- 그래서 리그 변경시 firstDay를 오늘기준으로 변경했다.

---

```swift
var firstDay: Date = Date().fixtureFirstDay {
    didSet {
        // gesture work when self is visible only.
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let tab = windowScene.windows.first?.rootViewController as? MainTabBarController,
              let nav = tab.selectedViewController as? UINavigationController,
              nav.visibleViewController == self else { return }
        makeScheduleData()
    }
}
```

- 하지만 firstDay가 변경되면 바로 일정 데이터를 만들었어서 fixtureVC가 최상위 뷰일때만 만들도록 변경했다.

---

## 업데이트 3. 팀별일정 탭 추가
- 기획했었던 팀별일정 탭이 추가됐다.
- 소속 리그의 팀이름들이 필요했었는데 이 과정에서 Localization.team을 computed property로 바꿨다.

```swift
struct LocalizationList {
    static var team: [Int : String] {
        switch PublicPropertyManager.shared.league {
        case .premierLeague:
            return [
                //...
            ]
        case .laLiga:
            return [
                //...
            ]
        case .serieA:
            return [
                //...
            ]
        case .bundesliga:
            return [
                //...
        case .ligue1:
            return [
                /...
            ]
        @unknown default:
            print("LocalizationList team unknown default")
        }
    }
}
```

- 싱글턴이 이럴때 정말 좋다.호호홓

```swift
        let actions: [UIAction] = sortedTeam
            .map { teamDictioanry in
                let action = UIAction(title: "\(teamDictioanry.value)",
                                      image: nil,
                                      identifier: nil,
                                      discoverabilityTitle: nil,
                                      state: .mixed) { [weak self] _ in
                    self?.selectedTeamID = teamDictioanry.key
                    self?.navigationItem.rightBarButtonItem?.title = teamDictioanry.value
                }
                action.state = .off
                return action
            }
        let menu = UIMenu(title: "팀변경",
                          image: nil,
                          identifier: nil,
                          options: .displayInline,
                          children: actions)
        
        let teamMenuButton = UIBarButtonItem(title: LocalizationList.team[selectedTeamID],
                                             image: nil,
                                             primaryAction: nil,
                                             menu: menu)
```
- 이번에 UIMenu를 처음써봤다.
- UIMenu는 children을 가지고 있고 children은 [UIAction]이다.
- 따라서 UIAction을 만들고 UIMenu를 만들어서 버튼의 menu에 사용해야한다.
- 이 과정에서 메뉴에 체크표시가 계속있어서 왜그런가 찾아봤더니 action의 state를 off해야했다.

---

## 4. 업데이트 계획
- 이전에 작성한 로그를 보니 선호하는 리그, 팀을 설정하는거 2개가 남았다.
- 이거도 따로 탭을 만들어서 설정하게 해야할듯.
- 그래서 앱을 켜면 선호하는 리그로 바로 시작하고 팀별일정을 확인할때는 선호하는 팀부터 보게 할 예정이다.
- 요고는 전부 위젯을 사용하려고 사전작업하는거고 위젯으로는 선호하는 팀의 다음경기 일정을 보여주려고 한다.
- 1.2.2는 설정탭의 추가겠고 아마 위젯이 추가된다면 1.3으로 넘어갈듯???????