# DevLog Day 17

## Squad ViewController 최근 경기 결과

- Github 앱 Profile 탭처럼 넘기면서 확인하도록 제작
- Collection View의 paging 기능으로는 한계가 있어 scroll을 이용.

```swift
// Collection View Delegate Method
func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let flowLayout = currentMatchCollectionView.collectionViewLayout as! CurrentMatchCollectionViewFlowLayout
    
    let offset: CGFloat = flowLayout.itemSize.width
    
    let estimatedIndex = scrollView.contentOffset.x / offset
    var index = 0
    
    if velocity.x > 0 {
        index = Int(ceil(estimatedIndex))
    }
    else if velocity.x < 0 {
        index = Int(floor(estimatedIndex))
    }
    else {
        index = Int(round(estimatedIndex))
    }
    
    // 왼쪽에 이전 셀이 살짝 보여야하기 때문에 뒷부분 offset을 더해줘야한다.
    let x = (CGFloat(index) * offset) + (CGFloat(index - 1) * flowLayout.sectionInset.left)
    targetContentOffset.pointee = CGPoint(x: x, y: 0)
}
```