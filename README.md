[야곰의 IOS 프로그래밍](https://www.inflearn.com/course/ios-프로그래밍#) 강좌를 수강하면서 생성한 프로젝트 저장소.



# 개발 환경

- OS 버전 : *작성 예정*
- Xcode 버전 : *작성 예정*
- Swift 버전 : *작성 예정*



# 1. MyWebBrowser

웹 브라우저 어플리케이션 구현을 따라하면서 Xcode와 IOS 개발 환경에 친숙해지기.

### 구현 기능

- 웹 페이지 보여주기 (WKWebView)
- 뒤로 가기, 앞으로 가기, 새로고침 버튼 (UIBarButtonItem)
- 페이지 로딩 화면 보여주기 (UIActivityIndicatorView)
- 마지막 페이지 저장 (UserDefaults)

### 고민했던 부분

- 뒤로 가기, 앞으로 가기, 새로 고침 등 기존의 동작이 종료되기 전 새로운 동작 요청 발생 시 오류와 함께 어플이 종료됨.

  **Sol) 각 동작 실행에 맞추어 버튼 활성화/비활성화 (UIBarButtonItem.isEnabled)**



# 2. MyProfile

프로필을 보여주는 화면을 구성하면서 Auto Layout 사용해보기

### 구현 기능

N/A

### 고민했던 부분

N/A



# 3. MyUpDown

문제의 숫자를 맞추는 게임 구현.

### 구현 기능

- View를 컨트롤 하여 UpDown 게임 구현 (IBOutlet, IBAction)
- 배경 터치 시 키보기 사라지게 하기 (UITapGestureRecognizer)

### 고민했던 부분

N/A



# 4. MyColorPicker

Picker view와 Slider View를 사용하여 색을 선택하는 어플리케이션.

### 구현 기능

- tag를 이용하여 View 구분 (UISlider.tag, view.viewWithTag)
- Picker View를 이용하여 Color Picker 구현 (UIPickerViewDelegate)

### 고민했던 부분

N/A



# 5. MyCompanionAnimals

반려동물을 소개 하는 어플리케이션.

### 구현 기능

- 반려동물 선택 시 소개 화면으로 이동 (View Trasition, Navigation, prepare for segue)
- 반려동물 정보 불러오기 (Asset Catalog, Property List, Codable)
- 반려동물 정보 모델 구현 (MVC)

### 고민했던 부분

N/A



# 6. MyLoginFlow

로그인 어플리케이션.

### 구현 기능

- 로그인 시 화면 전환하여 ID/Password 정보 출력 (prepare for segue)
- Password 제약사항에 따라 로그인을 제한하고 사용자에게 알리기 (UIAlertController)
- 어플리케이션 및 뷰 컨트롤러 수명주기 로그

### 고민했던 부분

- 어플리케이션 수명주기 로그가 출력되지 않음

  **Sol)iOS13 이후 어플리케이션의 수명주기는 App Delegate가 아닌 Scene Delegate로 관리됨**

  (참고 : [[iOS\] AppDelegate와 SceneDelegate - Velog](https://velog.io/@dev-lena/iOS-AppDelegate와-SceneDelegate))

  

# 7. MyDISCTest

DISC 성격 유형 테스트.

### 구현 기능

- 마지막 사용자의 이름 저장 및 불러오기 (UserDefaults)
- 이름을 입력하지 않고 테스트 시작 시 텍스트필드로 커서 이동 (becomeFirstResponder)
- 사용자 및 질문 선택 결과 저장 (Singleton Programming Design Pattern, static let shared)
- 질문화면에서 뒤로 가기 시 응답 무효 처리 (이전 뷰에서 선택된 응답 정보르 다음 뷰의 컨트롤러에 저장 후 뒤로 가기 시 선택 무효 반영)
- 질문 불러오기 (JSONEncoder / JSONDecoder)
- 사용자 설정에 따라 폰트 사이즈 자동 변경 (Dynamic Type)

### 고민했던 부분

N/A



# 8. MyTodos

할 일을 테이블 형태로 관리

### 구현 기능

- 할 일을 테이블 형태로 관리 (UITableViewDataSource, UITableViewDelegate, dequeueReusableCell)
- 할 일 : 제목, 내용, 날짜, 시간 저장 (UIDatePicker)
- 할 일 시간에 맞추어 알림 (UNNotification)
- 할 일 추가, 삭제, 편집 (UIBarButtonItem)

### 고민했던 부분

- 앱이 켜져있을 때에는 알림이 오지 않음

  **Sol)userNotificationCenter willPresent 메소드 이용**
  
  (참고 : [Displaying a stock iOS notification banner when your app is open and in the foreground?](https://stackoverflow.com/questions/30852870/displaying-a-stock-ios-notification-banner-when-your-app-is-open-and-in-the-fore))



# 9. FoodTracker

*작성 예정*



# 10. MyFriends

*작성 예정*



# 11. 사진 필터 앱

*작성 예정*
