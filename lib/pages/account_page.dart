import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Account"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Colors.blueAccent),
                const SizedBox(width: 8.0),
                Text(
                  "Username: ${userInfo.username}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                const Icon(Icons.email, color: Colors.blueAccent),
                const SizedBox(width: 8.0),
                Text(
                  "Email: ${userInfo.email}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                const Icon(Icons.email, color: Colors.blueAccent),
                const SizedBox(width: 8.0),
                Text(
                  "Id: ${userInfo.uid}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            const Text(
              "Stats",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent),
            ),
            const SizedBox(height: 12.0),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Center(
                child: Text(
                  "Stats Data",
                  style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              "Leader Board",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent),
            ),
            const SizedBox(height: 12.0),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Center(
                child: Text(
                  "Leader Board Data",
                  style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
