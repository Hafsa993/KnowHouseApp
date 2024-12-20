import 'dart:io';
import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/user_model.dart';

class UserProvider with ChangeNotifier {
  // Initialize currUsers with predefined users
  final List<User> _currUsers = [
    User(
      username: 'JohnDoe',
      points: 100,
      role: 'Member',
      preferences: ['Cleaning', 'Cooking'],
      contributions: {'Cleaning': 50, 'Gardening': 30, 'Cooking': 20, "Shopping": 0, "Planning" : 0,"Care" : 0,"Maintenance" : 0,"Other" : 0},
      profilepath: "lib/assets/f.jpeg",
    ),
    User(username: 'Sarah',preferences: ["Gardening","Shopping"], points: 122, contributions: {'Cleaning': 50, 'Gardening': 30, 'Cooking': 20, "Shopping": 0, "Planning" : 0,"Care" : 0,"Maintenance" : 0,"Other" : 0}, profilepath: "lib/assets/sarah.jpeg",),
    User(username: 'Max', preferences: ["Shopping","Planning",],points: 125, contributions: {'Cleaning': 50, 'Gardening': 30, 'Cooking': 20, "Shopping": 0, "Planning" : 0,"Care" : 0,"Maintenance" : 0,"Other" : 0}, profilepath: "lib/assets/max.jpeg",),
    User(username: 'Anna', preferences: ["Planning","Care",], contributions: {'Cleaning': 50, 'Gardening': 30, 'Cooking': 20, "Shopping": 0, "Planning" : 0,"Care" : 0,"Maintenance" : 0,"Other" : 0}, points: 90),
    User(username: 'Marie', preferences: ['Cleaning', "Maintenance",], contributions: {'Cleaning': 50, 'Gardening': 30, 'Cooking': 20, "Shopping": 0, "Planning" : 0,"Care" : 0,"Maintenance" : 0,"Other" : 0}, points: 100),
    User(username: 'Alex', preferences: ['Gardening', 'Cooking'], contributions: {'Cleaning': 50, 'Gardening': 30, 'Cooking': 20, "Shopping": 0, "Planning" : 0,"Care" : 0,"Maintenance" : 0,"Other" : 0}, points: 75),
  ];

  // Getter to access currUsers
  List<User> get currUsers => _currUsers;

  // Method to add a new user
  void addUser(User user) {
    _currUsers.add(user);
    notifyListeners();
  }

  // Method to remove a user
  void removeUser(User user) {
    _currUsers.remove(user);
    notifyListeners();
  }

  // Method to update a user
/*   void updateUser(int index, User updatedUser) {
    if (index >= 0 && index < _currUsers.length) {
      _currUsers[index] = updatedUser;
      notifyListeners();
    }
  } */

  void addPointsToUser(int index, int pointsToAdd) {
    if (index >= 0 && index < _currUsers.length) {
      _currUsers[index].addPoints(pointsToAdd);
      notifyListeners();
    }
  }
  User getCurrUser() {
    return _currUsers.firstWhere((user) => user.username == 'JohnDoe');
  }
  
  ImageProvider<Object> getProfileOfCurrUser() {
    String p = getCurrUser().profilepath;
    if ( p == "lib/assets/f.jpeg") {
      return AssetImage(p);
    } else {
      return FileImage(File(p));
    }
  }
  // Additional methods as needed...
}
