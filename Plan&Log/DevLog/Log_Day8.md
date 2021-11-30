# DevLog Day8

## 클라우드 접속 방식 익명으로 다시 변경
- 사용하고있던 identifierForVender은 앱삭제후 재설치시 초기화된다.
- 익명으로 로그인하는거나 다를바 없고 오히려 익명 유저는 2개월 후 없어진다. 관리가 더 편함
- identifierForVender로하면 리젝당할거 같기도하고..

## 경기 시작 1시간 전 알림 설정
- 알림 설정 거부시 코드는 아직 작성하지 않았다.
- 여러일 거쳐서 테스트 후 더 설정 예정

## 테스트 플라이트 후 오류 수정

### 뉴스탭 오른쪽 레이아웃 설정 - 기사 요약 부분 numberOfLines를 0으로해서 생긴 문제. 수정 완료
### 가로모드 막기 - Target -> BuildSetting에 Portrait만 되도록 설정 가능. 수정 완료
### 리그 변경 버튼 글씨색 변경 - 버튼인지 몰라서 못썼다는 얘기가 많아서 파란색으로 변경
### 스와이프 기능 설명 - 스와이프 기능이 있는지 몰라서 못썼다는 얘기가 있었음. 스크린샷이든 튜토리얼이든 설명방법을 찾는중
### 클라우드 접속 익명으로 변경

## SceneDelegate에서 로그인 문제
- 테스트 플라이트 충돌 피드백을 받아서 확인해보니 메인 스레드 크래시가 있었음
- 이 때 현상은 무한로딩이 걸리고 접속 실패 얼럿이 나오는 것
- 이 얼럿과 무한로딩은 유저가 로그인되지 않았을 때 나오는 현상이다.
- 얼럿나오는게 로그인 안될때밖에 없음.
- SceneDelegate에서 DispatchGroup을 이용하는 코드를 변경했었는데 여기서 생기는 오류 같아 수정.
```swift
    let group = DispatchGroup()
    // 이 큐를 사용했다가 삭제했었다.
    let queue = DispatchQueue(label: "RealmLogin")
    
    group.enter()
    print("login start")
    // 큐를 이용한 비동기를 사용했다가 삭제했었다.
    queue.async {
        let app = App(id: APIComponents.realmAppID)
        if let currentUser = app.currentUser {
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
    
    group.wait()
    print("login end")
```

- 결과적으로 print 찍어보니 로그인 시작과 로그인 종료시 시간 공백이 다시 생겼다.
- 그리고 로그인이 완료됐다는 print 다음 FixturesVC의 viewDidLoad가 호출됐다.
- 이 공백이 없어졌을때 로그인이 제대로 안되겠다고 생각했어야 했는데 못했다.
- 앱 첫화면 로딩 이전에 로그인이 필요한 경우!!!  
  => SceneDelegate에서 DispatchGroup을 메인큐가 아닌곳에서 비동기로 돌려야한다.


