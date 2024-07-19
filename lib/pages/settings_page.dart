import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.brown[400],
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
      ),
      body: const SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text("Account:", style: TextStyle(fontSize: 35)),
              SizedBox(
                width: 375,
                height: 200,
                child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.brown)),
              ),
              Text("Statistics:", style: TextStyle(fontSize: 35)),
              SizedBox(
                width: 375,
                height: 200,
                child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.brown)),
              ),
              Text("Leader Board:", style: TextStyle(fontSize: 35)),
              SizedBox(
                width: 375,
                height: 200,
                child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.brown)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
