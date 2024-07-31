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
  List<dynamic> topScores = [];
  Map<String, dynamic>? userScore;

  @override
  void initState() {
    super.initState();
    getUsername(widget.playerId.uid!);
    getLeaderboard(widget.playerId.uid!);
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

  void getLeaderboard(String uid) async {
    final result = await _dbService.getLeaderboardData(uid);
    setState(() {
      topScores = result['top_scores'];
      userScore = result['user_score'];
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
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26.withOpacity(0.1),
            blurRadius: 6.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatTile(Icons.play_arrow, 'Games Played', gamesPlayed),
          _buildStatTile(Icons.star, 'Games Won', gamesWon),
          _buildStatTile(Icons.cancel, 'Games Lost', gamesLost),
          _buildStatTile(Icons.trending_up, 'Win Streak', winStreak),
          _buildStatTile(Icons.trending_up, 'Highest Streak', highestStreak),
          _buildStatTile(Icons.timer, 'Total Time Played', totalTimePlayed),
        ],
      ),
    );
  }

  Widget _buildStatTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 24.0),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardContainer() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26.withOpacity(0.1),
            blurRadius: 6.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: userScore != null
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: topScores.length + 1,
              itemBuilder: (context, index) {
                if (index < topScores.length) {
                  final score = topScores[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        child: Text('${index + 1}'),
                      ),
                      title: Text(
                        score['username']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Score: ${score['score']}'),
                      trailing: Text(
                        'Rank: ${index + 1}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                } else {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent.withOpacity(0.2),
                        child: Icon(Icons.star, color: Colors.yellow[700]),
                      ),
                      title: Text(
                        'You: ${userScore!['username']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Your Score: ${userScore!['score']}'),
                      trailing: Text(
                        'Your Rank: ${userScore!['rank']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
              },
            )
          : const Center(
              child: Text(
                'No leaderboard data available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
    );
  }
}
