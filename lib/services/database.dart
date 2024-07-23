import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  //collection references
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("Users");

  final CollectionReference gamesCollection =
      FirebaseFirestore.instance.collection("Games");

  final CollectionReference challengesCollection =
      FirebaseFirestore.instance.collection("Challenges");

  final CollectionReference leaderBoardCollection =
      FirebaseFirestore.instance.collection("LeaderBoard");

  Future<bool> isUsernameTaken(username) async {
    QuerySnapshot result =
        await usersCollection.where('username', isEqualTo: "$username").get();
    if (result.docs.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future searchForUser(String username) async {
    List<String> usernames = [];
    try {
      QuerySnapshot result = await usersCollection
          .limit(10)
          .orderBy('username')
          .startAt([username]).endAt(['$username\uf8ff']).get();
      for (var docSnapshot in result.docs) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        usernames.add(data['username']);
      }
    } catch (e) {
      print(e.toString());
    }
    return usernames;
  }

  Future updateUserData(String username, String email) async {
    addUser(uid!, username, email); //add user to sql database
    return await usersCollection.doc(uid).set({
      'username': username,
      'email': email,
      'uid': uid,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentReference> createGame(String player1Id) async {
    String letter = (Random().nextBool()) ? "X" : "O";
    return await gamesCollection.add({
      'moveCount': 0,
      'currentTurn': "X",
      'player1Id': player1Id,
      'player2Id': null,
      'status': 'waiting',
      'boardState': '--------- 0 X',
      'player1Letter': letter,
      'player2Letter': (letter == "X") ? "O" : "X",
      'player1TimeRemaining': 300,
      'player2TimeRemaining': 300,
      'game_created_at': FieldValue.serverTimestamp()
    });
  }

  Future updateBoardState(
      String gameId,
      String boardState,
      String currentTurn,
      int moveCount,
      int player1TimeRemaining,
      int player2TimeRemaining,
      bool hasQuitMatch) async {
    await gamesCollection.doc(gameId).update({
      'boardState': boardState,
      'currentTurn': currentTurn,
      'moveCount': (moveCount + 1),
      'player1TimeRemaining': player1TimeRemaining,
      'player2TimeRemaining': player2TimeRemaining,
      if (hasQuitMatch) 'status': 'quit',
    });
  }

  Future updateGameWithPlayer2(String gameId, String player2Id) async {
    await gamesCollection.doc(gameId).update({
      'player2Id': player2Id,
      'status': 'ready',
    });
  }

  Future createChallenge(String challengerId, String challengedId) async {
    await challengesCollection.add({
      'challengerId': challengerId,
      'challengedId': challengedId,
      'status': 'pending',
      'challenge_created_at': FieldValue.serverTimestamp(),
      'expiresAt':
          Timestamp.fromDate(DateTime.now().add(const Duration(minutes: 30))),
    });
  }

  Future updateChallengeStatus(String challengeId, String status) async {
    await challengesCollection.doc(challengeId).update({'status': status});
  }

  Future updateLeaderboard(String userId, int wins, int losses) async {
    await leaderBoardCollection.doc(userId).set({
      'userId': userId,
      'wins': wins,
      'losses': losses,
      'winRate': wins / (wins + losses)
    });
  }

  /*
  *
  * All the functions above use firebase services to connect to noSQL real-time database
  * All the functions below use restful services to connect to SQL database
  *
  */
  Future<void> addUser(String uid, String username, String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://tictacshift.scienceontheweb.net/addUser.php'),
        body: {
          'uid': uid,
          'username': username,
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);
      } else {
        print('Failed to add user');
        print(response.statusCode);
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
