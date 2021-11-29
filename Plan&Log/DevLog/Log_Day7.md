# SoccerInfo DevLog Day7

## Emoji To UIImage
- 골넣는 이벤트에 축구공 표시를 해줘야 했음.
- 이모지의 축구공은 Stiring 타입
- 아래 예시코드를 사용해서 해결!
```swift
    func image() -> UIImage? {
        let size = CGSize(width: 100, height: 100)
        let rect = CGRect(origin: .zero, size: size)
        return UIGraphicsImageRenderer(size: size).image { context in
            (self as NSString).draw(in: rect, withAttributes: [.font : UIFont.systemFont(ofSize: 80)])
        }
    }
```

## Rotate Image
- 교체 이벤트에 사용할 양방향 화살표가 필요했음
- SF Symbols에는 arrow.left.arrow.right만 있고 반대는 없었음.. 왜??
- 그래서 회전시킬 방법이 필요해서 아래 예시코드 사용
- CGImage를 사용해서 그런지 색상이 잘 적용안됐는데 rendering mode를 template 사용하게해서 해결
```swift
    if let homeImage = eventDetail?.eventsImage?.cgImage {
        let rotatedImage = UIImage(cgImage: homeImage,        
                                   scale: 1.0,
                                   orientation: .upMirrored)
        homeEventTypeImageView.image = rotatedImage.withRenderingMode(.alwaysTemplate)
    }
```

## 오타
- 테이블뷰에 그림자를 적용하려고했는데 계속 안됨
- layer.shadowOpacity가 아니라 layer.opacity를 변경하고 있었음...

## Activity Indicator
- 스켈레톤뷰 라이브러리를 사용하려다가 생각보다 해야할게 많아서 사용안했다.
- 스켈레톤뷰는 따로 학습후 다음 프로젝트에 적용할 예정.
- UIKit의 Activity Indicator를 UIViewController의 extension으로 추가하고 사용.
---

## DB 업데이트 시간 변경 (API Call 시간 변경)
- 해외 축구 경기는 보통 새벽에 끝난다
- 원래 자정이 업데이트 시간이었지만 새벽 6시로 변경
- 새벽 6시로 변경되면서 업데이트 시간을 변경하는 코드를 생각하는데 시간이 걸렸다.
- 새로운 RealmTable의 updateDate: 생성일의 6시

### 업데이트 결정 방식
- 현재 DB의 updateDate > fetchTime 이면 API Call을 하지 않는다.
- fetchTime > 현재 DB의 updateDate인 경우 업데이트한다.
- 업데이트할때 다음 업데이트 시간을 설정해줘야 하는데 이 경우 3가지 경우에 따라 코드가 다르다.

### 새로운 업데이트 시간 설정 경우의 수
1. fetchTime과 updateDate가 같은날(6시 ~ 자정 업데이트)
2. fetchTime과 updateDate가 다른날(자정 이후 ~ 6시 업데이트)
3. fetchTime과 updateDate가 다른날인데 오전 6시를 넘긴 경우

### 새로운 업데이트 시간 설정
1. 1의 경우 다음날 오전 6시로 변경
2. 2의 경우 fetchTime의 날짜에 오전 6시로 변경
3. 3의 경우 fetchTime의 날짜에 다음날 오전 6시로 변경

### 어려웠던점
- 자정업데이트로 간단하게 했다가 변경하니 그냥 간단하게 되는줄 알았다.
- 오늘 새벽 6시와 내일 새벽 6시는 오늘과 내일을 같이 생각해줘야했다.
- 앱을 사용안하다가 내일 새벽 6시가 지난 경우도 생각해줘야하는 부분이 쉽게 생각나지 않았다.
- 이게 틀릴수도있으므로 사용하면서 계속 테스트가 필요하다. 이 부분이 제일 무섭다.

---