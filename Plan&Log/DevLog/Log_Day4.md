# SoccerInfo DevLog Day4

Fixture Tab - 완료
오늘 날짜를 구할 수 있는 Date extension 필요 - 완료

- 과정, 문제 및 해결
1. realm에서 Date filteriing


```swift
    extension Date {
        var today: Date {
            return Calendar.current.startOfDay(for: self)
        }
        var nextDay: Date {
            return Calendar.current.date(byAdding: .day, value: 1, to: self)!
        }
    }

    //date >= today && date < nextDay
```

- 11:00 ~ 11:30 Fixtures의 Realm, API 호출 완료

2. Codable 사용시 null이 들어있는 데이터가 있어서 옵셔널 지정. 잘보고 해야할듯

3. Date 변환

```swift
//fixtures 포맷 -> Date -> 뷰로 보여줄 포맷. 모든 과정 Dateformatter 이용

//포맷 종류
yyyy-MM-dd 1969-12-31
yyyy-MM-dd 1970-01-01
yyyy-MM-dd HH:mm 1969-12-31 16:00
yyyy-MM-dd HH:mm 1970-01-01 00:00
yyyy-MM-dd HH:mmZ 1969-12-31 16:00-0800
yyyy-MM-dd HH:mmZ 1970-01-01 00:00+0000
yyyy-MM-dd HH:mm:ss.SSSZ 1969-12-31 16:00:00.000-0800
yyyy-MM-dd HH:mm:ss.SSSZ 1970-01-01 00:00:00.000+0000
yyyy-MM-dd'T'HH:mm:ss.SSSZ 1969-12-31T16:00:00.000-0800
yyyy-MM-dd'T'HH:mm:ss.SSSZ 1970-01-01T00:00:00.000+0000

Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
09/12/2018                        --> MM/dd/yyyy
09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
Sep 12, 2:11 PM                   --> MMM d, h:mm a
September 2018                    --> MMMM yyyy
Sep 12, 2018                      --> MMM d, yyyy
Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
12.09.18                          --> dd.MM.yy
10:41:02.112                      --> HH:mm:ss.SSS

```

4. 앱실행시 로그인시키기

- 런칭화면 보여줄 때 사용한 Sleep에서 힌트를 얻음
- DispatchGroup의 wait을 이용해 로그인을 동기적으로 처리
- 로그인이 완료된 후에 첫번째 뷰가 로드되고 로그인된 계정을 사용해야해서 동기적으로 처리


- 14:00 ~ 17:00 - Fixture 붙이기 끝, 해야할거 : 날짜별로 정리



5. 날짜별로 정리 

- 17:00 ~ 19:00  
- FixtureData 일주일 단위 필터 -> 날짜별로 정렬 -> Dictionary 변환 후 사용
- 날짜별로 섹션으로 묶어서 보여주기 완료

```swift
// 날짜도 >,< 를 이용한 비교가 가능
print("2021-11-28T23:00:00+09:00".toDate, "2021-11-29T23:00:00+09:00".toDate)
print("2021-11-28T23:00:00+09:00".toDate < "2021-11-29T23:00:00+09:00".toDate) // true
print("2021-11-28T23:00:00+09:00".toDate > "2021-11-29T23:00:00+09:00".toDate) // false
```

6 Fixture 오늘 기준 주차별 표시
- 21:00 ~ 21:45  

```swift
// 이번주 월요일 날짜 구하기
    var monday = Calendar.current.dateComponents([.weekOfYear, .yearForWeekOfYear], from: self)
    monday.weekday = 2
    return Calendar.current.date(from: monday)!
```

22:00 ~ 00:30

- 경기없음 표시 완료  
- 스와이프 제스쳐는 스토리보드로 추가했다가 안돼서 코드로 구현
- 스와이프 제스쳐를 통한 날짜 이동 완료

01:00 ~ 02:00
- 현재 탭의 league값을 전체 탭에 공유하기위해 LeagueManager 싱글턴을 사용.
- 더 좋은 방법이 있는 경우 변경할 예정
- 이거 쓰고 끝