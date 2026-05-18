# 🧩 [designsystem] Module Context: FintechHomeKids (FHK)
- Swift Package Manager (SPM) Module

## 1. Role & Scope
* **Module Name:** [FHKDesignSystem]
* **Primary Responsibility:** [Responsible for exposing UI components, Colors, Fonts, Sizes, Spaces, etc.]
* **Repository Root:** `../fintechKids-modulo-designsystem-ios`
* **Critical Paths:**
    1. `../fintechKids-modulo-designsystem-ios/Sources/FHKDesignSystem/Components/Views`
        - Contains all views classified in subfolders by component type.
    2. `../fintechKids-modulo-designsystem-ios/Sources/FHKDesignSystem/Components/Views/Modifiers`
        - Contains modifiers that can be applied to Views.
    3. `../fintechKids-modulo-designsystem-ios/Sources/FHKDesignSystem/Components/Views/UIViewRepresentable`
        - Contains UI elements using UIKit, acting as wrappers for SwiftUI usage.
    4. `../fintechKids-modulo-designsystem-ios/Sources/FHKDesignSystem/Extensions`
        - Contains extensions that can be applied to Views.
    5. `../fintechKids-modulo-designsystem-ios/Sources/FHKDesignSystem/Managers`
        - Contains managers for utilizing components such as Fonts, Colors, Images, Lotties, etc.
    6. `../fintechKids-modulo-designsystem-ios/Sources/FHKDesignSystem/Resources`
        - Contains Assets, Colors, Fonts, and Lotties in JSON format.
    7. `../fintechKids-modulo-designsystem-ios/Sources/FHKDesignSystem/Sizes`
        - Contains all size typologies.
    8. `../fintechKids-modulo-designsystem-ios/Sources/FHKDesignSystem/Space`
        - Contains all spacing typologies.

## 2. Technical Stack & Dependencies
* **Core Frameworks:** [SwiftUI, Swift 6]
* **Internal Dependencies:** [FHKUtils]
* **External SDKs:** [swift-snapshot-testing, lottie-spm, swift-algorithms]

## 3. Assigned Skills
- You must strictly enforce all the rules, interactive flows, and checklists defined in `.ai/skills/design-system/SKILL.md`.