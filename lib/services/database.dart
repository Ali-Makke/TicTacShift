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
      'boardStates': ['--------- 0 X'],
      'status': 'waiting',
      'boardState': '--------- 0 X',
      'player1Letter': letter,
      'player2Letter': (letter == "X") ? "O" : "X",
      'player1': [0, 0, 0],
      'player2': [0, 0, 0],
      'player1TimeRemaining': 110.0,
      'player2TimeRemaining': 110.0,
      'game_created_at': FieldValue.serverTimestamp()
    });
  }

  Future updateBoardState(
      String gameId,
      String boardState,
      List<String> boardStates,
      String currentTurn,
      int moveCount,
      double player1TimeRemaining,
      double player2TimeRemaining,
      bool hasQuitMatch,
      List<int> player1,
      List<int> player2) async {
    boardStates.add(boardState);

    await gamesCollection.doc(gameId).update({
      'boardState': boardState,
      'boardStates': boardStates,
      'currentTurn': currentTurn,
      'moveCount': (moveCount + 1),
      'player1TimeRemaining': player1TimeRemaining,
      'player2TimeRemaining': player2TimeRemaining,
      'player1': player1,
      'player2': player2,
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

  final String _baseUrl = "tictacshift.scienceontheweb.net";

  Future<void> addUser(String uid, String username, String email) async {
    try {
      final url = Uri.http(_baseUrl, '/addUser.php');
      final response = await http.post(
        url,
        body: {
          'uid': uid,
          'username': username,
          'email': email,
        },
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        print("User added successfully");
      } else {
        print('Failed to add user');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> addGame(
      List<String> boardStates, String player1Id, String player2Id) async {
    try {
      final url = Uri.http(_baseUrl, '/addGame.php');

      final response = await http.post(
        url,
        body: {
          'board_states': boardStates.join(','),
          'player1Id': player1Id,
          'player2Id': player2Id,
        },
      );

      if (response.statusCode == 200) {
        print("Game added successfully");
      } else {
        print('Failed to add game');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<List<String>> getUserById(String uid) async {
    try {
      final url = Uri.http(_baseUrl, '/getUserById.php');
      final response = await http.post(
        url,
        body: {'uid': uid},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return [
          data['username'],
          data['email'],
          data['uid'],
          data['games_won'],
          data['games_played'],
          data['win_streak'],
          data['games_lost'],
          data['total_time_played'],
          data['highest_streak']
        ];
      } else {
        print('Failed to fetch user');
        return [];
      }
    } catch (e) {
      print('Error occurred: $e');
      return [];
    }
  }

  Future<void> updateUser(
      String uid, bool won, double timePlayedSeconds) async {
    try {
      final url = Uri.http(_baseUrl, '/update_user_stats.php');
      final response = await http.post(
        url,
        body: {
          'uid': uid,
          'won': won.toString(),
          'time_played_seconds': timePlayedSeconds.toString(),
        },
      );

      if (response.statusCode == 200) {
        print('User Stats updated');
        print(response.body);
      } else {
        print('Failed to update user');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getGamesByUserId(String uid) async {
    try {
      final url = Uri.http(_baseUrl, '/getGamesByUserId.php');
      final response = await http.post(url, body: {'uid': uid});

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print('Failed to fetch games.');
        return [];
      }
    } catch (e) {
      print('Error occurred: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getLeaderboardData(String uid) async {
    final url = Uri.http(_baseUrl, '/get_leaderboard_info.php');
    final response = await http.post(
      url,
      body: {'uid': uid},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load leaderboard data');
    }
  }
}
