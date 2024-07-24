import 'package:flutter/material.dart';
import 'package:tic_tac_shift/common/loading.dart';

import '../models/user_model.dart';
import '../services/database.dart';

class AccountPage extends StatefulWidget {
  final UserModel playerId;

  const AccountPage({super.key, required this.playerId});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final DatabaseService _dbService = DatabaseService();
  String username = "";
  String gamesPlayed = "";
  String gamesWon = "";
  String gamesLost = "";
  String winStreak = "";
  String highestStreak = "";
  String totalTimePlayed = "";
  bool pageReady = false;

  @override
  void initState() {
    super.initState();
    getUsername(widget.playerId.uid!);
  }

  @override
  Widget build(BuildContext context) {
    return pageReady
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text("Account"),
              backgroundColor: Colors.redAccent,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildUserInfoRow(Icons.person, "Username: $username"),
                  _buildUserInfoRow(
                      Icons.email, "Email: ${widget.playerId.email}"),
                  _buildUserInfoRow(
                      Icons.card_membership, "ID: ${widget.playerId.uid}"),
                  const SizedBox(height: 24.0),
                  _buildSectionTitle("Stats"),
                  const SizedBox(height: 12.0),
                  _buildStatsContainer(),
                  const SizedBox(height: 24.0),
                  _buildSectionTitle("Leader Board"),
                  const SizedBox(height: 12.0),
                  _buildLeaderboardContainer(),
                ],
              ),
            ),
          )
        : const Loading();
  }

  void getUsername(String uid) async {
    final result = await _dbService.getUserById(uid);
    setState(() {
      username = result[0];
      gamesWon = result[3];
      gamesPlayed = result[4];
      winStreak = result[5];
      gamesLost = result[6];
      totalTimePlayed = result[7];
      highestStreak = result[8];
      pageReady = true;
    });
  }

  Widget _buildUserInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.redAccent,
      ),
    );
  }

  Widget _buildStatsContainer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26.withOpacity(0.1),
            blurRadius: 1.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '''
Games Played: $gamesPlayed
Games Won: $gamesWon
Games Lost: $gamesLost
Win Streak: $winStreak
Highest Streak: $highestStreak
Total Time Played: $totalTimePlayed
        ''',
        style: const TextStyle(
          fontSize: 16,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _buildLeaderboardContainer() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          "Leader Board Data",
          style: TextStyle(
            fontSize: 16,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
