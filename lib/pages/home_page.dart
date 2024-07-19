import 'package:flutter/material.dart';
import 'package:tic_tac_shift/pages/settings_page.dart';
import 'package:tic_tac_shift/services/auth_service.dart';

import 'account_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        foregroundColor: Colors.white,
        title: const Text("Home Page"),
        actions: [
          ElevatedButton.icon(
            label: const Text("LogOut", style: TextStyle(color: Colors.white)),
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await auth.signOut();
            },
          ),
          TextButton.icon(
            label: const Text(""),
            icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const AccountPage()));
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
          ElevatedButton(onPressed: () {}, child: const Text("New Match")),
          const SizedBox(height: 60),
          ElevatedButton(onPressed: () {}, child: const Text("Local play")),
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
