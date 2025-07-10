# Salesforce CRM 실전 프로젝트

## 📅 프로젝트 기간

2024년 6월 13일 ~ 2024년 7월 31일

---

## 📌 프로젝트 개요

이 프로젝트는 **Salesforce CRM**을 활용하여  
**Web-to-Lead**, **Web-to-Case**, 그리고 **LWC (Lightning Web Components)** 개발 및 배포까지 실습하는 **세일즈포스 CRM 실전 프로젝트**입니다.

고객 문의 접수 및 관리 자동화와 Salesforce 플랫폼 내 컴포넌트 활용 방법을 익히기 위한 목적의 프로젝트입니다.

---

## 📁 폴더 구조 및 역할

├── webtolead
│ └── Salesforce Web-to-Lead용 HTML 폼
│
├── webtocase
│ └── Salesforce Web-to-Case용 HTML 폼
│
└── common
└── Salesforce DX (SFDX)로 생성한 LWC 프로젝트 (Lightning Web Components 소스)

yaml
복사
편집

### 📂 webtolead

- 고객이 직접 리드(Lead)를 생성할 수 있는 HTML 폼
- Salesforce Web-to-Lead 기능과 연동

### 📂 webtocase

- 고객이 직접 케이스(Case)를 생성할 수 있는 HTML 폼
- Salesforce Web-to-Case 기능과 연동

### 📂 common

- `sfdx force:project:create` 명령어로 생성한 Salesforce DX 프로젝트
- Lightning Web Components (LWC) 개발 및 Salesforce Org 배포용
- Apex 클래스, LWC 컴포넌트, 메타데이터 포함

---

## ⚙️ 개발 및 배포 환경

| 구분         | 사용 기술/환경                            |
| ------------ | ----------------------------------------- |
| CRM          | Salesforce Sales Cloud                    |
| 웹 호스팅    | Vercel (정적 HTML 파일 배포)              |
| 개발 도구    | Salesforce CLI (SFDX), Visual Studio Code |
| 프론트엔드   | HTML, CSS, JavaScript                     |
| 백엔드 (Org) | Apex, Lightning Web Components (LWC)      |

---

## 🚀 사용 방법 (요약)

1. **웹 폼 (webtolead, webtocase)**

   - HTML 파일 내 `action` 속성에 Salesforce에서 발급받은 Web-to-Lead 또는 Web-to-Case URL 입력
   - Vercel 등 정적 사이트 호스팅 서비스에 배포

2. **LWC 컴포넌트 (common)**
   - Salesforce DX 프로젝트 (`common`)을 Org에 배포 (`sfdx force:source:deploy`)
   - Lightning App Builder 또는 Experience Cloud 사이트에 컴포넌트 추가

---

## 📌 주의사항

- Web-to-Lead 및 Web-to-Case는 Salesforce 퍼블릭 사이트 권한 설정이 필요합니다.
- LWC 컴포넌트는 Salesforce 내부에서만 작동합니다 (Experience Cloud, Lightning Pages 등).
- Salesforce Org에 배포 시 API 버전 및 권한 설정 확인이 필요합니다.

---

## ✏️ 프로젝트 목표

✅ Salesforce Web-to-Lead & Web-to-Case 자동화 이해  
✅ Lightning Web Components (LWC) 개발 및 배포  
✅ 고객 문의/상담 프로세스의 자동화 구현  
✅ Salesforce CRM 실무 적용 경험 축적

---
