# iOS 커리어 스타터 캠프 - 날씨정보 프로젝트 저장소

## Jacob의 그라운드 룰

- 저녁 9시에는 하던 작업 마무리하고 10시까지 TIL 정리하고 끝내기
- 휴일(수,토,일) 에는 쉬거나 이전 작업내용을 다시 돌아보기
    - 새로운 작업은 하지말고 리패토링 위주로
- 프로젝트 기능요구서에 충실하기
    - 기능요구서 내용을 충실하게 먼저 완료하기
    - 이후 시간이 남으면 추가 구현

## 프로젝트 규칙

### 코딩 컨벤션

- Swift API 디자인 가이드라인을 따르려고 노력하기
- 클래스, 함수, 변수 명을 명확하고 객관적인 이름으로 하기
- 가능한 주석 없이 이해가능한 코드 추구하기

### 브랜치 단위

- 스텝별로 브랜치 만들어서 작업하기 (ex: "step-1", "step-2")
- 각 스텝의 기능단위로 하위 브랜치 만들고 완료되면 스텝 브랜치로 머지
- 스텝완료되면 브랜치를 원본 저장소로 PR 보내고 코드 리뷰 받기

### 커밋 메시지

- 한글로 작성하기 (단, 제목의 Type은 영문으로 작성)
- Title
    - Type과 이슈번호 붙이기
    - 양식: Type #이슈번호 - 내용  
    - 예시: Feat #1 - 버튼 기능 추가  
    - Type 리스트
        - Feat: 코드, 새로운 기능 추가
        - Fix: 버그 수정
        - Docs: 문서 수정
        - Style: 코드 스타일 변경 (기능, 로직 변경 x)
        - Test: 테스트 관련
        - Refactor: 코드 리팩토링
        - Chore: 이외 기타 작업
- Description
    - Title은 간단하게 Description은 상세하게
    - Title만으로 설명이 충분하면 Description은 없어도 됨
    - Title에서 한칸 빈칸을 띄우고 작성

### GitHub의 프로젝트 관리기능 사용해보기

- 이슈와 프로젝트 기능 활용
    - 작업 시작전에 이슈 꼭 등록하고 커밋메세지에 이슈번호 포함!
- [github 하나로 1인 개발 워크플로우 완성하기: 이론편](https://www.huskyhoochu.com/issue-based-version-control-101)
- [github 하나로 1인 개발 워크플로우 완성하기: 실전 편](https://www.huskyhoochu.com/issue-based-version-control-201/#open-issue)
- [좋은 git 커밋 메시지를 작성하기 위한 8가지 약속](https://djkeh.github.io/articles/How-to-write-a-git-commit-message-kor/)
