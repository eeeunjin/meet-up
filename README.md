# Growith 🌱
**오프라인 만남을 통한 자기 성장 서비스**

> 광운대학교 졸업작품 | 2024.02 ~ 2024.10

<br>

## 📌 프로젝트 소개

Growith은 오프라인 만남을 주선하고, 만남 이후 성찰 일기를 작성하며 자기 성장을 기록할 수 있는 모바일 앱 서비스입니다.
기존 오프라인 만남 앱의 단점을 개선하고, 성찰·등급·결제 시스템을 더해 차별화된 경험을 제공합니다.

<br>

## 👥 팀 구성

| 역할 | 인원 |
|------|------|
| Frontend (Flutter) | 2명 |
| Backend (Firebase) | 1명 |

<br>

## 🛠 기술 스택

**Frontend**
- Flutter / Dart
- Android (Kotlin), iOS (Swift)

**Backend / Infra**
- Firebase Firestore
- Firebase Authentication (전화번호 인증)
- Firebase Cloud Functions

**Architecture**
- MVVM (Model - View - ViewModel)

**협업**
- GitHub / Git

<br>

## 📐 아키텍처 (MVVM)

```
View  ──요청──▶  ViewModel  ──요청──▶  Model (Service)
  ◀──업데이트──           ◀──결과 전달──
```

- **View** : UI 구성 코드. 각 View는 해당 ViewModel에 바인딩
- **ViewModel** : View의 요청을 처리하고, Repository를 통해 비즈니스 로직 호출 후 상태 업데이트
- **Model (Service)** : Server, DB, 외부 API의 CRUD 및 통신 함수 구성

<br>

## ✨ 주요 기능

### 1. 만남 방 개설 / 참여
- 카테고리(관심사), 지역, 키워드, 나이대, 남녀 성비, 세부 규칙 등을 설정하여 모임 방 개설
- 원하는 주제와 지역의 모임 방을 검색하고 참여

### 2. 채팅
- 참여 중인 방의 채팅 목록 확인 및 채팅 내역 조회
- 방 세부 정보(규칙, 카테고리, 참여자) 확인
- 모임 일시·장소 공유 및 참석 여부 결정

### 3. 성찰 (일기)
- 만남 이후 일기를 작성하여 경험 기록
- 특정 질문에 답변하고 별점으로 모임 평가

### 4. 결제 시스템
- In-App Purchase를 통한 코인 / 만남권 구매
- 코인으로 방 개설·참여 등 추가 기능 이용

### 5. 등급 시스템
- 꾸준한 일기 작성 및 상호 평가를 통해 등급 점수 획득
- 등급별 차별화된 혜택 제공

### 6. 전화번호 인증
- Firebase Authentication을 활용한 회원가입 / 로그인 시 전화번호 본인 인증

<br>

## 📁 프로젝트 구조

```
lib/
├── model/          # DB 데이터 구조 모델
├── repository/     # 비즈니스 로직
├── service/        # 서버·DB·API 통신 함수
├── view/           # UI 화면
├── view_model/     # 상태 관리 및 요청 처리
└── util/           # 공통 유틸리티
```
