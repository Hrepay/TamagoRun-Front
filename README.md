# TamagoRun (타마고런)

> **"캐릭터와 함께 달리며 성장하는 러닝 어플리케이션"**

<img width="1557" height="558" alt="모야" src="https://github.com/user-attachments/assets/4ecaac77-a86f-4d0d-9217-6f07f1982660" />

## 📖 프로젝트 소개

### **TamagoRun**은 2030 세대의 러닝 트렌드에 맞춰, 단순한 기록 측정을 넘어 **캐릭터 육성**이라는 게임적 요소를 더한 러닝 애플리케이션입니다. 사용자의 러닝 기록(거리, 속도)이 곧 캐릭터의 경험치가 되며, 꾸준한 운동을 통해 캐릭터를 진화시킬 수 있습니다.

-   **개발 기간:** 2024.09 \~ 2024.11
-   **개발 인원:** 4명 (iOS 1, Backend 2, Design 1)
-   **담당 역할:** **Team Leader & iOS Developer** (기여도 100%)

<br>

## 📱 주요 기능 (Main Features)

### 1\. 실시간 러닝 트래킹 & 기록 분석

**"위치 추적으로 나만의 러닝 코스를 기록합니다."**

-   **Naver Maps API 기반 실시간 경로 추적:** `CoreLocation`과 `NMFMapView`를 연동하여 사용자의 이동 경로를 지도 위에 실시간 Polyline으로 시각화합니다.
-   **실시간 주행 데이터 측정:** 러닝 중 이동 거리(km), 실시간 페이스(Pace), 소모 칼로리(kcal)를 3초 단위로 계산하여 직관적인 UI로 제공합니다.
-   **상세 통계 대시보드:** 러닝 종료 후 일별, 주별, 월별 데이터를 그래프로 시각화하여 사용자가 자신의 성장 추이를 한눈에 파악할 수 있도록 구현했습니다.

<br>

### 2\. 러닝 데이터 기반 캐릭터 육성

**"내가 달린 거리만큼 캐릭터도 함께 성장합니다."**

-   **Distance to XP 시스템:** 사용자의 누적 러닝 거리가 곧 캐릭터의 경험치(EXP)가 되는 로직을 적용하여 운동에 대한 확실한 보상 체계를 마련했습니다.
-   **3단계 진화 시스템:** 알(Egg)에서 시작하여 총 3단계 진화 과정을 통해 지속적인 러닝 동기를 부여합니다.
-   **다양한 종족과 직업:** 크리처(Creature), 언데드(Undead), 인간(Human) 등 3가지 종족과 각 종족별 3가지 직업군을 픽셀 아트로 구현하여 수집의 재미를 더했습니다.

<br>

### 3\. 동기 부여를 위한 미션 및 소셜 네트워크

**"혼자 달리지 않고 친구와 함께 경쟁하며 즐깁니다."**

-   **일일/주간 미션 & 업적:** '하루 3km 뛰기', '5000보 달성' 등 다양한 기간별 미션을 제공하고, 달성 시 캐릭터 성장에 필요한 보상을 지급하여 앱 재방문율(Retention)을 높였습니다.
-   **친구 추가 및 랭킹 시스템:** 닉네임을 통해 친구를 추가하고 서로의 러닝 기록(총 거리, 페이스 등)을 비교할 수 있는 기능을 통해 건강한 경쟁 심리를 자극합니다.
-   **캘린더 기반 기록 관리:** 캘린더 뷰를 커스텀하여 날짜별 운동 여부와 미션 달성 현황을 직관적으로 관리할 수 있습니다.

<br>

## 🛠 기술 스택 (Tech Stack)

### iOS

-   **Framework:** SwiftUI, UIKit (Naver Map 연동)
-   **Architecture:** MVVM
-   **Network:** URLSession
-   **Local Data:** Keychain, HealthKit
-   **3rd Party:** Naver Maps SDK

### Backend & Infra

-   **Server:** Spring Boot, MySQL
-   **Infra:** AWS EC2, Redis

<br>

## 🏗 아키텍처 및 폴더 구조 (Architecture)

유지보수성과 데이터 바인딩의 효율성을 위해 **MVVM 패턴**을 적용했습니다. View와 Business Logic을 분리하여 UI 업데이트 흐름을 단순화했습니다.

```
TamagoRun
├── App
│   ├── TamagoRunApp.swift
├── Model          # 데이터 구조 및 엔티티 정의
├── View           # SwiftUI 기반의 UI 구성
│   ├── Main
│   ├── Running
│   ├── Record
│   └── ...
├── ViewModel      # 비즈니스 로직 및 State 관리 (ObservableObject)
├── Service        # 네트워크 통신 (URLSession) 및 Location Manager
├── Helper         # Extension, Constants, Custom Modifiers
└── Resources      # Assets, Fonts
```

<br>

## 🎨 UI/UX Design

-   다마고치의 레트로한 감성을 살리기 위해 전체 UI 컴포넌트와 캐릭터를 Pixel 스타일로 UI를 구성하고 [Dottable](https://apps.apple.com/kr/app/pixel-art-editor-dottable/id946923840)와 [Pixelable](https://apps.apple.com/kr/app/pixelable-pixel-art-editor/id1185772796) 을 사용하여 직접 캐릭터를 디자인하였습니다.

-   ### 앱 디자인
    <img width="256" height="258" alt="ㅇㄹㅇ" src="https://github.com/user-attachments/assets/b27cbd4a-a0ce-4c88-a3a6-633fe27a485a" />

    <img width="910" height="450" alt="타마고런₩" src="https://github.com/user-attachments/assets/88df2116-9271-437f-bfa0-533325c2e396" />

    <img width="682" height="453" alt="타마고런2" src="https://github.com/user-attachments/assets/4979b584-5664-49d8-ba5a-4a0135ae87ee" />

-   ### 캐릭터 디자인

    ![크리쳐](https://github.com/user-attachments/assets/554a6ac7-8f34-48a5-a87d-b3b9a036b440)
    ![휴먼](https://github.com/user-attachments/assets/f2ebe17a-c3c1-4c7e-8cb3-b1f1e42b28e3)
    ![언데드](https://github.com/user-attachments/assets/df75286f-5ea1-48eb-97fb-50bba70b68dc)



### 추가 자료

- 영상과 포스터, 발표자료가 궁금하시다면 아래 링크를 클릭해주세요! <br>
[TamagoRun 발표자료 및 시연 영상 보러가기](https://useful-distance-712.notion.site/TAMGORUN-65c6e63d6b31484c9978ac20f57871f0)
