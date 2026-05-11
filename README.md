# MealPrep 
> Meal planning, reimagined.

A modern iOS meal prep scheduling app built with SwiftUI. Plan your meals, manage your pantry, generate smart grocery lists, and share recipes with friends — all stored locally on device.

---

## Team

| Engineer | Ownership |
|---|---|
| Engineer 1 - Hlaine Nadi Khant| Home, Trending, Recipe Detail, Sharing |
| Engineer 2 - S M Rakib Chowdhury| Schedule, Grocery List, Inventory |
| Engineer 3 - Enerel Tsolmonbayar| Profile, Potluck, Auth, Navigation |

---

## Tech Stack

| | |
|---|---|
| Language | Swift 5.9+ |
| UI Framework | SwiftUI |
| State Management | `@Observable` macro (iOS 17+) |
| Local Storage | `UserDefaults` |
| Minimum iOS | iOS 17.0 |
| Xcode Version | Xcode 15+ |

---

## Features

### Guest Users
- Browse all recipes and food bloggers
- Can not schedule meals
- Search by cuisine and ingredient
- Share recipes via link

### Logged-in Users
- Everything guests can do, plus:
- Save and like recipes
- Create public or private recipes
- Follow food bloggers
- Schedule meals with no time limit
- Inventory management
- Auto-generated weekly grocery lists
- Host and join potlucks

---

## Architecture

**Pattern:** MVVM with local persistence via `UserDefaults`

All data is stored on-device. No backend, no network calls. Mock data is used for recipes, trending content, and bloggers during development.

---


---



## Getting Started

1. Clone the repo
2. Open `MealPrep.xcodeproj` in Xcode 15+
3. Select an iOS 17 simulator or physical device
4. Build and run — no API keys or configuration needed

