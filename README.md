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
- Modularity:
  - Independent feature modules with well-defined boundaries.
- Testability:
  - Isolated business logic and abstractions improve unit and integration test coverage.
- Scalability:
  - Teams can work in parallel on different domains without stepping on each other’s toes.
- Maintainability:
  - Easier to understand, refactor, and evolve over time.
- Reusability:
  -  Common domain logic can be shared across platforms or features without duplication.

This decision enables us to scale development across multiple teams, streamline onboarding, and establish a consistent and sustainable foundation for future growth and experimentation.

## Consequences

Positive Consequences
  - Improved Modularity
    - Each feature becomes a self-contained module with clear boundaries, making it easier to work on independently without affecting others.
	- Better Separation of Concerns
    - Responsibilities are clearly divided among layers (UI, Application, Domain, Infrastructure), reducing ambiguity and code entanglement.
	-	Higher Testability
    - Core business logic in the Domain layer is independent of frameworks and easier to unit test.
	- Scalability Across Teams
    - Allows teams to work in parallel on different domains with less dependency or conflict, improving velocity and collaboration.
	-	Improved Maintainability and Code Readability
    - Structured organization of code makes it easier to onboard new developers and reduces the time spent understanding feature internals.
	- Alignment With Business Logic
    - Domain-first approach ensures business rules are modeled and encapsulated appropriately, reducing risk of bugs and misbehavior in logic.

Negative Consequences
  - Increased Initial Complexity
  - DDD introduces new layers and abstractions, which can feel over-engineered for smaller or simpler features.
	- Learning Curve for Developers
    - Developers unfamiliar with DDD concepts may need time to adjust, especially if coming from a more straightforward MVVM or MVC approach.
	- Higher Onboarding Time in Early Stages
    - Until the structure becomes standardized and well-documented, new contributors may face difficulty navigating between layers.

Neutral Consequences
  - No Change in UI Framework
    - SwiftUI and MVVM continue to be used for UI composition, so existing knowledge still applies. The change is more structural than functional.
	- Tooling and Build Remain the Same
    - No major impact on CI/CD pipelines, dependency management (e.g., CocoaPods, Swift Package Manager), or testing frameworks.
	- Gradual Adoption Possible
    - Teams can choose to incrementally apply DDD to new features while keeping existing ones untouched until needed.

## References
  - A concise video explaing core concets of DDD in context of  mobile development: [Video Link](https://www.youtube.com/watch?v=kKpcxJTCIfQ)
  - Referrals PR implemening DDD approach: [Github Link](https://github.com/mindvalley/Mobile_iOS_Mindvalley/pull/4601)
