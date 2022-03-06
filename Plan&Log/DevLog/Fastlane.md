# Fastlane 적용기

## 설치
### 1. Xcode command line tools 설치
```
xcode-select --install
```

### 2. Fastlane 설치
- macOS system Ruby를 사용하는 방법은 비추
- bundler 또는 Homebrew 사용 권장

#### Homebrew로 사용
```
brew install fastlane
```

### 3. Fastlane 시작
- 프로젝트로 디렉토리로 가서 fastlane init
- 1,2,3,4번 중에 선택하라는게 나오는데 테스트플라이트를 우선으로 할 예정이라 2번선택
- Apple ID와 비밀번호 2중인증까지 입력하고 설치완료
- 계정이 안전한게 맞나 관련해서 스트레스가 좀 있었음...

### 4. Testflight 배포하기
- 설치시에 2번으로해서 그런지 beta 실행에 대한 기본이 이미 설정됐음
- 첫번째 시도에선 앱암호를 입력했어야 했다. 다행히 아무 이상없이 테스트 플라이트로 바로 올라감.

### 5. .env, Appfile 설정
- 매번 앱암호를 입력할 수 없으므로 .env를 만들어 환경변수를 설정해줬다.
- 환경변수 설정하면서 Appfile도 모두 환경변수 값을 사용하도록 변경했다.

```swift
// .env
// xcode 프로젝트 identifier
APP_IDENTIFIER
// 개발자 계정
APPLE_ID
// App Store Connect Team ID Appfile 생성시 알 수 있다.
ITC_TEAM_ID
// 개발자 계정 Team ID
TEAM_ID
// 애플 계정에서 설정하는 앱암호
FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD

// Appfile
app_identifier(ENV["APP_IDENTIFIER"])
apple_id(ENV["APPLE_ID"])
itc_team_id(ENV["ITC_TEAM_ID"])
team_id(ENV["TEAM_ID"])
```

### 6. 테스트플라이트 테스트 내용 적어보내기

```ruby
desc "Push a new beta build to TestFlight"
lane :beta_update do
  ensure_git_status_clean
  increment_build_number(   
    build_number: latest_testflight_build_number + 1,  
    xcodeproj: "SoccerInfo.xcodeproj"
  )
  changelog = prompt(
    text: "Changelog: ",
    multi_line_end_keyword: "END"
  )
  
  build_app(workspace: "SoccerInfo.xcworkspace", scheme: "SoccerInfo")
  upload_to_testflight(changelog: changelog)
end
```

- changelog를 prompt로 받아 터미널에서 입력하도록 설정
- upload_to_testflight하고나서 (changelog: changelog)를 해줘야 테스트 내용이 업로드된다.

```ruby
desc "Push a new beta version & build to TestFlight"
lane :beta_new_version do
  ensure_git_status_clean
  
  increment_build_number(
    build_number: 1,
    xcodeproj: "SoccerInfo.xcodeproj"
  )
  changelog = prompt(
    text: "Changelog: ",
    multi_line_end_keyword: "END"
  )
  
  build_app(workspace: "SoccerInfo.xcworkspace", scheme: "SoccerInfo")
  upload_to_testflight(changelog: changelog)
end
```

- 현재 fastlane이 프로젝트의 버전을 읽는데에 이슈가 있는듯.
- 그래서 같은 버전에서의 업데이트와 새로운 버전의 빌드번호가 다르게 설정되도록 따로 만들었다.

---