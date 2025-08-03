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

### Automated Code Review Process
When using `/sc:implement` command, an automated code review process is triggered:
- **Post-Implementation Review**: After each `/sc:implement` completion, automatically analyze implemented code using Gemini CLI MCP
- **Review Scope**: Analyze code quality, identify potential refactoring opportunities, and suggest improvements
- **Review Language**: All review content must be written in Korean (한국어로 리뷰 내용 작성)
- **Non-Intrusive**: Gemini CLI MCP is used for analysis only - no direct code modifications allowed
- **Review Output**: Provide structured feedback including code quality assessment and refactoring recommendations

**Important Notes:**
- This automated review only triggers with `/sc:implement` command usage
- Gemini CLI MCP serves as analysis tool only, not for code modification
- Claude Code remains the primary implementation tool

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