# EconoTalk Real - UI 스타일 가이드

## 개요

EconoTalk Real은 경제·투자 초보자를 위한 통합 경제 콘텐츠 커뮤니티입니다. 이 스타일 가이드는 일관된 UI/UX를 위한 디자인 원칙, 컴포넌트 사용법, 그리고 개발 가이드라인을 제공합니다.

## 🎯 핵심 원칙

### 1. 스타일링 원칙
- **모든 UI 컴포넌트는 Tailwind CSS를 사용하여 shadcn 스타일을 지향하여 구현한다.**
- 반응형 디자인 (Mobile-first approach) 적용
- 접근성 (WCAG 2.1 AA) 준수
- 일관된 시각적 계층 구조 유지

### 2. 아이콘 원칙
- **아이콘은 `rails_icons` 젬의 `icon` 헬퍼만을 사용하여 Tabler Icons 세트에서 가져온다.**
- **SVG 직접 사용은 금지한다.**
- 아이콘 크기와 스타일의 일관성 유지

### 3. 컴포넌트 원칙
- 재사용 가능한 컴포넌트 우선 설계
- Props를 통한 유연한 사용법 지원
- 명확한 사용법 문서화

---

## 🎨 디자인 토큰

### 컬러 팔레트

현재 프로젝트에서 사용 중인 주요 컬러들:

```scss
// Primary Colors
--primary-blue: #0052CC;        // 브랜드 메인 컬러 (버튼, 링크, 포커스)
--accent-green: #1EC7A6;        // 강조 컬러 (태그, 액션)

// Text Colors  
--text-primary: #1A202C;        // 제목, 메인 텍스트
--text-secondary: #718096;      // 보조 텍스트, 설명, 아이콘
--text-muted: #A0AEC0;          // 비활성 텍스트

// Background & Surface
--background: #FFFFFF;          // 메인 배경
--surface-light: #F5F7FA;       // 플레이스홀더, 카드 배경
--surface-hover: #EDF2F7;       // 호버 상태

// Border & Divider
--border-light: #E2E8F0;        // 경계선, 구분선
--border-focus: #0052CC;        // 포커스 링, 선택 상태
```

### 타이포그래피

- **Font Family**: 시스템 폰트 스택 사용
- **Font Weights**: 400 (Regular), 600 (Semibold), 700 (Bold)
- **Letter Spacing**: 제목에 음수 letter-spacing 적용 (-0.015em ~ -0.02em)

### 간격 시스템

Tailwind CSS 기본 간격 시스템 사용:
- `space-x-1` (4px), `space-x-2` (8px), `space-x-3` (12px), `space-x-4` (16px)
- `gap-2` (8px), `gap-4` (16px), `gap-6` (24px)
- `p-4` (16px), `p-6` (24px), `px-4` (left-right 16px)

---

## 🎪 아이콘 시스템

### 사용법

```erb
<%# 올바른 사용법 %>
<%= icon('star', class: 'w-5 h-5 text-yellow-400') %>
<%= icon('user', class: 'h-4 w-4', style: 'color: #718096') %>
<%= icon('search', class: 'absolute left-2.5 top-2.5 h-4 w-4', style: 'color: #718096') %>

<%# 잘못된 사용법 - 금지 %>
<svg>...</svg>
<i class="icon-star"></i>
```

### 주요 사용 아이콘

| 용도 | 아이콘 이름 | 예시 |
|------|-------------|------|
| 검색 | `search` | `<%= icon('search', class: 'h-4 w-4') %>` |
| 사용자 | `user` | `<%= icon('user', class: 'h-4 w-4') %>` |
| 시간 | `clock` | `<%= icon('clock', class: 'h-4 w-4') %>` |
| 북마크 | `bookmark` | `<%= icon('bookmark', class: 'h-4 w-4') %>` |
| 좋아요 | `heart` | `<%= icon('heart', class: 'h-4 w-4') %>` |
| 공유 | `share` | `<%= icon('share', class: 'h-4 w-4') %>` |
| 영상 | `video`, `player-play` | `<%= icon('video', class: 'h-4 w-4') %>` |
| 뉴스레터 | `mail` | `<%= icon('mail', class: 'h-4 w-4') %>` |
| 아티클 | `article`, `file-text` | `<%= icon('article', class: 'h-4 w-4') %>` |
| 메뉴 | `menu-2` | `<%= icon('menu-2', class: 'h-4 w-4') %>` |
| 브랜드 | `chart-line` | `<%= icon('chart-line', class: 'h-6 w-6') %>` |

### 아이콘 크기 가이드라인

- **Small**: `h-4 w-4` (16px) - 인라인 텍스트, 버튼 내부
- **Medium**: `h-5 w-5` (20px) - 메뉴, 네비게이션
- **Large**: `h-6 w-6` (24px) - 로고, 메인 액션
- **Extra Large**: `h-8 w-8`, `h-12 w-12` - 플레이스홀더, 임팩트

---

## 🧩 재사용 가능한 컴포넌트

### Content Card (`shared/_content_card.html.erb`)

**설명**: 콘텐츠 목록이나 상세 페이지에서 사용되는 메인 카드 UI 컴포넌트

**사용법**:

```erb
<%# Content 객체 사용 (권장) %>
<%= render 'shared/content_card', content: @content %>

<%# 개별 변수 사용 %>
<%= render 'shared/content_card', 
    title: "경제 전망 보고서",
    description: "2025년 경제 동향을 분석한 상세 보고서입니다.",
    author: "김경제",
    published_at: Time.current,
    tags: ["경제전망", "투자전략"],
    content_type: "article" %>
```

**Props**:

| 변수 | 타입 | 필수 | 기본값 | 설명 |
|------|------|------|--------|------|
| `content` | Content | 선택적 | nil | Content 모델 객체 |
| `title` | String | 선택적 | "Sample Title" | 콘텐츠 제목 |
| `description` | String | 선택적 | "Sample description..." | 콘텐츠 설명 |
| `author` | String | 선택적 | "Author Name" | 작성자 이름 |
| `published_at` | Time | 선택적 | Time.current | 발행 시간 |
| `thumbnail_url` | String | 선택적 | nil | 썸네일 URL |
| `tags` | Array | 선택적 | [] | 태그 배열 |
| `content_type` | String | 선택적 | "article" | 콘텐츠 타입 (article, video, newsletter) |
| `url` | String | 선택적 | "#" | 링크 URL |

**특징**:
- 반응형 디자인 (aspect-video 썸네일)
- 호버 효과 (그림자, 스케일 애니메이션)
- 콘텐츠 타입별 아이콘 표시
- 액션 버튼 (북마크, 좋아요, 공유)
- 태그 표시 (최대 3개 + 추가 표시)

---

## 📋 코딩 컨벤션

### HTML/ERB 스타일

1. **클래스 순서**: 레이아웃 → 스타일링 → 인터랙션 → 반응형
   ```erb
   <div class="flex items-center justify-center rounded-md bg-white hover:bg-gray-50 md:hidden">
   ```

2. **인라인 스타일 사용**: 커스텀 컬러는 style 속성 사용
   ```erb
   <span style="color: #718096;">텍스트</span>
   <div style="border-color: #E2E8F0; background-color: #FFFFFF;">
   ```

3. **반응형 클래스**: 모바일 퍼스트 원칙
   ```erb
   <nav class="hidden md:flex items-center space-x-6">
   <button class="md:hidden inline-flex items-center">
   ```

### 컴포넌트 작성 가이드

1. **상단 주석**: 컴포넌트 사용법 명시
   ```erb
   <%# 
     Content Card Component
     Usage: render 'shared/content_card', content: your_content_object
     Or with local variables: render 'shared/content_card', title: "Title", description: "Description", etc.
   %>
   ```

2. **변수 처리**: `local_assigns`를 활용한 유연한 Props 처리
   ```erb
   <%
     content_obj = local_assigns[:content]
     title = local_assigns.fetch(:title, content_obj&.title || "Default Title")
   %>
   ```

3. **조건부 렌더링**: 명확한 조건 분기
   ```erb
   <% if thumbnail_url.present? %>
     <img src="<%= thumbnail_url %>" />
   <% else %>
     <div class="placeholder">
   <% end %>
   ```

---

## ✨ 베스트 프랙티스

### 1. 성능 최적화
- 이미지에 `loading="lazy"` 속성 사용
- 필요한 경우에만 호버 효과 적용
- 불필요한 DOM 깊이 제한

### 2. 접근성
- 적절한 semantic HTML 태그 사용 (`<article>`, `<nav>`, `<button>`)
- 이미지에 대체 텍스트 제공 (`alt` 속성)
- 포커스 링 스타일 명시 (`focus:ring-2`)

### 3. 유지보수성
- 하드코딩된 값 최소화
- 재사용 가능한 컴포넌트 우선 설계
- 일관된 네이밍 컨벤션 사용

### 4. shadcn 스타일 원칙
- 부드러운 모서리 (`rounded-md`, `rounded-lg`)
- 미세한 그림자 효과 (`shadow-sm`, `hover:shadow-md`)
- 자연스러운 애니메이션 (`transition-all`, `transition-colors`)
- 일관된 간격 시스템

---

## 🔍 예제

### 버튼 컴포넌트 스타일

```erb
<!-- Primary Button -->
<button class="inline-flex items-center justify-center rounded-md px-6 py-3 text-sm font-semibold shadow-sm transition-colors hover:opacity-90 focus:outline-none focus:ring-2 focus:ring-offset-2" 
        style="background-color: #0052CC; color: #FFFFFF; --tw-ring-color: #0052CC;">
  시작하기
</button>

<!-- Secondary Button -->
<button class="inline-flex items-center justify-center rounded-md border px-4 py-2 text-sm font-medium transition-colors hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2" 
        style="border-color: #E2E8F0; color: #718096; --tw-ring-color: #0052CC;">
  취소
</button>

<!-- Icon Button -->
<button class="inline-flex items-center justify-center rounded-md h-9 w-9 transition-colors hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-offset-2" 
        style="--tw-ring-color: #0052CC; background-color: transparent;">
  <%= icon('search', class: 'h-4 w-4', style: 'color: #718096') %>
</button>
```

### 입력 필드 스타일

```erb
<input type="text" 
       placeholder="경제 콘텐츠 검색..." 
       class="w-full rounded-md border px-4 py-2 text-sm placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-offset-2"
       style="border-color: #E2E8F0; background-color: #FFFFFF; color: #1A202C; --tw-ring-color: #0052CC;" />
```

### 태그 스타일

```erb
<!-- Primary Tag -->
<span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold" 
      style="background-color: #1EC7A6; color: #FFFFFF;">
  경제전망
</span>

<!-- Secondary Tag -->
<span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold" 
      style="background-color: #F5F7FA; color: #718096;">
  +2
</span>
```

---

## 📖 추가 리소스

- [Tailwind CSS 공식 문서](https://tailwindcss.com/docs)
- [shadcn/ui 컴포넌트](https://ui.shadcn.com/)
- [Tabler Icons](https://tablericons.com/)
- [WCAG 2.1 가이드라인](https://www.w3.org/WAI/WCAG21/quickref/)

---

## 🔄 업데이트 히스토리

| 버전 | 날짜 | 변경사항 |
|------|------|----------|
| 1.0.0 | 2025-01-06 | 초기 스타일 가이드 작성 |

---

*이 문서는 프로젝트 발전에 따라 지속적으로 업데이트됩니다. 새로운 컴포넌트나 패턴이 추가될 때마다 문서를 갱신해주세요.*