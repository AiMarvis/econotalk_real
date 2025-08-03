# 경제 콘텐츠 통합 커뮤니티 디자인 가이드

## 1. Overall Mood (전체적인 무드)
서비스의 핵심 가치인 '신뢰성'과 '전문성'을 기반으로, 경제 초보자도 쉽게 다가갈 수 있는 '명료함'과 '친근함'을 더합니다. 복잡한 경제 정보를 체계적으로 정리하여 보여주는 지적인 분위기를 연출하되, 차갑지 않고 사용자의 학습과 성장을 돕는 따뜻하고 현대적인 느낌을 전달합니다. 전체적으로 정돈되고 직관적인 인터페이스를 통해 사용자가 콘텐츠에 집중할 수 있는 환경을 제공하는 것을 목표로 합니다.

## 2. Reference Service (참조 서비스)
콘텐츠 중심의 미니멀한 디자인과 뛰어난 가독성을 제공하는 서비스를 참조하여, 우리 서비스의 방향성을 구체화합니다.

- **Name**: Medium
- **Description**: 다양한 분야의 전문가와 사용자들이 글을 게시하고 공유하는 콘텐츠 퍼블리싱 플랫폼.
- **Design Mood**: 텍스트 중심의 미니멀리즘. 불필요한 시각 요소를 최소화하여 콘텐츠 가독성을 극대화한 깔끔하고 정제된 디자인.
- **Primary Color**: `#000000` (Text), `#FFFFFF` (Background)
- **Secondary Color**: `#1A8917` (Green for Accent)

## 3. Color & Gradient (색상 & 그라데이션)
신뢰감을 주는 차가운 계열의 색상을 중심으로, 사용자의 행동을 유도하고 긍정적인 경험을 제공하기 위한 따뜻한 색상을 포인트로 사용합니다.

- **Primary Color**: `#0052CC` (Indigo Blue) - 신뢰, 안정, 지성
- **Secondary Color**: `#1EC7A6` (Teal) - 성장, 명료함, 새로움
- **Accent Color**: `#FFD166` (Warm Amber) - 주의, 강조, 긍정
- **Grayscale**:
    - `#1A202C` (Text)
    - `#718096` (Subtle Text)
    - `#E2E8F0` (Border / Divider)
    - `#F5F7FA` (Background)
    - `#FFFFFF` (Card Background / White)
- **Mood**: Cool tones, medium saturation
- **Color Usage**:
    - **Primary**: 핵심 CTA 버튼(로그인, 구독, 글쓰기), 활성화된 내비게이션, 주요 링크 등 가장 중요한 상호작용 요소에 사용하여 신뢰감을 부여합니다.
    - **Secondary**: 콘텐츠 태그, 보조 버튼, 새로운 알림 표시 등 서비스에 활기와 신선함을 더하는 요소에 사용합니다.
    - **Accent**: 중요한 공지, 사용자의 이목을 집중시켜야 하는 프로모션 배너 등에 제한적으로 사용하여 피로도를 낮추고 주목도를 높입니다.
    - **Grayscale**: 전체 레이아웃의 기반이 되며, 텍스트 가독성을 확보하고 시각적 계층을 명확히 구분하는 데 사용합니다.

## 4. Typography & Font (타이포그래피 & 폰트)
경제 초보자도 쉽게 정보를 습득할 수 있도록 가독성과 명료성에 초점을 맞춘 타이포그래피 시스템을 정의합니다. 웹 접근성을 준수하며, 모바일 환경에서도 편안하게 읽을 수 있도록 설정합니다.

- **Font Family**: Pretendard (가독성이 뛰어난 범용 고딕체)

- **Heading 1 (페이지 제목)**:
    - Font: Pretendard
    - Size: 28px
    - Weight: Bold (700)
    - Letter Spacing: -0.02em

- **Heading 2 (섹션 제목, 카드 제목)**:
    - Font: Pretendard
    - Size: 22px
    - Weight: Bold (700)
    - Letter Spacing: -0.015em

- **Body (본문)**:
    - Font: Pretendard
    - Size: 16px
    - Weight: Regular (400)
    - Line Height: 1.7
    - Paragraph Spacing: 16px

- **Sub-text / Caption (메타 정보, 설명)**:
    - Font: Pretendard
    - Size: 14px
    - Weight: Regular (400)
    - Line Height: 1.5

## 5. Layout & Structure (레이아웃 & 구조)
모바일 퍼스트 원칙에 따라 설계하며, 다양한 디바이스에서 일관된 사용자 경험을 제공합니다. 콘텐츠 탐색의 효율성을 높이는 구조를 채택합니다.

- **Grid System**: 12-Column Grid System (Bootstrap 기준)
- **Spacing Unit**: 8px 기반의 스페이싱 시스템 (8px, 16px, 24px, 32px...)을 적용하여 컴포넌트 간의 간격을 일관되게 유지합니다.
- **Layout Principles**:
    - **Desktop (≥ 992px)**:
        - 전체 너비는 최대 `1200px`로 제한하여 가독성을 확보합니다.
        - `상단 GNB` + `좌측 LNB(필터)` + `중앙 콘텐츠 영역`의 2단 구조를 기본으로 합니다. LNB는 콘텐츠 탐색 시 필터링 기능을 제공합니다.
    - **Tablet (≥ 768px)**:
        - 2단 구조를 유지하되, LNB의 너비를 줄이거나 필요 시 숨김 처리(토글 버튼)합니다.
    - **Mobile (< 768px)**:
        - 모든 요소를 1단으로 재배치하는 반응형 레이아웃을 적용합니다.
        - GNB는 햄버거 메뉴로 통합하고, LNB 필터 기능은 별도의 Bottom Sheet 또는 필터 아이콘 클릭 시 전체 화면으로 제공합니다.
        - 핵심 기능(홈, 검색, 채팅, 마이페이지)은 `하단 내비게이션 바(Bottom Navigation Bar)`에 배치하여 접근성을 높입니다.

## 6. Visual Style (비주얼 스타일)
전문적이면서도 친근한 서비스 이미지를 구축하기 위해 일관된 비주얼 스타일 가이드를 따릅니다.

- **Icons**:
    - 스타일: 간결하고 명확한 의미를 전달하는 **Line Style** 아이콘 (e.g., Heroicons, Feather Icons)을 사용합니다.
    - 두께와 모서리(Corner Radius) 등 전체 아이콘 세트의 시각적 통일성을 유지합니다.
- **Illustrations**:
    - 스타일: 온보딩, 빈 화면(Empty State), 기능 소개 등에 사용되며, 부드러운 색감과 단순한 형태로 구성하여 사용자가 느낄 수 있는 심리적 장벽을 낮춥니다.
    - 서비스의 전문성을 해치지 않는 선에서 친근하고 긍정적인 느낌을 전달합니다.
- **Images & Thumbnails**:
    - 콘텐츠 카드에 사용되는 썸네일은 `16:9` 또는 `4:3` 비율로 통일하여 피드 전체의 시각적 안정감을 확보합니다.
    - 이미지가 없는 경우, 서비스 로고나 카테고리 아이콘을 활용한 세련된 Placeholder를 제공합니다.

## 7. UX Guide (UX 가이드)
타겟 사용자인 '경제 초보자'에 맞춰 직관적이고 쉬운 사용자 경험을 제공하는 것을 최우선 목표로 합니다.

- **Target User**: Beginners (초보자)
- **Core Principles**:
    1.  **Clarity over Clutter (명료함 우선)**: 사용자가 정보 과부하를 느끼지 않도록 한 화면에 너무 많은 기능을 노출하지 않습니다. 직관적인 레이블링과 쉬운 언어를 사용하여 경제 용어에 익숙하지 않은 사용자도 쉽게 이해할 수 있도록 돕습니다.
    2.  **Guided Discovery (점진적 안내)**: 최초 가입 시 관심사 설정, 핵심 기능에 대한 툴팁(Tooltip) 제공 등 단계별 온보딩 프로세스를 통해 사용자의 서비스 적응을 돕습니다. 복잡한 기능은 필요할 때 자연스럽게 발견하도록 유도합니다.
    3.  **Effortless Interaction (손쉬운 상호작용)**: 소셜 로그인, 원클릭 북마크, 직관적인 채팅 UI 등 사용자의 노력을 최소화하는 인터랙션을 설계합니다. 사용자가 콘텐츠 소비와 학습이라는 본질적인 목표에만 집중할 수 있도록 합니다.
    4.  **Positive Reinforcement (긍정적 피드백)**: '좋아요', '북마크', '공유' 등 사용자의 긍정적 행동에 대해 즉각적이고 명확한 시각적 피드백(미세한 애니메이션, 확인 메시지 등)을 제공하여 만족감과 성취감을 높입니다.

## 8. UI Component Guide (UI 컴포넌트 가이드)
서비스 전반에 걸쳐 재사용되는 핵심 UI 컴포넌트의 디자인을 정의하여 일관성을 확보합니다.

- **Buttons**:
    - **Primary Button**: `Primary Color(#0052CC)` 배경, 흰색 텍스트. 가장 중요한 행동 유도(CTA)에 사용.
    - **Secondary Button**: `Primary Color(#0052CC)` 테두리, `Primary Color` 텍스트. 보조적인 행동에 사용.
    - **Ghost/Text Button**: 배경과 테두리 없이 텍스트만으로 구성. 덜 중요한 액션에 사용.
    - **States**: Default, Hover, Pressed, Disabled 상태를 명확히 구분하여 디자인합니다. (Hover 시 약간 더 어둡거나 밝게 처리)

- **Input Fields**:
    - **Default**: `Grayscale(#E2E8F0)` 색상의 1px 테두리, 내부에 명확한 Placeholder 텍스트.
    - **On-Focus**: 테두리 색상이 `Primary Color(#0052CC)`로 변경되고, 2px 두께로 강조.
    - **States**: 에러 발생 시 테두리를 붉은색 계열로 변경하고, 하단에 에러 메시지를 명확히 표시합니다.

- **Cards (Content)**:
    - 피드의 기본 단위로, 정보 계층이 명확하게 설계됩니다.
    - **구조**: 상단부터 `썸네일 이미지` → `콘텐츠 제목 (H2 스타일)` → `본문 요약 (Body 스타일)` → `메타 정보 (작성자, 날짜)` → `태그` 순으로 배치합니다.
    - **Tags**: `Secondary Color(#1EC7A6)`를 활용한 배경 또는 텍스트 색상으로 시각적 구분을 줍니다.
    - **Interaction**: 카드 전체에 Hover 효과를 적용하여 클릭 가능한 영역임을 인지시킵니다.

- **Navigation**:
    - **Top Navigation Bar (GNB)**: 로고, 주요 메뉴(홈, 탐색), 통합 검색창, 알림, 프로필/로그인 버튼으로 구성. 스크롤 시 상단에 고정됩니다.
    - **Bottom Navigation Bar (Mobile)**: `홈`, `탐색`, `채팅`, `북마크`, `마이페이지` 등 사용 빈도가 높은 핵심 기능 5개를 배치하여 한 손 조작 편의성을 극대화합니다. 활성화된 탭은 `Primary Color`로 강조합니다.