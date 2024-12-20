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
  
- **A suitable IDE for flutter as described in the official Guide**
  [Official Instructions for Intstallation](https://docs.flutter.dev/get-started/install)
  
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
   
  **For iOS:**
  
  Connect your iOS device via USB or connect your chosen Simulator correctly.
  
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

Our App has the following functionalities: So the app is supposed to be used in a household/family, sO Users can join or create a Household group. 
which is why for a Userfor our app:
  One can assign ToDos to a particular other user (in the same household) or no one (meaning this toDo has to be done, so someone should take it on)
  For each ToDo a reward in points, A category, difficulty, a name and a description has to be specified. 
  Users can earn points by completing ToDos.
  
### Home Page
  So on the upper half of The home page, there is a leaderboard showing top 3 users with most points on a podium. bottom half of home page has Open tasks: which is the toDos that have been assigned to the User but not yet accepted by them.
  
  The User can click on a toDo to see description as well and just more info about ToDo. Here the user can see the deadline, reward, category, name etc. of the toDo:
  
  The User can accept or decline, in each case a pop up pops up making sure the user really wanted this as the action cannot be reversed. For declining a toDo the User has to write a reason, else it will not work.
  
  When a User accepts a task, a small notification shows up at the bottom of the screen that says, accepted ToDo has now been move to myToDos so User knows.
<p align="left" width="100%">
<img height="400" src="img/images for high fi/HomeScreen.png">
<img height="400" src="img/images for high fi/DisplayToDo.png">
<img height="400" src="img/images for high fi/sureAcceptToDo.png">
<img height="400" src="img/images for high fi/sureDeclineToDo.png">
<img height="400" src="img/images for high fi/declineReason.png">
<img height="400" src="img/images for high fi/Screenshot_1733313265.png">
<img height="400" src="img/images for high fi/Screenshot_1733245428.png">
</p>

### MyTodos
The user can navigate from one page to another with the menu.

The myToDos page has the accepted, but not yet completed ToDos and also the completed ToDos in the last 30 days.
When a User completes a ToDo a small animation pops up.

<p align="left" width="100%">
<img height="400" src="img/images for high fi/MyToDosLeer.png">
<img height="400" src="img/images for high fi/myToDos.png">
<img height="400" src="img/images for high fi/Screenshot_1733313327.png">
</p>

### HouseTodos
HouseToDos page is where all the ToDos of the household are stored. So the users ToDos as well as any that are assigned to another user, or unassigned. 

A User can take over a toDo from another household member. 

The ToDos are clickable, in homeScreen, in myTodos and in HouseToDos. 

Also in the homescreen and in my ToDos there is an add ToDo button where you can add a ToDo, you have to specify the category, which user assign to can be no one or a particular user.

Here the Users that have the category in their preferences are displayed at the top and are marked appropriately. Then after you have to specify title, reward, due date, difficulty, description.

<p align="left" width="100%">
<img height="400" src="img/images for high fi/HouseToDos.png">
<img height="400" src="img/images for high fi/DisplayToDo.png">
<img height="400" src="img/images for high fi/assignToDo.png">
<img height="400" src="img/images for high fi/Screenshot_1733314149.png">
</p>

### Instructions

In the Instructions page are instructions on how to do stuff, as can be seen in the pictures. One can filter by category or use the searchbar to search for sth. 

The Instructions are clickable, clicking on an instruction displays it. This display shows the category etc. and the description and also here you can see the delete and edit buttons. You can see in the last picture how it looks when you edit a description.

<p align="left" width="100%">
<img height="400" src="img/images for high fi/InstructionsA2.png">
<img height="400" src="img/images for high fi/DisplayInstr.png">
<img height="400" src="img/images for high fi/editInstr.png">
</p>

### Calendar

The calendar page is a calendar where for each date, by clicking on it you can see the household ToDos for that day. There is a button for adding ToDos at the bottom as well. The blue points indicate on which date how many ToDos are due (so you see before clicking). 

<p align="left" width="100%">
<img height="400" src="img/images for high fi/Calendar.png">
<img height="400" src="img/images for high fi/CalendarToDos.png">
</p>

### Ranklist, Options and Profile

The Ranklist Screen shows the ranklist of Users by points. 

The Options Screen is where you can enable/disable permissions.

In the profile screen you can see your profile picture, you can change it and depending on your permissions take a new picture with camera or take one from your gallery, you see the distribution of which kind of tasks you did and other things as shown in picture below:

<p align="left" width="100%">
<img height="400" src="img/images for high fi/Ranklist.png">
<img height="400" src="img/images for high fi/Options.png">
<img height="400" src="img/images for high fi/Screenshot_1733316362.png">
</p>
