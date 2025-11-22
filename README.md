# easacc_task
[![Ask DeepWiki](https://devin.ai/assets/askdeepwiki.png)](https://deepwiki.com/Badr-Elarby/easacc_task)

This is a multi-platform Flutter application designed to demonstrate a clean architecture approach. The application includes features for user authentication, device hardware interaction (Bluetooth and WiFi scanning), and web content display.

## Core Features

*   **User Authentication**:
    *   Sign-in with Google using Firebase Authentication.
    *   Sign-in with Facebook via a WebView-based authentication flow.
*   **Settings & Device Interaction**:
    *   Scan for nearby Bluetooth devices and display them in a dropdown.
    *   Scan for available WiFi networks and list their SSIDs.
    *   Input a URL to be opened in a dedicated WebView screen.
*   **Web Content Display**:
    *   An integrated WebView screen to load and display web pages from a user-provided URL.
*   **State Management & Architecture**:
    *   Utilizes `flutter_bloc` (Cubit) for predictable state management.
    *   Implements dependency injection using `get_it` for a decoupled and testable codebase.
    *   Declarative routing managed by `go_router`.

## Project Structure

The project is organized using a feature-first clean architecture pattern, promoting separation of concerns and scalability.

```
lib
├── core/
│   ├── di/                 # Dependency injection setup (GetIt)
│   ├── routing/            # Application routes (GoRouter)
│   └── services/           # Core services (e.g., LocalStorage)
│
└── features/
    ├── auth/               # User authentication feature
    │   ├── data/
    │   │   ├── datasources/  # Firebase, local data sources
    │   │   ├── models/       # User data model
    │   │   └── repositories/ # Auth repository implementation
    │   └── presentation/
    │       ├── cubits/       # Login business logic
    │       └── screens/      # UI for login
    │
    ├── settings/           # Settings and device scanning feature
    │   ├── data/
    │   │   ├── datasources/  # Device data sources (Bluetooth, WiFi)
    │   │   └── repositories/ # Device repository implementation
    │   └── presentation/
    │       ├── cubits/       # Settings business logic
    │       ├── screens/      # UI for settings
    │       └── widgets/      # Reusable widgets for the settings screen
    │
    └── webview/            # WebView display feature
        └── presentation/
            └── screens/      # UI for the WebView
```

## Key Technologies & Libraries

*   **State Management**: `flutter_bloc`
*   **Dependency Injection**: `get_it`
*   **Routing**: `go_router`
*   **Authentication**: `firebase_auth`, `google_sign_in`
*   **Device Scanning**: `flutter_blue_plus`, `wifi_scan`, `permission_handler`
*   **Web**: `webview_flutter`
*   **Local Storage**: `shared_preferences`

## Getting Started

### Prerequisites

*   Flutter SDK installed on your machine.

### Installation & Setup

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/badr-elarby/easacc_task.git
    cd easacc_task
    ```

2.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

3.  **Firebase Configuration**: This project uses Firebase for Google authentication.
    *   Create a new project on the [Firebase Console](https://console.firebase.google.com/).
    *   Follow the instructions to add an Android and/or iOS app.
    *   Download your own `google-services.json` for Android and place it in `android/app/`.
    *   Download your own `GoogleService-Info.plist` for iOS and configure it in Xcode.
    *   Update `lib/firebase_options.dart` with your project's configuration details. You can generate this file automatically using the FlutterFire CLI.

4.  **Facebook Login Configuration**:
    *   Set up an app on the [Facebook for Developers](https://developers.facebook.com/) portal.
    *   Update the `FacebookAppID` in `ios/Runner/Info.plist` with your own App ID.
    *   For Android, you will need to add your Facebook App ID to the string resources and `AndroidManifest.xml`.

### Running the Application

Once the setup is complete, run the application using:

```sh
flutter run


```



## 📱 App Main Screens (1 → 10)

| Screen 1 | Screen 2 | Screen 3 |
|----------|----------|----------|
| ![](media/screen_1.jpg) | ![](media/screen_2.jpg) | ![](media/screen_3.jpg) |

| Screen 4 | Screen 5 | Screen 6 |
|----------|----------|----------|
| ![](media/screen_4.jpg) | ![](media/screen_5.jpg) | ![](media/screen_6.jpg) |

| Screen 7 | Screen 8 | Screen 9 |
|----------|----------|----------|
| ![](media/screen_7.jpg) | ![](media/screen_8.jpg) | ![](media/screen_9.jpg) |

| Screen 10 |
|-----------|
| ![](media/screen_10.jpg) |

---



## 🎥 Demo Video / GIF

![](media/demo.gif)

---

