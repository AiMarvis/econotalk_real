import { Controller } from "@hotwired/stimulus"

// IntersectionObserver를 사용하여 "더 보기" 링크가 화면에 보이면 자동으로 클릭
export default class extends Controller {
  static targets = ["link"]
  
  connect() {
    this.observer = new IntersectionObserver(
      this.handleIntersection.bind(this),
      {
        threshold: 0.1,
        rootMargin: "100px"
      }
    )
    
    // 기존 링크가 있으면 관찰 시작
    if (this.hasLinkTarget) {
      this.observer.observe(this.linkTarget)
    }
  }
  
  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }
  
  linkTargetConnected(element) {
    // 새로운 링크가 추가되면 관찰 시작
    this.observer.observe(element)
  }
  
  linkTargetDisconnected(element) {
    // 링크가 제거되면 관찰 중단
    this.observer.unobserve(element)
  }
  
  handleIntersection(entries) {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        // 링크가 화면에 보이면 자동으로 클릭
        entry.target.click()
        // 중복 로딩 방지를 위해 관찰 중단
        this.observer.unobserve(entry.target)
      }
    })
  }
  
  load(event) {
    // 수동 로드 버튼 클릭 시 (필요시 추가 로직)
    const link = event.currentTarget
    this.observer.unobserve(link)
  }
}