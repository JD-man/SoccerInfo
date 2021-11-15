# 2021. 11. 15 TeamBuilding

## 내용
- 메모앱 과제 리뷰


## 1. viewDidLoad에서의 최초 팝업뷰 present
- viewDidLoad에서 화면 전환을 한다고 해서 실행이 되지 않는 문제는 없었다.
- 하지만 뷰의 생명주기 관점에서 viewDidLoad에 화면 전환 코드를 넣는 것은 좋지 않다.
- API 호출 등으로 로딩 중이어서 메인뷰가 화면을 그리고 있는데 팝업뷰가 나오는 어색한 상황이 있을 수 있다.
- viewWillAppear의 경우 뷰가 나올 때마다 팝업뷰를 띄워줘야 하는 조건문 코드를 실행하므로 비효율적이다.
- viewDidLayoutSubviews에 최초 팝업뷰 화면 전환 코드를 넣는 것이 제일 좋다는 결론이 나왔다.

## 2. 추가 텍스트 없음
- 내가 만든 메모앱의 경우 Realm에서 불러오는 content가 nil일 경우 ""을 사용했다.
- 메모앱 사용을 잘못 이해해 content가 nil일때만 "추가 텍스트 없음"을 넣는 줄 알았다.
- content가 nil일 경우 "추가 텍스트 없음"을 넣어주면 되지만 "\n"만 여러개 있는 경우가 문제된다.
- 이 경우 "\n"을 제외한 다른 글자가 있는지 찾아 없으면 "추가 텍스트 없음"을 넣어줘야 한다.
```swift
    // 간단한 예시
    let isVaildContent = memoContent.filter { $0 != "\n" }.count > 0
    let cellContent = isValidContent ? memoContent : "추가 텍스트 없음"
```

