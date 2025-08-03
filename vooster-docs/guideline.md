# Project Code Guidelines: Economic Content Community

This document outlines the coding standards and best practices for the Economic Content Community project. Adhering to these guidelines ensures consistent, maintainable, high-quality, and performant code, aligning with our project goals of rapid MVP development and a server-centric approach.

## 1. Project Overview

The Economic Content Community is a web-based platform designed for economic and investment beginners to access aggregated content (columns, newsletters, YouTube videos) and engage in real-time discussions.

**Key Architectural Decisions:**
*   **Monolithic Backend**: Ruby on Rails 8 serves as the core, handling all business logic, API endpoints, and UI rendering.
*   **Server-Side Rendered Frontend**: Hotwire (Turbo + Stimulus) is used to deliver a dynamic, SPA-like user experience with minimal JavaScript, reducing frontend complexity and improving initial page load performance (LCP).
*   **Styling**: Tailwind CSS for utility-first, consistent UI development.
*   **Database**: PostgreSQL for robust data storage, with SQLite for development.
*   **Real-time Communication**: Action Cable and Redis facilitate real-time chat and other instant updates.
*   **Deployment**: Dockerized application on Render.com, leveraging its managed services for PostgreSQL and Redis.

## 2. Core Principles

1.  **Embrace Server-Side Rendering (SSR) with Hotwire**: Prioritize HTML-over-the-wire for UI updates to minimize JavaScript payload and improve LCP.
2.  **Adhere to Rails' Convention over Configuration**: Follow established Rails patterns and directory structures to enhance consistency and reduce development overhead.
3.  **Write Clean, Testable, and Maintainable Code**: Ensure code is readable, modular, well-tested, and easy to understand for all team members.
4.  **Optimize for Performance from the Outset**: Proactively address N+1 queries, leverage caching, and offload heavy tasks to background jobs to meet performance targets.

## 3. Language-Specific Guidelines

### 3.1 Ruby on Rails

*   **File Organization and Directory Structure**:
    *   **MUST**: Follow the standard Rails MVC structure (`app/models`, `app/controllers`, `app/views`).
    *   **MUST**: Place shared model logic in `app/models/concerns`.
    *   **MUST**: Place shared controller logic in `app/controllers/concerns`.
    *   **MUST**: Use `app/javascript/controllers` for Stimulus controllers.
    *   **MUST**: Use `app/jobs` for Active Job background tasks.
    *   **MUST**: Implement complex business logic that doesn't fit naturally in a model or controller within dedicated `app/services` objects.
    *   **MUST**: Use `app/forms` for complex form submissions or data transformations that span multiple models.
    *   **MUST**: Group related views in subdirectories (e.g., `app/views/contents`, `app/views/chats`).
    *   **MUST**: Utilize `app/views/shared` for reusable partials.

*   **Import/Dependency Management**:
    *   **MUST**: Manage Ruby dependencies via `Gemfile`. Keep gems updated regularly.
    *   **MUST**: Use `importmap` for JavaScript dependencies (Rails 7+ default) to avoid complex build setups.
    *   **MUST NOT**: Add unnecessary gems that introduce significant overhead or duplicate existing Rails functionality.

*   **Error Handling Patterns**:
    *   **MUST**: Use `rescue_from` in controllers for handling common exceptions (e.g., `ActiveRecord::RecordNotFound` for 404s).
    *   **MUST**: Implement custom error pages (`public/404.html`, `public/500.html`) for user-friendly error display.
    *   **MUST**: Log errors effectively using Rails' default logger.

### 3.2 Hotwire (Turbo + Stimulus)

*   **File Organization and Directory Structure**:
    *   **MUST**: Place all Stimulus controllers in `app/javascript/controllers`.
    *   **MUST**: Keep ERB templates clean and directly embed `turbo_frame_tag` and `turbo_stream_from` helpers.
    *   **MUST NOT**: Create a separate `src` directory for frontend code; integrate directly into `app/javascript`.

*   **Import/Dependency Management**:
    *   **MUST**: Rely on Stimulus's auto-loading mechanism for controllers.
    *   **MUST NOT**: Introduce complex frontend build tools (e.g., Webpack, Vite) unless absolutely necessary for specific features.

*   **Error Handling Patterns**:
    *   **MUST**: Leverage Turbo's built-in error handling for form submissions and navigation. Server-side validation errors should be rendered as HTML and returned.
    *   **MUST**: For network errors, ensure the server returns appropriate HTTP status codes (e.g., 422 for unprocessable entity, 500 for server errors).
    *   **MUST NOT**: Implement extensive client-side JavaScript error handling that duplicates server-side logic.

### 3.3 Tailwind CSS

*   **File Organization and Directory Structure**:
    *   **MUST**: Use `app/assets/stylesheets/application.tailwind.css` as the primary entry point for Tailwind directives (`@tailwind base`, `@tailwind components`, `@tailwind utilities`).
    *   **MUST**: Define any custom CSS or component styles within this file or separate partials imported into it.

*   **Import/Dependency Management**:
    *   **MUST**: Configure `tailwind.config.js` to purge unused CSS classes for production builds.

## 4. Code Style Rules

### MUST Follow:

*   **Ruby/Rails Naming Conventions**:
    *   **MUST**: Use `snake_case` for method names, variable names, and file names.
    *   **MUST**: Use `CamelCase` for class and module names.
    *   **MUST**: Use `SCREAMING_SNAKE_CASE` for constants.
    *   **Rationale**: Ensures consistency with Ruby and Rails standards, improving readability.

*   **RuboCop Compliance**:
    *   **MUST**: Ensure all Ruby code passes RuboCop checks. Integrate RuboCop into your IDE and pre-commit hooks.
    *   **Rationale**: Enforces consistent code style and identifies potential issues, leading to higher code quality.

*   **Strong Parameters**:
    ```ruby
    # MUST: Use strong parameters for all controller actions handling user input
    # Rationale: Prevents mass assignment vulnerabilities.
    def content_params
      params.require(:content).permit(:title, :url, :category, tag_ids: [])
    end
    ```

*   **Database Query Optimization (N+1 Prevention)**:
    ```ruby
    # MUST: Eager load associations to prevent N+1 queries.
    # Rationale: Significantly reduces database round trips, improving performance.
    def index
      @contents = Content.includes(:user, :tags).all
    end
    ```

*   **Service Objects for Complex Logic**:
    ```ruby
    # MUST: Encapsulate complex business logic in service objects.
    # Rationale: Keeps models and controllers lean, improves testability and reusability.
    # app/services/content_creator.rb
    class ContentCreator
      def initialize(params, user)
        @params = params
        @user = user
      end

      def call
        Content.transaction do
          content = @user.contents.create!(@params)
          # Additional complex logic, e.g., notification, external API call
          content
        end
      rescue ActiveRecord::RecordInvalid => e
        # Handle specific errors
        nil
      end
    end

    # In controller
    def create
      content = ContentCreator.new(content_params, current_user).call
      if content
        redirect_to content, notice: 'Content was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end
    ```

*   **Stimulus Controllers for Client-Side Interactivity**:
    ```javascript
    // MUST: Use Stimulus for light, isolated client-side interactivity.
    // Rationale: Minimizes JavaScript and keeps logic close to the HTML.
    // app/javascript/controllers/toggle_controller.js
    import { Controller } from "@hotwired/stimulus"

    export default class extends Controller {
      static targets = ["item"]

      toggle() {
        this.itemTarget.classList.toggle("hidden")
      }
    }
    ```

*   **Tailwind CSS Utility-First**:
    ```html
    <!-- MUST: Prefer utility classes over custom CSS when possible. -->
    <!-- Rationale: Faster development, consistent design, smaller CSS bundle. -->
    <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
      Click Me
    </button>
    ```

### MUST NOT Do:

*   **Fat Controllers/Models**:
    ```ruby
    # MUST NOT: Place excessive business logic directly in controllers or models.
    # Rationale: Leads to bloated, hard-to-test, and hard-to-maintain code.
    # Bad example (Fat Controller):
    class ContentsController < ApplicationController
      def create
        @content = current_user.contents.new(params.require(:content).permit(:title, :url, :category))
        if @content.save
          # Complex logic here:
          # - Send notifications
          # - Process images
          # - Update user statistics
          redirect_to @content, notice: 'Content created.'
        else
          render :new
        end
      end
    end
    ```
    *   **Correction**: Extract complex logic into Service Objects or Active Job.

*   **N+1 Queries (Anti-pattern)**:
    ```ruby
    # MUST NOT: Execute N+1 queries.
    # Rationale: Causes significant performance degradation, especially with many records.
    # Bad example:
    @contents = Content.all
    @contents.each do |content|
      puts content.user.email # This will cause N+1 queries if user is not eager loaded
    end
    ```

*   **Complex JavaScript State Management**:
    ```javascript
    // MUST NOT: Implement large, complex client-side state management patterns (e.g., Redux-like stores).
    // Rationale: Hotwire's strength is server-side rendering; complex JS state defeats this purpose and adds unnecessary complexity.
    // Bad example:
    // let globalState = { user: {}, notifications: [] };
    // function updateGlobalState(...) { ... }
    // (Avoid this approach for general UI state)
    ```
    *   **Correction**: Rely on server-rendered HTML for state, and use Stimulus for isolated UI component state.

*   **Inline Custom CSS Styles**:
    ```html
    <!-- MUST NOT: Use inline style attributes for styling unless absolutely necessary for dynamic, calculated styles. -->
    <!-- Rationale: Violates separation of concerns, hard to maintain and override, defeats Tailwind's purpose. -->
    <div style="background-color: blue; padding: 16px;">
      Hello
    </div>
    ```
    *   **Correction**: Use Tailwind utility classes: `<div class="bg-blue-500 p-4">Hello</div>`

## 5. Architecture Patterns

### 5.1 Component/Module Structure Guidelines

*   **Rails MVC with Enhancements**:
    *   **Controllers**: Handle HTTP requests, authenticate users, authorize actions, call appropriate service objects or models, and render views. Keep them thin.
    *   **Models**: Contain core business logic, data validations, associations, and database interactions via Active Record. Use `concerns` for shared model behaviors.
    *   **Views**: Focus solely on presenting data. Contain minimal logic, primarily loops and conditionals. Utilize partials (`_partial.html.erb`) for reusability.
    *   **Service Objects**: For business processes that involve multiple models, external APIs, or complex transactional logic. They are single-responsibility classes.
    *   **Form Objects**: For handling complex form submissions that don't map directly to a single Active Record model, or require specific data transformations before saving.
    *   **Jobs**: For long-running or asynchronous tasks (e.g., sending emails, generating reports) using Active Job.

*   **Hotwire Frontend Components**:
    *   **Turbo Drive**: Manages full page navigation without full page reloads.
    *   **Turbo Frames**: Define independent UI regions that can be updated in isolation by fetching HTML fragments from the server. Use `turbo_frame_tag` in views.
    *   **Turbo Streams**: Push HTML changes from the server to the client in real-time via WebSockets or HTTP responses. Use `turbo_stream` helpers in controllers or `channels`.
    *   **Stimulus Controllers**: Provide lightweight JavaScript behavior directly on HTML elements. Keep them small and focused on DOM manipulation.

### 5.2 Data Flow Patterns

*   **Client-Server Interaction (HTTP/Hotwire)**:
    1.  User action (e.g., link click, form submission) triggers a Turbo Drive navigation or Turbo Frame request.
    2.  Browser sends an HTTP request to the Rails application.
    3.  Rails controller processes the request, interacts with models and services.
    4.  Rails renders an HTML response (full page, Turbo Frame, or Turbo Stream).
    5.  Browser updates the UI based on the received HTML.

*   **Real-time Data Flow (Action Cable)**:
    1.  Client subscribes to an Action Cable channel (e.g., `ChatChannel`).
    2.  Server (Rails) broadcasts messages to the channel via Redis Pub/Sub.
    3.  Subscribed clients receive messages via WebSocket and update their UI (often via Turbo Streams).

*   **Database Interaction**:
    *   All database operations **MUST** go through Active Record ORM.
    *   **MUST** use transactions for operations that require atomicity (e.g., `ActiveRecord::Base.transaction do ... end`).
    *   **MUST** define appropriate indexes on frequently queried columns (e.g., foreign keys, search fields).

### 5.3 State Management Conventions

*   **Server-Side State (Primary)**:
    *   User authentication state managed by Rails sessions.
    *   Application data state (content, users, chats) stored in PostgreSQL.
    *   View state often re-rendered by the server on each request or Turbo update.
*   **Client-Side State (Minimal)**:
    *   **MUST**: Limit client-side state to temporary UI states (e.g., tab selection, dropdown visibility) managed by Stimulus controllers.
    *   **MUST NOT**: Implement global JavaScript state stores for application data.

### 5.4 API Design Standards

*   **RESTful Principles**:
    *   **MUST**: Adhere to RESTful principles for defining routes and controller actions (e.g., `resources :contents` for CRUD operations).
    *   **MUST**: Use standard HTTP verbs (GET, POST, PUT/PATCH, DELETE) appropriately.
*   **HTML-Over-The-Wire (Default)**:
    *   **MUST**: Prioritize serving HTML over JSON for UI updates, leveraging Turbo Frames and Turbo Streams.
*   **JSON APIs (As Needed)**:
    *   If specific features (e.g., integration with mobile apps, complex frontend-only interactions) require a JSON API, **MUST** follow a consistent JSON format.
    *   **MUST** include appropriate HTTP status codes (e.g., 200 OK, 201 Created, 400 Bad Request, 404 Not Found, 422 Unprocessable Entity).