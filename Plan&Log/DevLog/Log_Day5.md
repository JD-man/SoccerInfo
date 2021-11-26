# SoccerInfo DevLog Day5

## 뉴스탭 뷰 제작
- 공수산정 시간: 2시간
- 제작시간 : 6시간
- 초과이유 : 원래 기획은 이미지와 기사 컨텐츠가 가로로 나열됐지만 제작시 세로로 나열하게 시도
- 하지만 개발기간이 원래 기획보다 2일 빠르므로 시간을 조금 더 잡아서 시도했다.

## 세로나열로 시도한 이유
1. 네이버 검색 뉴스 API Response에 썸네일 이미지가 없음
2. 이미지 없는 뉴스탭으로 가던가 뉴스탭을 버리던가 고민
3. 네이버 검색 이미지 API가 있는걸 발견하고 받아온 뉴스 타이틀로 이미지 검색 시도
4. 뉴스가 검색되고 이미지를 받아오는데 성공
5. 하지만 호출시간, 콜수제한 등 제약을 고려해 가져온 뉴스 전부 이미지를 가져오지는 않음
6. 가로 배열일때는 중간중간 썸네일이 없는게 이상할거 같아서 세로 배열로 시도

## 가로 배열로 다시 돌아감
- 세로 배열시 오토레이아웃 경고가 나거나 셀의 높이가 원하는대로 안나왔음
- 다른 프로젝트를 만들어 여러가지 실험을 해보고 다시 적용해보기로 결정

## 뉴스의 이미지를 가져오기 위한 DispatchGroup
- 이미지를 가져오는것도 하나의 request이고 비동기 처리이므로 이미지 받아오기 작업이 끝나는 시점을 알아야했음
```swift
    let group = DispatchGroup()
        fetchAPIData(of: .newsSearch, url: url) { [weak self] (result: SearchResponse) in
            switch result {
            case .success(let newsResponse):
                self?.totalPage = min(self!.totalPage, 100)
                var items = newsResponse.items
                
                // ...
                
                for i in randomIndex {
                    group.enter()
                    print("enter")

                    // ...

                    self?.fetchAPIData(of: .newsImage, url: url) { (result: SearchResponse) in
                        switch result {
                        case .success(let newsResponse):
                            if newsResponse.items.isEmpty == false {
                                items[i].imageURL = newsResponse.items[0].link
                            }
                            group.leave()
                        case .failure(let error):
                            print(error)
                        }
                    }
                }                
                group.notify(queue: .main, execute: {
                    self?.data = items
                })
            // ...
            }
        }
    }
```