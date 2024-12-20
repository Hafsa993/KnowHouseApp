import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/user_provider.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../widgets/menu_drawer.dart';

class RankingScreen extends StatelessWidget {

 

  const RankingScreen({super.key}); 

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    var currUsers = userProvider.currUsers;
    User currentUser = Provider.of<UserProvider>(context).getCurrUser();
    
    currUsers.sort((a, b) {
      if (b.points == a.points) {
        return a.username.compareTo(b.username); // Tie-breaker: alphabetical order
      }
      return b.points.compareTo(a.points); // Primary sorting: points descending
    });
        // Assign ranks
    List<Map<String, dynamic>> rankedUsers = [];
    int rank = 0;
    int count = 0; // Number of users processed
    int previousPoints = -1;
    List<int> uniqueRanks = [];

    for (int i = 0; i < currUsers.length; i++) {
      User user = currUsers[i];
      count++;

      if (user.points != previousPoints) {
        rank = count;
        uniqueRanks.add(rank);
      }

      rankedUsers.add({
        'user': user,
        'rank': rank,
      });

      previousPoints = user.points;
    }

    // Map medal colors to the first three unique ranks, so multiple people can be on any rank
    Map<int, Color> rankMedalColors = {};
    for (int i = 0; i < uniqueRanks.length; i++) {
      int uniqueRank = uniqueRanks[i];
      if (i == 0) {
        rankMedalColors[uniqueRank] = const Color.fromARGB(255, 249, 187, 1); // Gold
      } else if (i == 1) {
        rankMedalColors[uniqueRank] = const Color.fromARGB(255, 155, 153, 153); // Silver
      } else if (i == 2) {
        rankMedalColors[uniqueRank] = const Color.fromARGB(255, 192, 118, 8); // Bronze
      } else {
        rankMedalColors[uniqueRank] = Colors.transparent; // No medal
      }
    }
    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 211, 239, 247),$
      //backgroundColor: const Color.fromARGB(255, 226, 224, 224),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 226, 224, 224),
        title: const Text('Rankings'),
      ),
      drawer: const MenuDrawer(),
      body: ListView.builder(
        itemCount: rankedUsers.length,
        itemBuilder: (context, index) {
          User currUser = rankedUsers[index]['user'];
          int rank = rankedUsers[index]['rank'];

          // medal color for the user's rank
          Color medalColor = rankMedalColors[rank]!;

          return Card(
            color: currUser.username == currentUser.username? Color.fromARGB(255, 170, 229, 240): Color.fromARGB(255, 255, 255, 255),
            elevation: 6,
            child: ListTile(
              minTileHeight: 80,
              leading: CircleAvatar(
                backgroundColor: medalColor,
                child: Text(
                  rank.toString(),
                  style: TextStyle(
                    color: medalColor == Colors.transparent ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              title: Text(currUser.username,style:TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),),
              subtitle: currUser.username == currentUser.username? Text("You",style: TextStyle(color: Colors.red),): null,
              trailing: 
                Text(
                '${currUser.points} pts',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 3, 158, 8),
                  fontSize: 16,
                ),
              ),
            ),
            
          );
        },
      ),
    );
  }
}

List<String> sortUsers(users) {

    var userNames = <String>[];
    for (User user in users){
      userNames.add(user.username);
    }
    return userNames;
}