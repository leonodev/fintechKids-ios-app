---
name: design-system
description: Manages and creates design components for the FHKDesignSystem. Guides the user in selecting existing components and generates SwiftUI code for new components, ensuring the correct use of Typography, Colors, and Spacing.
---

1. **Guidelines**:
- Use this example [component creation](example-component.swift) as a guide on how to create a new component.

2. **Domain Business Rules (Rules of Gold)**:
* **Constraint 1:** Every component created (e.g., a button) must support these internal states: (`.skeleton`, `.error`, `.disabled`, `.loaded`). This ensures each component can react to each specific case.
* **Constraint 2:** Each component must include a Preview to visualize how it renders in all 4 states.
* **Constraint 3:** Components must not receive any domain objects; they must only receive primitive properties to avoid coupling.
* **Constraint 4:** New structs for components must be `public` and include a `public init` to initialize all properties, as these components are used by external modules. All internal properties must be `private let`.
* **Constraint 5:** If the component requires an animation, you must ask me for the Lottie's name. If the component does not require animations, ignore this step. Only when applicable, instantiate the new Lottie in the `Lotties.swift` manager.
* **Constraint 6:** If I ask to add a new avatar, you must ask me for the name I want to assign to it. You will then add it to the `AvatarType.swift` file; I will manually add the image to the assets.

3. **UI & Design System (FHK Identity)**
* **Design Tokens:** Always use `FHKColor`, `FHKSpace`, and `FHKSize`.
* **Hardcoding Rule:** Zero hardcoded colors or paddings allowed.

4. **AI Interaction Protocol**
* **Behavior:** Be interactive and communicate in **Spanish**. Before generating code, analyze if the functional description suggests the use of animated icons or avatars. Ask explicitly: "¿Este componente requiere un Lottie o un Avatar?" Only if the answer is affirmative, proceed with questions regarding file names. If the answer is "no", execute the code directly following the design rules.


5. **Commit Changes**:
- commit the staged changes using [conventional commit messages](/skills/commit-changes/conventional-commits.md) guidelines.

6. **Path DesignSystem Module:** `../fintechKids-modulo-designsystem-ios` -> FHKDesignSystem Repository
- Path Github Repository [FHKDesignSystem repository](https://github.com/fintech-kiddies/FHKDesignSystem).

7. **Push Change to FHKDesignSystem Repository**
- Check if there have been any changes to the FHKDesignSystem Repository module mentioned in step 6. If there have been any changes, then ask me to confirm the push to the correct repository on GitHub.


* **Checklist:** 
    - [ ] All components must support the 4 states (`.skeleton`, `.error`, `.disabled`, `.loaded`).
    - [ ] All created components must have a Preview with all four states.
    - [ ] Components do not receive domain objects.
    - [ ] New component structs are `public` with a `public init`.
    - [ ] Lotties are referenced in their corresponding manager.
    - [ ] Avatars are referenced in their corresponding manager.
    - [ ] Use only system-defined colors, fonts, spacing, and sizes (FHK Design Tokens).
    - [ ] Check if there have been any changes to the FHKDesignSystem Repository and make commit.
    - [ ] Push to the FHKDesignSystem Repository