[야곰의 IOS 프로그래밍](https://www.inflearn.com/course/ios-프로그래밍#) 강좌를 수강하면서 생성한 프로젝트 저장소.


# 1. MyWebBrowser
웹 브라우저 어플리케이션 구현을 따라하면서 Xcode와 IOS 개발 환경에 친숙해지기.

### 구현 기능
- WKWebView를 통해 웹 페이지 보여주기
- 뒤로 가기, 앞으로 가기, 새로고침 버튼
- 마지막 페이지 저장 (다시 실행시 로드)

### 고민했던 부분
- 뒤로 가기, 앞으로 가기, 새로 고침 등 기존의 동작이 종료되기 전 새로운 동작 요청 발생 시 오류와 함께 어플이 종료됨.
  => 각 동작 실행에 맞추어 뒤로 가기, 앞으로 가기, 새로고침 버튼 활성화/비활성화

