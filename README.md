# KnowHouseApp
KnowHouse Mobile App for iOS and Android

## Getting Started

These instructions will help you download and run the project locally on your machine.

### Prerequisites

- **Flutter SDK:**  
  Make sure you have the Flutter SDK installed. You can follow the official installation guide here:  
  [Official Instructions for Installation](https://docs.flutter.dev/get-started/install)

- **Dart SDK:**  
  The Dart SDK is bundled with Flutter, so no separate action is required if you followed the Flutter installation steps.
  
- **A suitable IDE for flutter as described in the official Guide:**
  [Official Instructions for Installation](https://docs.flutter.dev/get-started/install)
  
## Downloading the Project

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
  
   For the Emulator see official Flutter Guide:
    [Official Instructions for Installation](https://docs.flutter.dev/get-started/install)
  
  choose: "your Operating System" -> Android
   
  **For iOS:**
  
  Connect your iOS device via USB or connect your chosen Simulator correctly.
  
  For more help see official Flutter Guide:
    [Official Instructions for Installation](https://docs.flutter.dev/get-started/install)
  
  choose: MacOs -> iOS
  
  **Run the App:**
  
  In the project's root directory, execute:

      flutter run
    
  This command compiles the app and launches it on the connected device or emulator.

  ### Additional Commands
  Here are some useful Flutter commands for building and managing your app:
  
  **Build a Release APK (Android):**
  

    flutter build apk --release
 
  The generated APK will be located at build/app/outputs/flutter-apk/app-release.apk.
  
  **Build an Android Release App Bundle:**
  

    flutter build appbundle --release

  
  **Build an iOS Release Build (macOS only):**


    flutter build ios --release

  **Install on your device:**

    flutter install
    
## About The App

KnowHouse is a mobile app designed for households and families to manage shared tasks and instructions in a collaborative, gamified, and user-friendly way.

### Core Features

- Real-Time Collaboration:
All household members see updates instantly—tasks, instructions, and points sync in real time across devices using Firebase.

- Smart Task Assignment:
Assign ToDos to specific users or leave them open for anyone to claim. Intelligent sorting highlights tasks that match user preferences.

- Gamified Progress & Leaderboard:
Earn points for completing tasks, climb the family leaderboard, and motivate everyone with friendly competition.

- Shared Household Calendar:
Visualize all ToDos and deadlines in a unified calendar view, making planning and coordination effortless.

- Dynamic Instructions Library:
Create, edit, and share household instructions (like “how to do laundry”)—searchable and filterable by category.

- Personalized Experience:
Users can set task preferences, customize profiles, and receive tailored task suggestions.

- Secure Authentication:
Robust email/password sign-in with Firebase Authentication ensures privacy and data security.

- Modern, Intuitive UI:
Clean, responsive design with smooth navigation and engaging animations for a delightful user experience.

### Functionality

- Join or create a household group.
- Assign ToDos to users or leave unassigned for anyone to take.
- Specify reward points, category, difficulty, name, and description for each ToDo.
- Earn points by completing ToDos.
- Shared household calendar.
- Shared list of instructions (e.g., how to do laundry), with add/edit/delete.
- Leaderboard, user profiles, and customizable preferences.
  
### Demo Video
Register Flow and App Demo:
(Family code is hidden for security reasons)




https://github.com/user-attachments/assets/35caf832-944c-465e-81e6-7a713fc1a89f




https://github.com/user-attachments/assets/a67d2d62-c475-40e8-a109-8530854366bd





### Sign In & Registration
Users can easily register or sign in with their email and password. During registration, users can join an existing family group or create a new one, and then specify their preferred household task categories for a personalized experience.

<p align="left" width="100%">
<img height="400" src="img/images for high fi/signIn.png">
<img height="400" src="img/images for high fi/Register.png">
<img height="400" src="img/images for high fi/FamChoice.png">
</p>

### Home Page
The Home Page features a dynamic leaderboard at the top, showcasing the top three users by points. Below, users see their open ToDos—tasks assigned to them but not yet accepted.
Clicking a ToDo reveals detailed information, including deadline, reward, category, and description.
Users can accept or decline tasks, with confirmation dialogs to prevent accidental actions. Declining requires a reason.
Upon accepting a task, users receive a notification confirming the task has moved to their "My ToDos" list.

<p align="left" width="100%">
<img height="400" src="img/images for high fi/HomeScreen.png">
<img height="400" src="img/images for high fi/DisplayToDo.png">
<img height="400" src="img/images for high fi/sureAcceptToDo.png">
<img height="400" src="img/images for high fi/sureDeclineToDo.png">
<img height="400" src="img/images for high fi/declineReason.png">
<img height="400" src="img/images for high fi/Screenshot_1733313265.png">
</p>

### Menu
Navigate easily between pages using the menu.

<p align="left" width="100%">
<img height="400" src="img/images for high fi/Screenshot_1733245428.png">
</p>

### My Todos
The My ToDos page displays tasks you have accepted but not yet completed, as well as those completed in the last 30 days.
Completing a ToDo triggers a small celebratory animation for positive feedback.

<p align="left" width="100%">
<img height="400" src="img/images for high fi/myToDos.png">
<img height="400" src="img/images for high fi/Screenshot_1757811490.png">
<img height="400" src="img/images for high fi/Screenshot_1733313327.png">
</p>

### House ToDos
The House ToDos page lists all tasks in the household—assigned, unassigned, or assigned to others.

- ToDo is taken: Already accepted by a user.
- Assigned to you: Assigned but not yet accepted by you.
- Take on ToDo: Unassigned tasks, open for anyone to claim.
- Users can also take over tasks from other members if they haven't been accepted yet.
  
 ToDos are clickable throughout the app for detailed views.
Adding a ToDo requires specifying category, assignee (or leave unassigned), title, reward, due date, difficulty, and description.
Users with matching category preferences are highlighted for quick assignment.

<p align="left" width="100%">
<img height="400" src="img/images for high fi/HouseToDos.png">
<img height="400" src="img/images for high fi/assignToDo.png">
<img height="400" src="img/images for high fi/Screenshot_1733314149.png">
</p>

### Instructions

The Instructions page provides a shared library of household instructions (e.g., how to do laundry).
Users can filter by category or search for specific instructions.
Instructions are clickable for detailed viewing, editing, or deletion.
The edit screen allows users to update descriptions and categories with ease.

<p align="left" width="100%">
<img height="400" src="img/images for high fi/InstructionsA2.png">
<img height="400" src="img/images for high fi/DisplayInstr.png">
<img height="400" src="img/images for high fi/editInstr.png">
</p>

### Calendar

The Calendar page displays all household ToDos by date.
Clicking a date shows the tasks due that day.
Blue dots indicate the number of ToDos per day at a glance.
A button at the bottom allows users to quickly add new ToDos.

<p align="left" width="100%">
<img height="400" src="img/images for high fi/Calendar.png">
<img height="400" src="img/images for high fi/CalendarToDos.png">
</p>

### Ranklist, Options and Profile

- Ranklist: View all users ranked by points.
- Options: Manage permissions and edit task preferences.
- Profile: View and update your profile picture (via camera or gallery, based on permissions), see your family id, preferred task categories, task distribution, and access sign out or delete account options.


<p align="left" width="100%">
<img height="400" src="img/images for high fi/Ranklist.png">
<img height="400" src="img/images for high fi/Options.png">
<img height="400" src="img/images for high fi/Screenshot_1757811511.png">
</p>
