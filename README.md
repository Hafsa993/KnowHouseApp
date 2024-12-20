# KnowHouseApp
KnowHouse Mobile App built out of
ETH Zurich HCI course project HS2024 High Fidelity Prototype,
Topic: Mental Load, Household Knowledgebase
>🔗 [Github of full HCI Project](https://github.com/eth-hci-course/hci-project-2024-hci2024-group-14)

## Getting Started

These instructions will help you download and run the project locally on your machine.

### Prerequisites

- **Flutter SDK:**  
  Make sure you have the Flutter SDK installed. You can follow the official installation guide here:  
  [Official Instructions for Intstallation](https://docs.flutter.dev/get-started/install)

- **Dart SDK:**  
  The Dart SDK is bundled with Flutter, so no separate action is required if you followed the Flutter installation steps.
  
- **A suitable IDE for flutter as described on the official Guide**
  [Official Instructions for Intstallation](https://docs.flutter.dev/get-started/install)
  
### Downloading the Project

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/Hafsa993/KnowHouseApp.git

2. **Navigate into the Project Directory:**
    ```bash
    cd household_knwoledge_app
    ```

3. **Install Dependencies:**
Once you have the project downloaded, install the necessary dependencies:
From the project's root directory, run:
    ```bash
    flutter pub get
    ```


## Running/Installing the App


  After setting up the project and installing dependencies, you're ready to run the app:
  Connect a Device or Start an Emulator:
  
  **For Android:**
  
   Connect your Android device via USB and ensure USB debugging is enabled or connect your chosen Emulator correctly.
   
  **For iOS:**
  
  Connect your iOS device via USB or connect your chosen Simulator correctly.
  
  **Run the App:**
  
  In the project's root directory, execute:

      flutter run
    
  This command compiles the app and launches it on the connected device or emulator.

  ### Additional Commands
  Here are some useful Flutter commands for building and managing your app:
  
  Build a Release APK (Android):
  

    flutter build apk --release
 
  The generated APK will be located at build/app/outputs/flutter-apk/app-release.apk.
  
  **Build an Android Release App Bundle:**
  

    flutter build appbundle --release

  
  **Build an iOS Release Build (macOS only):**


    flutter build ios --release

  **Install on your device:**

    flutter install
