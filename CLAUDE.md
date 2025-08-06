# EconoTalk Real - Rails Development Guide

## Project Configuration

**Rails Application**: EconotalkReal - Full-stack Rails application with swarm-based development

### Technical Stack
- **Rails Version**: 8.0.2
- **Ruby Version**: 3.4.5  
- **Test Framework**: Minitest
- **Frontend**: Turbo/Stimulus enabled
- **Architecture**: Full-stack Rails with specialized agent collaboration

## ClaudeOnRails Swarm Configuration

This project uses ClaudeOnRails with specialized agents for different Rails development aspects:
- Swarm agents have domain expertise and work in designated directories
- Collaborative feature implementation across all application layers
- Architect agent coordinates team development

## Development Standards

### Rails Best Practices
- Follow Rails conventions and established patterns
- Write comprehensive tests for all new functionality
- Use strong parameters in controllers for security
- Keep models focused with single responsibilities
- Extract complex business logic to dedicated service objects
- Ensure proper database indexing for foreign keys and query optimization

### Code Quality Guidelines
Follow clean code principles and maintain consistency across the codebase.

### MANDATORY Automated Code Review Process
**CRITICAL REQUIREMENT**: When using `/sc:implement` command, Claude MUST automatically execute code review process immediately after implementation completion.

**Automatic Execution Flow:**
1. **Implementation Completion**: After `/sc:implement` finishes successfully
2. **IMMEDIATE AUTO-TRIGGER**: Claude must automatically call `mcp__gemini-cli__ask-gemini` tool
3. **Review Scope**: Analyze all implemented code files for quality, potential issues, and improvements
4. **Review Language**: ALL review content MUST be written in Korean (한국어 필수)
5. **Review Output**: Provide structured feedback with code quality assessment and refactoring recommendations

**Gemini CLI MCP Integration:**
```
MUST execute after every /sc:implement:
mcp__gemini-cli__ask-gemini with changeMode: false
Prompt: "방금 구현된 코드를 분석하고 한국어로 코드 리뷰를 제공해주세요. 코드 품질, 잠재적 문제점, 리팩토링 기회를 분석해주세요."
```

**Implementation Requirements:**
- ✅ AUTOMATIC execution - no user request needed
- ✅ MANDATORY after every `/sc:implement` completion  
- ✅ Korean language output only
- ✅ Analysis-only mode (no code modifications)
- ✅ Structured feedback format

**Claude's Action Items:**
1. Complete `/sc:implement` task
2. **IMMEDIATELY** call Gemini CLI MCP for code review
3. Present Korean code review results to user
4. No additional user input required for this process

## Project Documentation

<vooster-docs>
- @vooster-docs/prd.md - Product Requirements Document
- @vooster-docs/architecture.md - System Architecture Overview
- @vooster-docs/guideline.md - Development Guidelines
- @vooster-docs/design-guide.md - Design System Guide
- @vooster-docs/ia.md - Information Architecture
- @vooster-docs/step-by-step.md - Implementation Steps
- @vooster-docs/clean-code.md - Clean Code Standards
- @vooster-docs/git-commit-message.md - Git Commit Convention
- @vooster-docs/isms-p.md - Project Principles
</vooster-docs>