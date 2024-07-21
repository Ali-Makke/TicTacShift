import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  //collection reference
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
    return await usersCollection.doc(uid).set({
      'username': username,
      'email': email,
      'uid': uid,
      'games_won': 0,
      'games_played': 0,
      'win_streak': 0,
      'games_lost': 0,
      'total_time_played': 0,
      'created_at': FieldValue.serverTimestamp(),
      'played_for': FieldValue.serverTimestamp()
    });
  }

  Future<DocumentReference> createGame(String player1Id) async {
    String letter = (Random().nextBool()) ? "X" : "O";
    return await gamesCollection.add({
      'player1Id': player1Id,
      'player2Id': null,
      'player1Letter': letter,
      'player2Letter': (letter == "X") ? "O" : "X",
      'currentTurn': "X",
      'moveCount': 0,
      'boardState': '--------- 0 X',
      'player1TimeRemaining': 300,
      'player2TimeRemaining': 300,
      'status': 'waiting',
      'game_created_at': FieldValue.serverTimestamp()
    });
  }

  Future updateBoardState(String gameId, String boardState, String currentTurn,
      int moveCount) async {
    await gamesCollection.doc(gameId).update({
      'boardState': boardState,
      'currentTurn': currentTurn,
      'moveCount': (moveCount + 1)
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
}
