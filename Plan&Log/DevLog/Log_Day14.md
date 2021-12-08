# DevLog Day14

## Crashlytics
- Google Crashlytics를 프로젝트에 넣었다.
- 지금은 에러 핸들링이 최우선 과제이기 때문이다.
- 이번주는 최대한 에러만 잡으려고 한다.

## Football API Error
- 첫번째부터 난관이다
- Football API Error는 timeout, server error 두개만 날라온다.
- Call Limit은 상태코드 200으로 날라온다.
- 어이가없어가지고
- 그래서 각 API 호출시에 errors의 requests가 비어있는지 확인해야한다.
- 이거로 에러는 잡지만 에러가 없을때 정상작동하는지는 다시 확인해야한다.
- 이거로 막히면 errors보단 results로 결과 개수를 이용해 에러를 판단할 예정.

## Refactor BasicTabVC
- 첫뷰에서 리그를 변경하고 다른 탭으로 가면 data fetch를 두번한다.
- viewDidLoad에서 한번. viewDidAppear에서 league에 PublicProperty의 league가 들어오면서 두번.
- 이걸 막기 위해서 loadView에서 league에 PublicProperty의 league를 넣어주고  
  각 VC에 viewDidLoad에 datafetch 과정을 뺐다.
- 이중호출을 막고 viewDidAppear의 기능을 살리게 됐다.

- BasicTabVC에 추상메서드같이 fetchData 메서드를 만들고 각 뷰에서 override 하는 방식으로 바꿨다.
- BasicTabVC의 league didSet에서 data fetch를 진행하며, 각 뷰에서 league는 빠졌다.
