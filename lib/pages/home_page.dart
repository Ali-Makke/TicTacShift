import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_shift/common/constants.dart';
import 'package:tic_tac_shift/models/user_model.dart';
import 'package:tic_tac_shift/pages/friend_invite_page.dart';
import 'package:tic_tac_shift/pages/game_history_page.dart';
import 'package:tic_tac_shift/pages/local_game.dart';
import 'package:tic_tac_shift/pages/online_game.dart';
import 'package:tic_tac_shift/services/auth_service.dart';

import 'account_page.dart';
import 'ai_difficulty_page.dart';
import 'choose_board_size_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    final userInfo = Provider.of<UserModel>(context);

    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        title: sandText("Home Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AccountPage(playerId: userInfo),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildElevatedButton(
                context,
                label: "Start Online Match",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => OnlineGame(playerId: userInfo),
                    ),
                  );
                },
              ),
              _buildElevatedButton(
                context,
                label: "Local Play",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LocalGame(),
                    ),
                  );
                },
              ),
              _buildElevatedButton(
                context,
                label: "Classic Play",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ChooseBoardSizePage(),
                    ),
                  );
                },
              ),
              _buildElevatedButton(
                context,
                label: "Play Against AI",
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AiDifficultyPage()));
                },
              ),
              _buildElevatedButton(
                context,
                label: "Invite Friend",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FriendInvite(),
                    ),
                  );
                },
              ),
              _buildElevatedButton(
                context,
                label: "Game History",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GameHistoryPage(playerId: userInfo),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildElevatedButton(BuildContext context,
      {required String label, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          textStyle: const TextStyle(fontSize: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: sandText(label),
      ),
    );
  }
}
