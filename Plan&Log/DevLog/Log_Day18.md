# DevLog Day 18

## Squad Collection View Cell에 데이터 입히기

- 만들어 놓은 Generic Method를 사용할지 이 뷰를 위해 새롭게 만들지 고민.
- 데이터를 모두 받아온 다음 filter나 sorted하면 너무 비효율적이라고 생각이 듬.
- Realm이 있으니 그 기능을 사용하는게 좋겠다 싶어서 새로운 Method를 만듬.


```swift
let configuration = user.configuration(partitionValue: "\(league.leagueID)")
    do {
        // Local Realm Load
        print("Local Realm Load")
        let localRealm = try Realm(configuration: configuration)
        
        // check league, season, updateDate
        let objects = localRealm.objects(FixturesTable.self).where {
            $0._partition == "\(league.leagueID)" &&
            $0.season == season
        }
        
        let teamFixture = objects[0].content.where { [weak self] in
            ($0.homeID == self!.id || $0.awayID == self!.id) &&
            $0.homeGoal != nil }
            .sorted { $0.fixtureDate > $1.fixtureDate }
        
        let fixtureCount = min(10, teamFixture.count)
        data = Array(0 ..< fixtureCount).map { return teamFixture[$0] }
    }
    catch {
        alertWithCheckButton(title: "데이터를 불러오는데 실패했습니다.",
                             message: "",
                             completion: nil)
    }
```

- Realm Sync를 사용하니 이거에 묶여 있는 것 같다.
- Local Realm만 사용하고 싶은데 partitionValue가 필요해 유저정보를 가져와야한다...
- 이렇게 만든 데이터를 CollectionView Cell에 입힌다!