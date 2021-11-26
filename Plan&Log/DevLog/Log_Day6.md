# SoccerInfo DevLog Day6

## 일정탭 첫시작 로딩에러
- 일정탭은 앱 시작시 처음으로 나오는 뷰다
- 일정탭의 테이블뷰 리로딩에 reloadSection을 사용한다.
- local realm에 최신데이터가 없는 경우 Cloud 또는 API 호출로 비동기적으로 데이터를 받는다.
- 이 비동기로 받아오는 동안 일정탭 테이블뷰는 Section 0개로 생성된다.
- 비동기로 데이터를 받고 reloadSection하면 delete할 section이 없다고 오류가 난다.
- reloadData를 사용하면 오류가 나지 않는다. 하지만 애니메이션이 없어서 노잼

## 해결
- 초기값을 넣어줬다
- 1주일 단위로 일정을 보여주므로 비어있는값 7개를 넣어줬다.

```swift
    // 타이틀 컨텐츠 둘다 7개로 초기화
    var dateSectionTitles = [String](repeating: "", count: 7) {
        didSet {
            scheduleContent = dateSectionTitles.map { schedulesData[$0]! }
        }
    }
    var scheduleContent = [ScheduleContent](repeating: [("","",nil,nil,"")], count: 7) {
        didSet {
            noMatchLabel.isHidden = scheduleContent.count > 0
            schedulesTableView.reloadSections(IndexSet(0 ..< 7), with: .fade)
        }
    }
```
