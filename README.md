# 4. Domain Driven Design(DDD) for App Architecture

Date: 2025-05-29

## Status

Proposed

## Context

Currently, there is no unified architectural approach consistently followed across the app. While MVVM is the most commonly adopted pattern,
its implementation varies between different teams and feature streams. 
Each team has developed its own conventions for organizing code, resulting in fragmentation across the codebase.

This lack of architectural consistency poses several challenges:
- Unclear separation of concerns: Business logic is often intertwined with UI or networking code, making responsibilities ambiguous and harder to trace.
- Tight coupling between layers: Domain logic is frequently embedded within the ViewModel or directly within the UI layer, which complicates testing, scalability, and long-term maintainability.
- Poor testability and replaceability: Because boundaries between layers are unclear, writing isolated unit tests or swapping implementations without side effects becomes difficult.
- Inconsistent structure: Teams structure features differently, leading to steep learning curves when onboarding new developers or transitioning between teams.
- Degraded developer experience: Navigating the codebase becomes cumbersome as the structure varies widely between features.

To address these issues, we propose adopting Domain-Driven Design (DDD) as a foundation for app architecture. DDD emphasizes organizing code around business domains and aligning technical structure with real-world concepts. 
When combined with MVVM and SwiftUI for UI presentation, DDD helps promote:
- Feature-first modularization: Clear boundaries between features aligned with domain logic.
- Improved scalability: Easier to onboard developers, split work across teams, and evolve individual domains independently.
- Testability and maintainability: Encapsulated business rules and clearer ownership allow for more reliable and flexible code.
- Consistency across teams: A standard, domain-oriented structure enhances code comprehension and cross-team collaboration.

The goal is not to replace MVVM or SwiftUI, but rather to refine the architecture around well-defined domain boundaries, enforce better separation of concerns, and create a more sustainable, developer-friendly foundation for 
future growth.


## Decision

We will adopt Domain-Driven Design (DDD) as the foundational architectural paradigm for organizing all app modules moving forward. While we will continue using MVVM for managing state and UI logic, it will be integrated 
within a DDD-based modular structure to ensure clearer separation of concerns and alignment with business needs.

Each feature module will be self-contained and structured into the following layers:
- Domain:
  - Contains core business logic, entities, value objects, and use cases.
  - Fully independent of any UI or data persistence details.
  - Defines interfaces (protocols) for repositories or services that the domain depends on, allowing the actual implementations to live in infrastructure.
  - This layer should remain pure and platform-agnostic, making it highly testable and reusable.
- Application:
  - Contains coordination logic, mappers, view models, and input/output transformation between domain and UI layers.
  - Implements the orchestration of use cases, making it the “glue” between domain and UI.
  - It may depend on both the domain and infrastructure layers, but not on SwiftUI or UIKit directly.
- UI:
  - Includes all SwiftUI views, view-specific modifiers, animations, and UI state management via view models.
  - This is the only layer that should interact with SwiftUI.
  - It communicates with the application layer to trigger use cases and observe UI-ready data.
- Infrastructure:
  - Contains external dependencies such as networking, local storage, analytics, third-party SDKs, and platform services.
  - Implements the interfaces defined in the domain layer.
  - Designed to be replaceable and mockable for testing purposes.

All new and existing features will gradually align with this structure, promoting:
- Modularity: Independent feature modules with well-defined boundaries.
- Testability: Isolated business logic and abstractions improve unit and integration test coverage.
- Scalability: Teams can work in parallel on different domains without stepping on each other’s toes.
- Maintainability: Easier to understand, refactor, and evolve over time.
- Reusability: Common domain logic can be shared across platforms or features without duplication.

This decision enables us to scale development across multiple teams, streamline onboarding, and establish a consistent and sustainable foundation for future growth and experimentation.

## Consequences

What becomes easier or more difficult to do and any risks introduced by the change that will need to be mitigated.



<!--3. Decision-->
<!---->
<!--We will adopt Domain Driven Design as the foundational structure for all app modules moving forward. MVVM will still be used as the UI layer architecture, but within a DDD-oriented structure.-->
<!---->
<!--Each feature module will contain:-->
<!---->
<!--Domain: Business models, use cases, and logic (independent of UI or data sources)-->
<!---->
<!--Application: Coordinators, mappers, view models-->
<!---->
<!--UI: SwiftUI views, modifiers, animations-->
<!---->
<!--Infrastructure: Networking, persistence, third-party services-->
<!---->
<!--All features will follow this structure to promote modularity, maintainability, and scalability.-->
<!---->
<!--4. Alternatives Considered-->
<!---->
<!--Continue with current MVVM-only approach: Rejected due to inconsistent implementations and long-term maintainability concerns.-->
<!---->
<!--Use VIPER or Clean Architecture: Rejected as they tend to be over-engineered for our team’s size and feature complexity.-->
<!---->
<!--Feature-first flat structure: Helpful for small teams, but lacks clear layering and separation of business logic.-->
<!---->
<!--5. Consequences-->
<!---->
<!--Developers will need to be trained in DDD principles and layering-->
<!---->
<!--Refactoring will be required for existing modules to align with DDD-->
<!---->
<!--Improved modularity and testability across features-->
<!---->
<!--Better team collaboration through uniform structure-->
<!---->
<!--Increased onboarding speed and reduced cognitive load for new developers-->
