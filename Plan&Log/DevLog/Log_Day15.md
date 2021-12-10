# DevLog Day15

## 1.1.0(2) 테스트플라이트 업로드
- 하지만 테스트플라이트 이슈가 있었다.

## 테스트 플라이트 이슈
- https://developer.apple.com/forums/thread/696197
- 테스트플라이트에 올려서 받으면 앱 실행되자마자 크래시나는 현상이 발생중
- 앱 실행이 제대로 안돼서 거절됐었던 내 프로젝트는 거절사유가 해소됐는지 알 수 없어짐...

#### 해결방법
- Build Phase -> Link Binary With Libraries -> libswift_Concurrency.tbd 추가

#### 해결?
- 해결은 된다고 하지만 이런걸 함부로 건드리기는 부담이 된다.
- 업데이트를 기다릴 예정
- 기다리는 동안 프로젝트나 정리할 생각