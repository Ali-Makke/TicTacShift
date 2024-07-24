import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/database.dart';
import 'game_detail_page.dart';

class GameHistoryPage extends StatefulWidget {
  final UserModel playerId;

  const GameHistoryPage({super.key, required this.playerId});

  @override
  State<GameHistoryPage> createState() => _GameHistoryPageState();
}

class _GameHistoryPageState extends State<GameHistoryPage> {
  final DatabaseService _dbService = DatabaseService();
  List<Map<String, dynamic>> _games = [];

  @override
  void initState() {
    super.initState();
    fetchGameHistory();
  }

  Future<void> fetchGameHistory() async {
    final games = await _dbService.getGamesByUserId(widget.playerId.uid!);
    setState(() {
      _games = games;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Game History"),
        backgroundColor: Colors.redAccent,
      ),
      body: _games.isEmpty
          ? const Center(child: Text('No games found'))
          : ListView.builder(
              itemCount: _games.length,
              itemBuilder: (context, index) {
                final game = _games[index];
                return ListTile(
                  title: Text('Game ${game['gid']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameDetailPage(game: game),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
