# Seeds file for EconoTalk Real
# This creates sample data for development

puts "Creating seed data..."

# Create users
users = [
  { email: "john@example.com", name: "John Kim" },
  { email: "sarah@example.com", name: "Sarah Lee" },
  { email: "mike@example.com", name: "Mike Park" },
  { email: "emma@example.com", name: "Emma Choi" }
]

created_users = users.map do |user_attrs|
  User.find_or_create_by(email: user_attrs[:email]) do |user|
    user.name = user_attrs[:name]
  end
end

puts "Created #{created_users.count} users"

# Create tags
tags_data = [
  "주식", "채권", "부동산", "경제지표", "금리", 
  "인플레이션", "투자전략", "재테크", "암호화폐", "ESG",
  "경제뉴스", "시장분석", "펀드", "ETF", "배당"
]

created_tags = tags_data.map do |tag_name|
  Tag.find_or_create_by(name: tag_name)
end

puts "Created #{created_tags.count} tags"

# Create sample content
sample_contents = [
  {
    title: "2024년 하반기 경제 전망과 투자 전략",
    body: "전문가들이 분석하는 2024년 하반기 경제 동향을 살펴보고, 개인 투자자들이 알아야 할 핵심 투자 전략을 소개합니다. 금리 변화와 인플레이션이 우리의 투자에 미치는 영향을 자세히 분석해보겠습니다.",
    content_type: "column",
    link: "https://example.com/article1",
    tags: ["경제지표", "투자전략", "시장분석"]
  },
  {
    title: "초보자를 위한 주식 투자 가이드",
    body: "주식 투자를 처음 시작하는 분들을 위한 완벽 가이드입니다. 기본 용어부터 시작해서 종목 선택 방법, 리스크 관리까지 모든 것을 알려드립니다. 안전하고 현명한 투자를 위한 첫걸음을 함께 해보세요.",
    content_type: "video",
    link: "https://youtube.com/watch?v=example1",
    tags: ["주식", "투자전략", "재테크"]
  },
  {
    title: "부동산 시장 동향 분석 - 서울 아파트값 전망",
    body: "최근 서울 부동산 시장의 변화를 데이터로 분석해보고, 향후 전망을 예측해봅니다. 정부 정책 변화와 금리 동향이 부동산 가격에 미치는 영향을 종합적으로 살펴보겠습니다.",
    content_type: "newsletter",
    link: "https://example.com/newsletter1",
    tags: ["부동산", "시장분석", "경제뉴스"]
  },
  {
    title: "ETF vs 개별주식, 어떤 것이 유리할까?",
    body: "개별 주식 투자와 ETF 투자의 장단점을 비교 분석합니다. 각각의 특성을 이해하고 본인의 투자 성향에 맞는 선택을 할 수 있도록 도와드리겠습니다.",
    content_type: "column",
    link: "https://example.com/article2",
    tags: ["ETF", "주식", "투자전략"]
  },
  {
    title: "인플레이션 시대의 자산 배분 전략",
    body: "인플레이션이 지속되는 상황에서 자산을 어떻게 배분해야 할지 고민이신가요? 인플레이션 헤지 자산들을 살펴보고, 효과적인 포트폴리오 구성 방법을 알아보겠습니다.",
    content_type: "video",
    link: "https://youtube.com/watch?v=example2",
    tags: ["인플레이션", "투자전략", "재테크"]
  },
  {
    title: "암호화폐 투자, 알아야 할 기본 지식",
    body: "비트코인, 이더리움을 비롯한 주요 암호화폐의 특징과 투자 시 고려사항을 설명합니다. 높은 변동성을 가진 암호화폐 시장에서 안전하게 투자하는 방법을 알아보세요.",
    content_type: "column",
    link: "https://example.com/article3",
    tags: ["암호화폐", "투자전략", "시장분석"]
  },
  {
    title: "월간 경제 리포트 - 11월호",
    body: "11월 주요 경제 지표와 시장 동향을 종합 분석한 월간 리포트입니다. 국내외 경제 상황과 주요 이슈들을 정리하여 투자 인사이트를 제공합니다.",
    content_type: "newsletter",
    link: "https://example.com/newsletter2",
    tags: ["경제뉴스", "경제지표", "시장분석"]
  },
  {
    title: "배당주 투자의 모든 것",
    body: "안정적인 현금흐름을 원하는 투자자들을 위한 배당주 투자 가이드입니다. 우량 배당주를 선별하는 방법과 배당 재투자 전략에 대해 상세히 설명합니다.",
    content_type: "video",
    link: "https://youtube.com/watch?v=example3",
    tags: ["배당", "주식", "투자전략"]
  },
  {
    title: "ESG 투자 트렌드와 전망",
    body: "환경, 사회, 지배구조를 고려하는 ESG 투자가 주목받고 있습니다. ESG 투자의 의미와 방법, 그리고 관련 펀드와 ETF에 대해 알아보겠습니다.",
    content_type: "column",
    link: "https://example.com/article4",
    tags: ["ESG", "펀드", "투자전략"]
  },
  {
    title: "금리 인상기 채권 투자 전략",
    body: "금리가 오르는 상황에서 채권 투자를 어떻게 접근해야 할까요? 듀레이션 리스크를 관리하면서 채권 투자를 하는 방법을 설명합니다.",
    content_type: "newsletter",
    link: "https://example.com/newsletter3",
    tags: ["채권", "금리", "투자전략"]
  }
]

# Create content with random assignment to users
sample_contents.each_with_index do |content_data, index|
  user = created_users[index % created_users.count]
  
  content = Content.find_or_create_by(title: content_data[:title]) do |c|
    c.body = content_data[:body]
    c.content_type = content_data[:content_type]
    c.link = content_data[:link]
    c.user = user
  end
  
  # Add tags to content
  tag_objects = content_data[:tags].map { |tag_name| created_tags.find { |t| t.name == tag_name } }.compact
  content.tags = tag_objects
  
  # Set created_at to different times for realistic ordering
  content.update(created_at: (index + 1).hours.ago)
end

puts "Created #{Content.count} contents"
puts "Seed data creation completed!"

# Display summary
puts "\n=== Summary ==="
puts "Users: #{User.count}"
puts "Tags: #{Tag.count}"
puts "Contents: #{Content.count}"
puts "Content Types: #{Content.group(:content_type).count}"
