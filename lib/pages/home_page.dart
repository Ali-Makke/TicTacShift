import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_shift/models/user_model.dart';
import 'package:tic_tac_shift/pages/local_game.dart';
import 'package:tic_tac_shift/pages/online_game.dart';
import 'package:tic_tac_shift/pages/settings_page.dart';
import 'package:tic_tac_shift/services/auth_service.dart';

import 'account_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    final userInfo = Provider.of<UserModel>(context);
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        foregroundColor: Colors.white,
        title: const Text("Home Page"),
        actions: [
          ElevatedButton.icon(
            label: const Text("LogOut"),
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
            },
          ),
          TextButton.icon(
            label: const Text(""),
            icon:
                const Icon(Icons.account_circle_outlined, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AccountPage()));
            },
          ),
          TextButton.icon(
            label: const Text(""),
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SettingsPage(),
              ));
            },
          )
        ],
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OnlineGame(playerId: userInfo.uid!)));
              },
              child: const Text("Start Online Match")),
          const SizedBox(height: 60),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => LocalGame()));
              },
              child: const Text("Local play")),
          const SizedBox(height: 60),
          ElevatedButton(
              onPressed: () {}, child: const Text("Play against AI")),
          const SizedBox(height: 60),
          ElevatedButton(
              onPressed: () {}, child: const Text("Play against friend")),
        ],
      )),
    );
  }
}
