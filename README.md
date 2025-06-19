# ToDoList

A modern task management app built with **SwiftUI**, leveraging **The Composable Architecture (TCA)** and **swift-dependencies**. Users can add, edit, complete, and filter their tasks in a clean and responsive interface, with persistent local storage powered by `UserDefaults`.

---

## Features

- Add new to-dos with inline editing  
- Edit and auto-trim empty titles  
- Toggle task state between *In Progress* and *Completed*  
- Complete all tasks at once with a single tap  
- Swipe to delete or mark tasks done/undone  
- Filter tasks by status: In Progress / Completed  
- Lightweight persistence using `UserDefaults`  
- Powered by TCA for testability and maintainable state management  

---

## Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/ToDoList.git
   cd ToDoList

2. **Install dependencies**  
   Open the `.xcodeproj` or `.xcworkspace` file in Xcode. Wait for Swift Package Manager to resolve all packages.
   
3. **Run the project**  
   Select a simulator or connect your iOS device, then build and run using ⌘R.

---

## Requirements

- Xcode 15+

- iOS 17+

- Swift Concurrency enabled

- Swift Package Dependencies:

  - swift-composable-architecture

  - swift-dependencies
   
---

## Screenshots

<img src="https://github.com/user-attachments/assets/8fbe7b97-14aa-4308-a49f-a248af027757" width="200"/>
<img src="https://github.com/user-attachments/assets/abf08a10-f4c3-44c8-b668-3a47eaf585ea" width="200"/>
<img src="https://github.com/user-attachments/assets/0f4ea4f5-7b5b-4aa6-b133-0f05be1bbebe" width="200"/>
<img src="https://github.com/user-attachments/assets/297f5649-60e9-494d-9a3c-92a73f496956" width="200"/>
<img src="https://github.com/user-attachments/assets/bffbaf37-af2e-40e1-93b7-c2a8b79fa23d" width="200"/>
<img src="https://github.com/user-attachments/assets/97a52164-f731-4421-a7e5-51703dc6839d" width="200"/>

---

## Architecture & Approach

The app follows TCA-first architecture, making state management, dependency injection, and side effects clear and composable:

- **`@Reducer` for handling app logic in `ToDoListFeature`
- **`@ObservableState` & `@Bindable` for seamless state/UI sync
- **`@DependencyClient` for easily swapping in persistence layers
- **`IdentifiedArrayOf<ToDoModel>` for managing lists of tasks
- **Tightly scoped actions and reducer logic keep the app predictable

Folder structure includes:

- Models/ – Task data model (ToDoModel.swift)
- Features/ – Core feature reducer (ToDoListFeature.swift)
- Views/ – Main UI (ToDoListView, ToDoRowView)
- Dependencies/ – Custom dependencies (ToDoPersistence)

---

## Challenges Faced

- Data persistence: Encoded/decoded full model arrays to/from UserDefaults safely
- TCA integration: Balanced logic, binding, and view actions cleanly for long-term maintainability
