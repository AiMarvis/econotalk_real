import { Controller } from "@hotwired/stimulus"

// Image preview controller for file upload functionality
export default class extends Controller {
  static targets = ["fileInput", "dropArea", "uploadPrompt", "imagePreview", "previewImage"]
  
  connect() {
    this.setupDragAndDrop()
  }

  setupDragAndDrop() {
    if (!this.hasDropAreaTarget) return

    // Prevent default drag behaviors
    ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
      this.dropAreaTarget.addEventListener(eventName, this.preventDefaults, false)
      document.body.addEventListener(eventName, this.preventDefaults, false)
    })

    // Highlight drop area when item is dragged over it
    ['dragenter', 'dragover'].forEach(eventName => {
      this.dropAreaTarget.addEventListener(eventName, () => this.highlight(), false)
    })

    ;['dragleave', 'drop'].forEach(eventName => {
      this.dropAreaTarget.addEventListener(eventName, () => this.unhighlight(), false)
    })

    // Handle dropped files
    this.dropAreaTarget.addEventListener('drop', (e) => this.handleDrop(e), false)
  }

  preventDefaults(e) {
    e.preventDefault()
    e.stopPropagation()
  }

  highlight() {
    this.dropAreaTarget.classList.add('border-blue-400', 'bg-blue-50')
  }

  unhighlight() {
    this.dropAreaTarget.classList.remove('border-blue-400', 'bg-blue-50')
  }

  handleDrop(e) {
    const dt = e.dataTransfer
    const files = dt.files

    if (files.length > 0) {
      this.fileInputTarget.files = files
      this.showPreview()
    }
  }

  showPreview() {
    const file = this.fileInputTarget.files[0]
    
    if (!file) return

    // Validate file type
    if (!file.type.startsWith('image/')) {
      this.showError('이미지 파일만 업로드할 수 있습니다.')
      return
    }

    // Validate file size (5MB limit)
    const maxSize = 5 * 1024 * 1024 // 5MB in bytes
    if (file.size > maxSize) {
      this.showError('파일 크기는 5MB 이하여야 합니다.')
      return
    }

    // Create preview
    const reader = new FileReader()
    reader.onload = (e) => {
      this.previewImageTarget.src = e.target.result
      this.hideUploadPrompt()
      this.showImagePreview()
    }
    reader.readAsDataURL(file)
  }

  removePreview() {
    this.fileInputTarget.value = ''
    this.hideImagePreview()
    this.showUploadPrompt()
    this.clearErrors()
  }

  hideUploadPrompt() {
    if (this.hasUploadPromptTarget) {
      this.uploadPromptTarget.classList.add('hidden')
    }
  }

  showUploadPrompt() {
    if (this.hasUploadPromptTarget) {
      this.uploadPromptTarget.classList.remove('hidden')
    }
  }

  showImagePreview() {
    if (this.hasImagePreviewTarget) {
      this.imagePreviewTarget.classList.remove('hidden')
    }
  }

  hideImagePreview() {
    if (this.hasImagePreviewTarget) {
      this.imagePreviewTarget.classList.add('hidden')
    }
  }

  showError(message) {
    this.clearErrors()
    
    // Create error message element
    const errorDiv = document.createElement('div')
    errorDiv.className = 'error-message mt-2'
    errorDiv.innerHTML = `<p class="text-sm font-medium" style="color: #E53E3E;">${message}</p>`
    
    // Insert error message after the file upload area
    const fileUploadArea = this.element.querySelector('.file-upload-area')
    fileUploadArea.insertAdjacentElement('afterend', errorDiv)
    
    // Clear file input
    this.fileInputTarget.value = ''
  }

  clearErrors() {
    const existingError = this.element.querySelector('.error-message')
    if (existingError) {
      existingError.remove()
    }
  }
}