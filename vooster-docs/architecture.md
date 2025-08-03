# Technical Requirements Document (TRD)

## 1. Executive Technical Summary
- **Project Overview**: 경제·투자 초보자를 위한 콘텐츠 통합 커뮤니티를 웹 기반 서비스로 구축합니다. Ruby on Rails 8 모놀리식 아키텍처와 Hotwire 스택을 채택하여 서버 중심의 반응형 UI를 구현함으로써, 빠른 MVP 개발 및 출시를 목표로 합니다.
- **Core Technology Stack**: 백엔드는 Ruby on Rails, 프런트엔드는 Hotwire(Turbo + Stimulus)와 Tailwind CSS를 사용합니다. 데이터베이스는 PostgreSQL, 실시간 통신 및 캐시는 Redis와 Action Cable을 활용하며, 배포는 Render.com의 Docker 컨테이너 환경을 통해 이루어집니다.
- **Key Technical Objectives**: 초기 사용자 5,000명 수용을 목표로 하며, 평균 응답 시간 300ms 이하, LCP(Largest Contentful Paint) 2.5초 이하, 실시간 채팅 메시지 지연 1초 미만을 달성합니다. 모바일 퍼스트 접근 방식을 최우선으로 고려합니다.
- **Critical Technical Assumptions**: Rails 모놀리식 아키텍처는 MVP 단계의 요구사항을 충분히 만족시키고 초기 확장성에 효과적으로 대응할 수 있습니다. Render.com은 안정적인 배포, 관리형 데이터베이스 및 오토스케일링 기능을 제공하여 인프라 운영 부담을 최소화합니다. 개발팀은 Rails 및 Hotwire 생태계에 대한 이해도를 갖추고 있습니다.

## 2. Tech Stack

| Category | Technology / Library | Reasoning (Why it's chosen for this project) |
| --- | --- | --- |
| 백엔드 프레임워크 | Ruby on Rails 8 | 생산성이 높아 MVP를 신속하게 개발하는 데 적합하며, Hotwire와의 네이티브 통합으로 SPA와 유사한 사용자 경험을 효율적으로 구현할 수 있습니다. |
| 프런트엔드 프레임워크 | Hotwire (Turbo + Stimulus) | 서버 사이드 렌더링(SSR)을 통해 복잡한 프런트엔드 상태 관리 없이 동적인 UI를 구축할 수 있어 개발 복잡도를 낮추고 성능 목표(LCP) 달성에 유리합니다. |
| UI 스타일링 | Tailwind CSS | 유틸리티-퍼스트 접근법을 통해 일관성 있는 UI를 빠르게 구축하고, Rails 템플릿 내에서 직접 스타일을 관리하여 개발 효율을 높입니다. |
| 데이터베이스 | PostgreSQL (운영), SQLite (개발) | PostgreSQL은 안정성과 확장성이 검증되었으며, 복잡한 쿼리 및 데이터 타입을 지원하여 향후 기능 확장에 용이합니다. SQLite는 개발 환경 설정이 간편합니다. |
| 실시간 통신 | Action Cable + Redis | Rails에 내장된 Action Cable은 WebSocket 통신을 쉽게 구현하게 해주며, Redis의 Pub/Sub 기능을 활용하여 안정적인 실시간 채팅 기능을 최소한의 노력으로 구축할 수 있습니다. |
| 캐싱 / 백그라운드 작업 | Redis | Action Cable의 백엔드 역할 외에도, 뷰 캐싱(Russian Doll Caching), 데이터 캐싱 및 Active Job의 백엔드로 활용하여 시스템 전반의 성능을 향상시킵니다. |
| 배포 / 호스팅 | Render.com / Docker | Docker를 통해 개발-운영 환경의 일관성을 보장합니다. Render는 Git 푸시 기반의 자동 배포, 관리형 DB/Redis, 오토스케일링을 지원하여 소규모 팀의 인프라 운영 부담을 크게 줄여줍니다. |
| 인증 | OmniAuth (Google, Kakao) | Rails 커뮤니티에서 널리 사용되는 표준 라이브러리로, 소셜 로그인 기능을 안정적이고 안전하게 구현할 수 있습니다. |
## 2.1. Icon System Specification

- **Icon Library**: Tabler Icons (via rails_icons gem)
- **Installation Instructions**: Before using icons, install the library with:
  - `rails generate rails_icons:install --libraries=tabler`
- **Usage in Views**:
  - Use the `icon` helper method (not `rails_icon`) to render icons in Rails views.
  - Example: `<%= icon('tabler:star', style: 'width: 24px; height: 24px;') %>`
- **Icon Set Reference**: All available Tabler icons can be viewed at https://tabler.io/icons .
- **Documentation**: Refer to https://github.com/Rails-Designer/rails_icons for detailed gem usage, customization, and library updates.

**Note:** Ensure the Tabler library is specified during installation. Only the `icon` helper should be used for icon rendering throughout the project.
## 3. System Architecture Design

### Top-Level building blocks
- **Web Application (Ruby on Rails Monolith)**: 모든 비즈니스 로직, API 엔드포인트, 사용자 인터페이스 렌더링을 담당하는 중앙 구성 요소입니다.
  - **Sub-building blocks**: MVC(Model-View-Controller), Action Cable(실시간 통신), Active Record(ORM), Hotwire(Turbo/Stimulus), Active Job(백그라운드 처리)
- **Database (PostgreSQL)**: 사용자 정보, 콘텐츠, 채팅 메시지, 태그 등 모든 영구 데이터를 저장하는 주 데이터 저장소입니다.
- **Cache & Real-time Messaging (Redis)**: Action Cable의 메시지 브로커(Pub/Sub), 애플리케이션 캐시, 백그라운드 작업 큐의 백엔드로 사용되어 시스템 성능과 반응성을 향상시킵니다.
- **Deployment Platform (Render.com)**: Docker 컨테이너로 패키징된 웹 애플리케이션, 데이터베이스, Redis 인스턴스를 호스팅하고 관리합니다. 로드 밸런싱, CI/CD 파이프라인, 스케일링을 담당합니다.

### Top-Level Component Interaction Diagram
```mermaid
graph TD
    subgraph "사용자 브라우저"
        A[Hotwire Frontend]
    end

    subgraph "Render.com Cloud"
        B[웹 서버 (Puma on Docker)]
        C[PostgreSQL 데이터베이스]
        D[Redis]
    end

    A -- HTTP Requests (Turbo Drive/Frames) --> B
    A -- WebSocket (Action Cable) --> B
    B -- CRUD Operations --> C
    B -- Pub/Sub & Caching --> D
```
- 사용자는 브라우저에서 Hotwire로 구현된 프런트엔드와 상호작용합니다.
- 페이지 이동, 폼 제출 등 일반적인 요청은 HTTP를 통해 Render.com에서 실행 중인 Rails 애플리케이션으로 전송됩니다.
- Rails 애플리케이션은 요청을 처리하고, PostgreSQL 데이터베이스에 데이터를 읽거나 쓰며, Redis를 캐싱 및 백그라운드 작업에 활용합니다.
- 실시간 채팅과 같은 기능의 경우, Action Cable을 통해 브라우저와 서버 간에 영구적인 WebSocket 연결이 수립되며, Redis가 메시지 전파(Pub/Sub)를 중개합니다.

### Code Organization & Convention
**Domain-Driven Organization Strategy**
- **Domain Separation**: Rails의 'Convention over Configuration' 원칙에 따라 비즈니스 도메인(예: User, Content, Chat)을 중심으로 모델, 컨트롤러, 뷰를 구성합니다. `app/models/user.rb`, `app/controllers/users_controller.rb`와 같이 리소스 중심으로 파일을 그룹화합니다.
- **Layer-Based Architecture**: Rails의 MVC 패턴은 표현(Views), 비즈니스 로직(Models, Concerns), 데이터 접근(Active Record), 인프라(Initializers) 계층을 자연스럽게 분리합니다.
- **Feature-Based Modules**: 복잡한 기능은 `Concern` 모듈을 활용하여 모델과 컨트롤러의 책임을 분리하고 코드 재사용성을 높입니다.
- **Shared Components**: 여러 도메인에서 공통으로 사용되는 헬퍼, 자바스크립트 컨트롤러, 뷰 파셜(Partial)은 `app/helpers`, `app/javascript/controllers`, `app/views/shared` 등 공유 디렉터리에서 관리합니다.

**Universal File & Folder Structure**
```
/
├── app/
│   ├── assets/
│   ├── channels/          # Action Cable (실시간 채팅)
│   ├── controllers/       # HTTP 요청 처리
│   │   └── concerns/
│   ├── javascript/        # Stimulus 컨트롤러
│   │   └── controllers/
│   ├── jobs/              # 백그라운드 작업 (Active Job)
│   ├── models/            # 비즈니스 로직 및 DB 매핑 (Active Record)
│   │   └── concerns/
│   └── views/             # 템플릿 (ERB & Turbo Frames/Streams)
│       ├── layouts/
│       └── contents/
├── config/
│   ├── initializers/
│   └── routes.rb          # URL 라우팅
├── db/
│   └── migrate/           # 데이터베이스 스키마 마이그레이션
├── lib/
├── public/
├── test/                  # 자동화 테스트
├── Gemfile                # 의존성 관리
└── Dockerfile             # 컨테이너화 설정
```

### Data Flow & Communication Patterns
- **Client-Server Communication**: Hotwire를 통해 서버 중심의 통신이 이루어집니다. Turbo Drive가 전체 페이지 로딩 없이 내비게이션을 처리하고, Turbo Frames와 Turbo Streams가 서버에서 푸시된 HTML 조각으로 UI를 동적으로 업데이트합니다.
- **Database Interaction**: 모든 데이터베이스 상호작용은 Active Record ORM을 통해 수행됩니다. N+1 문제를 방지하기 위해 `includes`를 적극적으로 사용하고, 복잡한 쿼리는 모델의 `scope`으로 캡슐화합니다.
- **External Service Integration**: Google, Kakao 소셜 로그인은 `OmniAuth` 라이브러리를 통해 표준 OAuth 2.0 플로우를 따릅니다.
- **Real-time Communication**: Action Cable을 사용하여 클라이언트(브라우저)와 서버 간 WebSocket 연결을 맺습니다. 서버의 채널은 Redis Pub/Sub을 통해 특정 클라이언트 그룹에 메시지를 브로드캐스팅합니다.
- **Data Synchronization**: 모놀리식 아키텍처이므로 데이터 동기화 문제는 거의 발생하지 않습니다. 데이터 일관성은 PostgreSQL의 트랜잭션을 통해 보장됩니다.

## 4. Performance & Optimization Strategy
- **데이터베이스 최적화**: 개발 환경에서 `bullet` 젬을 사용하여 N+1 쿼리를 감지하고 수정합니다. 외래 키, 태그, 검색 필드 등 자주 조회되는 컬럼에 데이터베이스 인덱스를 추가하여 쿼리 성능을 향상시킵니다.
- **프런트엔드 성능 최적화**: Hotwire를 최대한 활용하여 JavaScript 페이로드를 최소화합니다. 전체 페이지 새로고침 대신 Turbo Frames/Streams를 사용하여 UI를 부분적으로 업데이트합니다. 이미지를 최적화하고 Render.com에서 기본 제공하는 CDN을 통해 정적 에셋을 서빙합니다.
- **캐싱 전략**: 자주 변경되지 않는 UI 조각에 대해 Russian Doll Caching을 적용하여 뷰 렌더링 속도를 높입니다. 무거운 쿼리 결과나 계산된 데이터는 Redis를 이용한 저수준 캐싱을 활용합니다.
- **백그라운드 작업 활용**: 뉴스레터 발송, 썸네일 생성 등 시간이 오래 걸리는 작업은 Active Job과 Redis 기반의 백그라운드 처리 시스템(예: Sidekiq)을 통해 비동기적으로 처리하여 웹 요청의 응답 시간을 단축합니다.

## 5. Implementation Roadmap & Milestones
### Phase 1: Foundation (MVP Implementation)
- **Core Infrastructure**: Rails 8, PostgreSQL, Redis를 포함한 Render.com 개발/운영 환경 설정. CI/CD 파이프라인 구축.
- **Essential Features**: 소셜 로그인(OAuth) 기반 회원 인증, 콘텐츠(컬럼, 영상) CRUD, 태그 기반 피드, Action Cable을 이용한 실시간 채팅방, 북마크/좋아요 기능 구현.
- **Basic Security**: HTTPS 강제, CSRF 보호, 기본 보안 헤더 설정.
- **Development Setup**: Docker 기반의 로컬 개발 환경 통일.
- **Timeline**: 4개월 (베타 오픈 및 피드백 수집까지)

### Phase 2: Feature Enhancement
- **Advanced Features**: 관리자 대시보드(콘텐츠/회원 관리), 고급 검색 및 필터, 알림 센터(새 댓글, 답글) 기능 개발.
- **Performance Optimization**: 실제 사용자 데이터 기반으로 데이터베이스 인덱스 튜닝 및 캐싱 전략 고도화.
- **Enhanced Security**: 콘텐츠 신고/차단 기능, 스팸 필터링, 주요 API에 대한 Rate Limiting 적용.
- **Monitoring Implementation**: Render의 내장 모니터링 외에 Skylight, New Relic 등 APM(Application Performance Monitoring) 도구 연동.
- **Timeline**: 정식 런칭 후 지속적으로 진행

## 6. Risk Assessment & Mitigation Strategies
### Technical Risk Analysis
- **Technology Risks**: 팀의 Hotwire 스택 숙련도 부족.
  - **Mitigation Strategies**: 공식 문서 및 튜토리얼을 활용한 학습, 페어 프로그래밍 도입, 간단한 기능부터 점진적으로 적용하며 경험 축적.
- **Performance Risks**: 실시간 채팅 트래픽 급증으로 인한 서버 부하.
  - **Mitigation Strategies**: Render.com의 오토스케일링 기능을 활용하여 웹 서버(dyno) 증설 준비. 필요시 Redis 플랜을 업그레이드하고, Action Cable의 Connection Pool 설정을 최적화.
- **Security Risks**: OAuth 구현 취약점 또는 서드파티 라이브러리 보안 문제.
  - **Mitigation Strategies**: `omniauth` 등 커뮤니티에서 검증된 표준 라이브러리를 사용하고, 보안 권장 사항을 철저히 준수. 정기적인 의존성 보안 스캔(예: `bundle-audit`) 수행.
- **Integration Risks**: Google/Kakao 등 외부 인증 서비스의 장애.
  - **Mitigation Strategies**: 특정 인증 제공자 장애 시 사용자에게 명확한 오류 메시지를 안내하고, 다른 로그인 옵션을 시도하도록 유도하는 등 우아한 실패(Graceful Degradation) 처리 로직 구현.

### Project Delivery Risks
- **Timeline Risks**: 실시간 채팅 또는 개인화 피드 기능의 구현 복잡도 과소평가.
  - **Mitigation Strategies**: MVP 단계에서는 가장 기본적인 채팅(단일 채널, 텍스트 전용) 및 피드(태그 기반) 기능에 집중하고, 이후 피드백을 통해 점진적으로 고도화.
- **Resource Risks**: 모놀리식 구조에서 특정 개발자에게 업무가 집중되는 병목 현상.
  - **Mitigation Strategies**: 코드의 모듈성(Concerns, Service Objects)을 높이고, 명확한 코드 컨벤션을 준수하여 가독성을 향상. 코드 리뷰 및 문서화를 통해 팀 전체의 코드 이해도를 높임.
- **Quality Risks**: 빠른 개발 속도로 인한 기술 부채 누적.
  - **Mitigation Strategies**: RSpec/Minitest를 이용한 자동화 테스트 커버리지 확보. 주기적인 리팩토링 시간을 별도로 할당하고, 정적 코드 분석 도구(예: RuboCop)를 CI에 통합.
- **Deployment Risks**: Render.com 배포 환경 설정 오류 또는 장애.
  - **Mitigation Strategies**: 운영(Production)과 동일한 스테이징(Staging) 환경을 구축하여 배포 전 충분한 테스트를 수행. 주요 배포 절차를 문서화하고 자동화 스크립트를 활용.